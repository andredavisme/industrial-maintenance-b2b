import { supabase } from './supabase.js'

// Placeholder — full D3/Cytoscape implementation in next phase
const container = document.getElementById('graph-container')
const filters = document.getElementById('graph-filters')

async function loadGraph() {
  container.innerHTML = 'Loading network...'

  const { data: edges, error } = await supabase
    .from('v_supply_chain_graph')
    .select('*')
    .eq('link_active', true)

  if (error) { container.textContent = 'Error loading graph.'; return }

  // Build unique node list
  const nodeMap = new Map([
    ...edges.map(e => [e.supplier_id, { id: e.supplier_id, label: e.supplier_name, type: 'vendor' }]),
    ...edges.map(e => [e.buyer_id,    { id: e.buyer_id,    label: e.buyer_name,    type: 'distributor' }])
  ])

  container.innerHTML = `
    <p><strong>${nodeMap.size} companies</strong>, <strong>${edges.length} supply chain links</strong> loaded.</p>
    <p class="muted">Graph visualization coming in next phase. Data is ready.</p>
    <ul>${[...nodeMap.values()].slice(0, 10).map(n =>
      `<li><span class="badge">${n.type}</span> ${n.label}</li>`
    ).join('')}${nodeMap.size > 10 ? `<li class="muted">...and ${nodeMap.size - 10} more</li>` : ''}</ul>
  `
}

loadGraph()
