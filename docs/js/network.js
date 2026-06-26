import { supabase } from './supabase.js'

const cyContainer = document.getElementById('cy')
const statusEl = document.getElementById('graph-status')
const categoryFilters = document.getElementById('category-filters')
const resetBtn = document.getElementById('reset-filter')
const sidebarContent = document.getElementById('sidebar-content')
const legendList = document.getElementById('legend-list')
const tooltip = document.getElementById('graph-tooltip')

let cy = null
let allEdges = []

async function init() {
  statusEl.textContent = 'Loading network data...'

  const { data: edges, error } = await supabase
    .from('v_supply_chain_graph')
    .select('*')
    .eq('link_active', true)

  if (error || !edges?.length) {
    statusEl.textContent = 'Error loading graph data.'
    return
  }

  allEdges = edges
  buildCategoryFilters(edges)
  renderGraph(edges)
}

function assignNodeIds(edges) {
  const map = new Map()
  let vCount = 1, dCount = 1

  edges.forEach(e => {
    if (!map.has(e.supplier_id)) {
      map.set(e.supplier_id, {
        id: e.supplier_id,
        shortId: `V${vCount++}`,
        label: e.supplier_name,
        type: e.supplier_type || 'vendor',
        slug: e.supplier_slug,
        website: e.supplier_website
      })
    }
    if (!map.has(e.buyer_id)) {
      map.set(e.buyer_id, {
        id: e.buyer_id,
        shortId: `D${dCount++}`,
        label: e.buyer_name,
        type: e.buyer_type || 'distributor',
        slug: e.buyer_slug,
        website: e.buyer_website
      })
    }
  })
  return map
}

function buildElements(edges, nodeMap) {
  const nodes = [...nodeMap.values()].map(n => ({
    data: { id: n.id, label: n.shortId, fullLabel: n.label, type: n.type, slug: n.slug, website: n.website }
  }))
  const edgeEls = edges.map((e, i) => ({
    data: {
      id: `e${i}`, source: e.supplier_id, target: e.buyer_id,
      shared_brands: e.shared_brands || [],
      shared_categories: e.shared_categories || [],
      link_type: e.link_type
    }
  }))
  return [...nodes, ...edgeEls]
}

function renderGraph(edges) {
  if (cy) cy.destroy()
  hideTooltip()

  const nodeMap = assignNodeIds(edges)
  const elements = buildElements(edges, nodeMap)
  const nodeCount = [...nodeMap.values()].length

  cy = cytoscape({
    container: cyContainer,
    elements,
    style: [
      {
        selector: 'node',
        style: {
          'label': 'data(label)',
          'font-size': '10px', 'font-weight': '600',
          'text-valign': 'center', 'text-halign': 'center',
          'color': '#fff', 'text-outline-width': '0',
          'width': '32px', 'height': '32px',
          'border-width': '2px', 'border-color': '#fff',
          'background-color': '#1a56db'
        }
      },
      { selector: 'node[type = "distributor"]', style: { 'background-color': '#d97706' } },
      { selector: 'node:selected', style: { 'border-color': '#1a1a2e', 'border-width': '3px', 'width': '40px', 'height': '40px' } },
      { selector: 'edge', style: { 'width': 1.5, 'line-color': '#ccc', 'target-arrow-color': '#aaa', 'target-arrow-shape': 'triangle', 'curve-style': 'bezier', 'opacity': 0.7 } },
      { selector: 'edge:selected', style: { 'line-color': '#1a56db', 'target-arrow-color': '#1a56db', 'opacity': 1, 'width': 2.5 } },
      { selector: '.faded', style: { 'opacity': 0.12 } }
    ],
    layout: { name: 'cose', animate: false, nodeRepulsion: 10000, idealEdgeLength: 140, gravity: 0.4, numIter: 1000, padding: 40 }
  })

  cy.on('tap', 'node', e => { hideTooltip(); showNodeDetail(e.target) })
  cy.on('tap', 'edge', e => { hideTooltip(); showEdgeDetail(e.target) })
  cy.on('tap', evt => { if (evt.target === cy) { clearSidebar(); hideTooltip() } })

  cy.on('mouseover', 'node', e => showTooltip(e.target, e.originalEvent))
  cy.on('mouseout',  'node', () => hideTooltip())
  cy.on('mousemove', 'node', e => moveTooltip(e.originalEvent))

  buildLegend(nodeMap)
  statusEl.textContent = `${nodeCount} companies · ${edges.length} supply chain links`
}

