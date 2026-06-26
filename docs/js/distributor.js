import { supabase } from './supabase.js'

const main = document.getElementById('distributor-detail')
const slug = new URLSearchParams(location.search).get('slug')

if (!slug) {
  main.innerHTML = '<p>No distributor specified.</p>'
} else {
  loadDistributor(slug)
}

async function loadDistributor(slug) {
  const { data: dist, error } = await supabase
    .from('users')
    .select('id, name, slug, actor_type, website')
    .eq('slug', slug)
    .eq('actor_type', 'distributor')
    .single()

  if (error || !dist) { main.innerHTML = '<p>Distributor not found.</p>'; return }

  const [{ data: brands }, { data: industries }, { data: equipment }, { data: nodes }] = await Promise.all([
    supabase.from('user_brand_links').select('brands!inner(name, slug, website)').eq('user_id', dist.id),
    supabase.from('user_industry_links').select('industries!inner(name, slug)').eq('user_id', dist.id),
    supabase.from('user_equipment_links').select('equipment_types!inner(name, slug)').eq('user_id', dist.id),
    supabase.from('shipping_nodes').select('name, zip_code, city, state_code, is_primary').eq('user_id', dist.id)
  ])

  const brandLinks = (brands || []).map(b =>
    `<a href="brand.html?slug=${b.brands.slug}" class="tag">${b.brands.name}</a>`
  ).join(' ')

  const locationList = (nodes || []).map(n =>
    `<li>${n.city}, ${n.state_code} ${n.zip_code}${n.is_primary ? ' <span class="badge">Primary</span>' : ''}</li>`
  ).join('')

  main.innerHTML = `
    <a href="javascript:history.back()" class="back-link">← Back</a>
    <h1>${dist.name}</h1>
    ${dist.website ? `<p><a href="${dist.website}" target="_blank">${dist.website}</a></p>` : ''}
    <h2>Brands Carried</h2>
    <div class="tag-group">${brandLinks || '<em>None listed</em>'}</div>
    <h2>Industries Served</h2>
    <p>${(industries || []).map(i => i.industries.name).join(', ') || '<em>None listed</em>'}</p>
    <h2>Equipment Covered</h2>
    <p>${(equipment || []).map(e => e.equipment_types.name).join(', ') || '<em>None listed</em>'}</p>
    <h2>Locations</h2>
    <ul>${locationList || '<li><em>No locations listed</em></li>'}</ul>
  `
}
