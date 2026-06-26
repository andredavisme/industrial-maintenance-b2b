import { supabase } from './supabase.js'

const input = document.getElementById('zip-input')
const btn = document.getElementById('zip-search')
const results = document.getElementById('find-results')

btn.addEventListener('click', () => {
  const zip = input.value.trim()
  if (zip.length < 5) { results.innerHTML = '<p>Please enter a valid ZIP code.</p>'; return }
  findNearMe(zip)
})

input.addEventListener('keydown', e => { if (e.key === 'Enter') btn.click() })

async function findNearMe(userZip) {
  results.innerHTML = 'Searching...'

  const { data: nodes, error } = await supabase
    .from('shipping_nodes')
    .select('id, name, zip_code, city, state_code, user_id, users!inner(name, slug)')
    .eq('node_type', 'distributor')

  if (error || !nodes?.length) { results.innerHTML = '<p>No distributor locations found.</p>'; return }

  // Fetch distances in parallel (batched to avoid overload)
  const withDistance = await Promise.all(
    nodes.map(async node => {
      try {
        const { data } = await supabase.functions.invoke('get-distance', {
          body: { zip_from: userZip, zip_to: node.zip_code }
        })
        return { ...node, miles: data?.miles ?? Infinity }
      } catch {
        return { ...node, miles: Infinity }
      }
    })
  )

  const sorted = withDistance.sort((a, b) => a.miles - b.miles).slice(0, 20)

  results.innerHTML = `
    <h2>Nearest Distributors to ${userZip}</h2>
    <ul class="result-list">${sorted.map(n => `
      <li>
        <a href="distributor.html?slug=${n.users.slug}">${n.users.name}</a>
        — ${n.city}, ${n.state_code} ${n.zip_code}
        ${n.miles !== Infinity ? `<span class="muted">(${Math.round(n.miles)} mi)</span>` : ''}
      </li>`
    ).join('')}</ul>
  `
}