// ── Tooltip — position: fixed, uses raw clientX/Y
function showTooltip(node, evt) {
  tooltip.textContent = node.data('fullLabel')
  tooltip.style.display = 'block'
  moveTooltip(evt)
}

function moveTooltip(evt) {
  const offset = 14
  tooltip.style.left = (evt.clientX + offset) + 'px'
  tooltip.style.top  = (evt.clientY + offset) + 'px'
}

function hideTooltip() {
  tooltip.style.display = 'none'
}

// ── Sidebar: node
function showNodeDetail(node) {
  const { label, fullLabel, type, slug, website } = node.data()
  const neighbors = node.neighborhood('node')
  const pageUrl = type === 'vendor' ? `brand.html?slug=${slug}` : `distributor.html?slug=${slug}`

  sidebarContent.innerHTML = `
    <span class="badge">${type}</span>
    <h2><span class="node-id">${label}</span> ${fullLabel}</h2>
    ${website ? `<p><a href="${website}" target="_blank" rel="noopener">${website}</a></p>` : ''}
    <p class="muted" style="margin-top:0.75rem">Connected to (${neighbors.length}):</p>
    <ul>${neighbors.map(n => `<li><span class="node-id">${n.data('label')}</span> ${n.data('fullLabel')}</li>`).join('') || '<li><em>None</em></li>'}</ul>
    <a href="${pageUrl}" class="btn-primary sidebar-link">View Profile →</a>
  `
  cy.elements().addClass('faded')
  node.neighborhood().union(node).removeClass('faded')
}

// ── Sidebar: edge
function showEdgeDetail(edge) {
  const { shared_brands, shared_categories, link_type } = edge.data()
  const src = edge.source().data()
  const tgt = edge.target().data()

  sidebarContent.innerHTML = `
    <span class="badge">${link_type || 'supply'}</span>
    <h2><span class="node-id">${src.label}</span> → <span class="node-id">${tgt.label}</span></h2>
    <p>${src.fullLabel} → ${tgt.fullLabel}</p>
    ${shared_categories?.length ? `<p class="muted" style="margin-top:0.5rem">Categories: ${shared_categories.join(', ')}</p>` : ''}
    ${shared_brands?.length ? `<p class="muted">Brands: ${shared_brands.join(', ')}</p>` : ''}
  `
  cy.elements().addClass('faded')
  edge.union(edge.source()).union(edge.target()).removeClass('faded')
}

function clearSidebar() {
  sidebarContent.innerHTML = '<p class="muted">Click a node to see details.</p>'
  cy.elements().removeClass('faded')
}

// ── Legend
function buildLegend(nodeMap) {
  const vendors = [...nodeMap.values()].filter(n => n.type !== 'distributor').sort((a,b) => a.shortId.localeCompare(b.shortId, undefined, {numeric:true}))
  const distributors = [...nodeMap.values()].filter(n => n.type === 'distributor').sort((a,b) => a.shortId.localeCompare(b.shortId, undefined, {numeric:true}))

  legendList.innerHTML = `
    <div class="legend-section">
      <div class="legend-section-title vendor">Vendors</div>
      ${vendors.map(n => `<div class="legend-row"><span class="node-id vendor">${n.shortId}</span> ${n.label}</div>`).join('')}
    </div>
    <div class="legend-section">
      <div class="legend-section-title distributor">Distributors</div>
      ${distributors.map(n => `<div class="legend-row"><span class="node-id distributor">${n.shortId}</span> ${n.label}</div>`).join('')}
    </div>
  `
}

// ── Category filters
function buildCategoryFilters(edges) {
  const cats = [...new Set(edges.flatMap(e => e.shared_categories || []))].sort()
  categoryFilters.innerHTML = cats.map(cat =>
    `<button class="filter-btn" data-cat="${cat}">${cat}</button>`
  ).join('')
  categoryFilters.querySelectorAll('.filter-btn').forEach(btn =>
    btn.addEventListener('click', () => {
      const filtered = allEdges.filter(e => e.shared_categories?.includes(btn.dataset.cat))
      renderGraph(filtered)
      clearSidebar()
      categoryFilters.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'))
      btn.classList.add('active')
    })
  )
}

resetBtn.addEventListener('click', () => {
  renderGraph(allEdges)
  clearSidebar()
  categoryFilters.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'))
})

init()
