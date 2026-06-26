import { supabase } from './supabase.js'

const categoryList = document.getElementById('category-list')
const equipmentList = document.getElementById('equipment-list')
const brandResults = document.getElementById('brand-results')

// Load categories on page load
async function loadCategories() {
  const { data, error } = await supabase
    .from('brand_categories')
    .select('id, name, slug')
    .eq('is_active', true)
    .order('name')

  if (error) { categoryList.textContent = 'Error loading categories.'; return }

  categoryList.innerHTML = data.map(c =>
    `<button class="filter-btn" data-id="${c.id}" data-slug="${c.slug}">${c.name}</button>`
  ).join('')

  categoryList.querySelectorAll('.filter-btn').forEach(btn =>
    btn.addEventListener('click', () => loadEquipment(btn.dataset.id))
  )
}

async function loadEquipment(categoryId) {
  equipmentList.innerHTML = 'Loading...'
  brandResults.innerHTML = ''

  const { data, error } = await supabase
    .from('equipment_types')
    .select('id, name, slug, description')
    .eq('category_id', categoryId)
    .eq('is_active', true)
    .order('name')

  if (error) { equipmentList.textContent = 'Error loading equipment.'; return }

  equipmentList.innerHTML = data.map(e =>
    `<div class="card" style="cursor:pointer" data-slug="${e.slug}">
      <h3>${e.name}</h3>
      <p>${e.description || ''}</p>
    </div>`
  ).join('')

  equipmentList.querySelectorAll('.card').forEach(card =>
    card.addEventListener('click', () => loadBrands(card.dataset.slug))
  )
}

async function loadBrands(equipmentSlug) {
  brandResults.innerHTML = 'Loading brands...'

  const { data, error } = await supabase
    .from('v_equipment_brands')
    .select('equipment_type, category, brands, brand_count')
    .eq('slug', equipmentSlug)
    .single()

  if (error || !data) { brandResults.textContent = 'No brands found.'; return }

  const brandLinks = data.brands.map(b =>
    `<a href="brand.html?slug=${b}" class="tag">${b}</a>`
  ).join(' ')

  brandResults.innerHTML = `
    <h2>${data.equipment_type} <span class="muted">(${data.brand_count} brands)</span></h2>
    <div class="tag-group">${brandLinks}</div>
  `
}

loadCategories()
