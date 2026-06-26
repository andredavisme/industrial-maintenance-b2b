import { supabase } from './supabase.js'

const main = document.getElementById('brand-detail')
const rawSlug = new URLSearchParams(location.search).get('slug')

// Normalise: if someone passed a display name instead of a slug, convert it
const slug = rawSlug
  ? rawSlug.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '')
  : null

if (!slug) {
  main.innerHTML = '<p>No brand specified.</p>'
} else {
  loadBrand(slug)
}

async function loadBrand(slug) {
  const { data: brand, error } = await supabase
    .from('v_brands_full')
    .select('*')
    .eq('slug', slug)
    .single()

  if (error || !brand) { main.innerHTML = `<p>Brand not found for slug: <code>${slug}</code></p>`; return }

  const { data: distributors } = await supabase
    .from('user_brand_links')
    .select('users!inner(id, name, slug, actor_type, website)')
    .eq('brand_id', brand.id)
    .eq('users.actor_type', 'distributor')

  const distLinks = (distributors || []).map(d =>
    `<a href="distributor.html?slug=${d.users.slug}" class="tag">${d.users.name}</a>`
  ).join(' ')

  main.innerHTML = `
    <a href="javascript:history.back()" class="back-link">&larr; Back</a>
    <h1>${brand.name}</h1>
    ${brand.website ? `<p><a href="${brand.website}" target="_blank">${brand.website}</a></p>` : ''}
    ${brand.category ? `<p class="muted">Category: ${brand.category}</p>` : ''}
    ${brand.aliases?.length ? `<p>Also known as: ${brand.aliases.join(', ')}</p>` : ''}
    ${brand.industries?.length ? `<p>Industries: ${brand.industries.join(', ')}</p>` : ''}
    ${brand.equipment_types?.length ? `<p>Equipment types: ${brand.equipment_types.join(', ')}</p>` : ''}
    <h2>Distributors</h2>
    <div class="tag-group">${distLinks || '<em>None listed</em>'}</div>
  `
}
