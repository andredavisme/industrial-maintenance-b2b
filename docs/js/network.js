import { supabase } from './supabase.js'

const cyContainer = document.getElementById('cy')
const statusEl = document.getElementById('graph-status')
const categoryFilters = document.getElementById('category-filters')
const resetBtn = document.getElementById('reset-filter')
const sidebarContent = document.getElementById('sidebar-content')

let cy = null
let allEdges = []

// ── Load & render ──────────────────────────────────────────────
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

// ── Build Cytoscape elements ───────────────────────────────────
function buildElements(edges) {
  const nodeMap = new Map()

  edges.forEach(e => {
    if (!nodeMap.has(e.supplier_id)) {
      nodeMap.set(e.supplier_id, {
        id: e.supplier_id,
        label: e.supplier_name,
        type: e.supplier_type || 'vendor',
        slug: e.supplier_slug,
        website: e.supplier_website
      })
    }
    if (!nodeMap.has(e.buyer_id)) {
      nodeMap.set(e.buyer_id, {
        id: e.buyer_id,
        label: e.buyer_name,
        type: e.buyer_type || 'distributor',
        slug: e.buyer_slug,
        website: e.buyer_website
      })
    }
  })

  const nodes = [...nodeMap.values()].map(n => ({
    data: { id: n.id, label: n.label, type: n.type, slug: n.slug, website: n.website }
  }))

  const edgeEls = edges.map((e, i) => ({
    data: {
      id: `e${i}`,
      source: e.supplier_id,
      target: e.buyer_id,
      shared_brands: e.shared_brands || [],
      shared_categories: e.shared_categories || [],
      link_type: e.link_type
    }
  }))

  return [...nodes, ...edgeEls]
}

// ── Render / re-render graph ───────────────────────────────────
function renderGraph(edges) {
  if (cy) cy.destroy()

  const elements = buildElements(edges)
  const nodeCount = elements.filter(el => !el.data.source).length
  const edgeCount = elements.filter(el => el.data.source).length

  cy = cytoscape({
    container: cyContainer,
    elements,
    style: [
      {
        selector: 'node',
        style: {
          'label': 'data(label)',
          'font-size': '11px',
          'text-valign': 'bottom',
          'text-halign': 'center',
          'text-margin-y': '4px',
          'color': '#333',
          'text-outline-color': '#fafafa',
          'text-outline-width': '2px',
          'width': '28px',
          'height': '28px',
          'border-width': '2px',
          'border-color': '#fff',
          'background-color': '#1a56db'
        }
      },
      {
        selector: 'node[type = "distributor"]',
        style: { 'background-color': '#d97706' }
      },
      {
        selector: 'node[type = "vendor"]',
        style: { 'background-color': '#1a56db' }
      },
      {
        selector: 'node:selected',
        style: {
          'border-color': '#1a1a2e',
          'border-width': '3px',
          'width': '36px',
          'height': '36px'
        }
      },
      {
        selector: 'edge',
        style: {
          'width': 1.5,
          'line-color': '#ccc',
          'target-arrow-color': '#aaa',
          'target-arrow-shape': 'triangle',
          'curve-style': 'bezier',
          'opacity': 0.7
        }
      },
      {
        selector: 'edge:selected',
        style: { 'line-color': '#1a56db', 'target-arrow-color': '#1a56db', 'opacity': 1, 'width': 2.5 }
      },
      {
        selector: '.faded',
        style: { 'opacity': 0.15 }
      }
    ],
    layout: {
      name: 'cose',
      animate: false,
      nodeRepulsion: 8000,
      idealEdgeLength: 120,
      gravity: 0.4,
      numIter: 1000,
      padding: 40
    }
  })

  // Click node → show sidebar
  cy.on('tap', 'node', e => showNodeDetail(e.target))
  cy.on('tap', 'edge', e => showEdgeDetail(e.target))
  cy.on('tap', evt => { if (evt.target === cy) clearSidebar() })

  statusEl.textContent = `${nodeCount} companies · ${edgeCount} supply chain links`
}

// ── Sidebar: node detail ───────────────────────────────────────
function showNodeDetail(node) {
  const { label, type, slug, website } = node.data()
  const neighbors = node.neighborhood('node').map(n => n.data('label'))
  const pageUrl = type === 'vendor'
    ? `brand.html?slug=${slug}`
    : `distributor.html?slug=${slug}`

  sidebarContent.innerHTML = `
    <span class="badge">${type}</span>
    <h2>${label}</h2>
    ${website ? `<p><a href="${website}" target="_blank" rel="noopener">${website}</a></p>` : ''}
    <p class="muted" style="margin-top:0.75rem">Connected to:</p>
    <ul>${neighbors.map(n => `<li>${n}</li>`).join('') || '<li><em>None</em></li>'}</ul>
    <a href="${pageUrl}" class="sidebar-link btn-primary" style="margin-top:1rem">View Profile →</a>
  `

  // Highlight connected subgraph
  cy.elements().addClass('faded')
  node.neighborhood().union(node).removeClass('faded')
}

// ── Sidebar: edge detail ───────────────────────────────────────
function showEdgeDetail(edge) {
  const { shared_brands, shared_categories, link_type } = edge.data()
  const src = edge.source().data('label')
  const tgt = edge.target().data('label')

  sidebarContent.innerHTML = `
    <span class="badge">${link_type || 'supply'}</span>
    <h2>${src} → ${tgt}</h2>
    ${shared_categories?.length ? `<p class="muted">Categories: ${shared_categories.join(', ')}</p>` : ''}
    ${shared_brands?.length ? `<p class="muted" style="margin-top:0.5rem">Shared brands: ${shared_brands.join(', ')}</p>` : ''}
  `

  cy.elements().addClass('faded')
  edge.union(edge.source()).union(edge.target()).removeClass('faded')
}

function clearSidebar() {
  sidebarContent.innerHTML = '<p class="muted">Click a node to see details.</p>'
  cy.elements().removeClass('faded')
}

// ── Category filters ───────────────────────────────────────────
function buildCategoryFilters(edges) {
  const cats = [...new Set(edges.flatMap(e => e.shared_categories || []))].sort()

  categoryFilters.innerHTML = cats.map(cat =>
    `<button class="filter-btn" data-cat="${cat}">${cat}</button>`
  ).join('')

  categoryFilters.querySelectorAll('.filter-btn').forEach(btn =>
    btn.addEventListener('click', () => {
      const cat = btn.dataset.cat
      const filtered = allEdges.filter(e => e.shared_categories?.includes(cat))
      renderGraph(filtered)
      clearSidebar()
      // Highlight active filter
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
