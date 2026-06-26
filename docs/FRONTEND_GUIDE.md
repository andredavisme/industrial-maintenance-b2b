# Frontend Development Guide

> **Scope:** Read-only public interface. No authentication required.
> All data is accessible via the Supabase anon/publishable key.
> Last updated: 2026-06-26

## Connection

```js
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(
  'https://<project-ref>.supabase.co',
  '<anon-or-publishable-key>'
)
// Schema is 'indB2B' — all table/view names must be qualified or
// search_path set. Via JS client, use the table name directly;
// Supabase PostgREST reads the search_path set on the schema.
```

> Get your project URL and anon key from the Supabase dashboard → Project Settings → API.

---

## User Journey

> *"I need a part — who in this network can get it to me?"*

A visitor arrives with a **part category or equipment type** and traces:
1. Which **brands** make it
2. Which **distributors** carry those brands
3. Where those distributors are located
4. The **supply chain path** from vendor → distributor

---

## Screens & Query Patterns

### Screen 1 — Equipment / Part Search
> Entry point: pick a category → equipment type → see matching brands.

```js
// Load all brand categories
const { data: categories } = await supabase
  .from('brand_categories')
  .select('id, name, slug')
  .eq('is_active', true)
  .order('name')

// Load equipment types for a category
const { data: equipment } = await supabase
  .from('equipment_types')
  .select('id, name, slug, description')
  .eq('category_id', categoryId)
  .eq('is_active', true)
  .order('name')

// Load brands for an equipment type (via v_equipment_brands)
const { data: brands } = await supabase
  .from('v_equipment_brands')
  .select('equipment_type, category, brands, brand_count')
  .eq('slug', equipmentSlug)
  .single()
```

---

### Screen 2 — Brand Profile
> Brand detail page: aliases, industries served, equipment types, distributors that carry it.

```js
// Full brand detail
const { data: brand } = await supabase
  .from('v_brands_full')
  .select('*')
  .eq('slug', brandSlug)
  .single()

// Distributors that carry this brand
const { data: distributors } = await supabase
  .from('user_brand_links')
  .select(`
    role,
    users!inner(id, name, slug, actor_type, website)
  `)
  .eq('brand_id', brandId)
  .eq('users.actor_type', 'distributor')
```

---

### Screen 3 — Distributor Profile
> Company card: brands carried, industries served, equipment covered, location.

```js
// Distributor detail
const { data: distributor } = await supabase
  .from('users')
  .select('id, name, slug, actor_type, website')
  .eq('slug', distributorSlug)
  .eq('actor_type', 'distributor')
  .single()

// Brands this distributor carries
const { data: brands } = await supabase
  .from('user_brand_links')
  .select('role, brands!inner(name, slug, website)')
  .eq('user_id', distributorId)

// Industries served
const { data: industries } = await supabase
  .from('user_industry_links')
  .select('industries!inner(name, slug)')
  .eq('user_id', distributorId)

// Equipment types covered
const { data: equipment } = await supabase
  .from('user_equipment_links')
  .select('equipment_types!inner(name, slug)')
  .eq('user_id', distributorId)

// Location nodes
const { data: nodes } = await supabase
  .from('shipping_nodes')
  .select('name, zip_code, city, state_code, is_primary')
  .eq('user_id', distributorId)
```

---

### Screen 4 — Supply Chain Explorer
> Visual graph of vendor → distributor relationships. Filterable by brand, category, industry.

```js
// All active edges with full context
const { data: edges } = await supabase
  .from('v_supply_chain_graph')
  .select('*')
  .eq('link_active', true)

// Filter by shared brand category
const { data: edges } = await supabase
  .from('v_supply_chain_graph')
  .select('*')
  .eq('link_active', true)
  .contains('shared_categories', ['Bearings'])

// Filter by specific vendor
const { data: edges } = await supabase
  .from('v_supply_chain_graph')
  .select('*')
  .eq('supplier_slug', 'skf')
  .eq('link_active', true)
```

**Graph shape for viz libraries (e.g. D3, Cytoscape, React Flow):**
```js
const nodes = [
  // deduplicate suppliers + buyers into node list
  ...new Map([
    ...edges.map(e => [e.supplier_id, { id: e.supplier_id, label: e.supplier_name, type: e.supplier_type }]),
    ...edges.map(e => [e.buyer_id,    { id: e.buyer_id,    label: e.buyer_name,    type: e.buyer_type    }])
  ]).values()
]
const links = edges.map(e => ({
  source: e.supplier_id,
  target: e.buyer_id,
  label: e.link_type,
  shared_brands: e.shared_brands
}))
```

---

### Screen 5 — Find Near Me
> Zip input → ranked distributors by distance.

```js
// 1. Get all distributor shipping nodes
const { data: nodes } = await supabase
  .from('shipping_nodes')
  .select('id, name, zip_code, city, state_code, user_id, users!inner(name, slug)')
  .eq('node_type', 'distributor')

// 2. For each node, call get-distance Edge Function
const { data } = await supabase.functions.invoke('get-distance', {
  body: { zip_from: userZip, zip_to: node.zip_code }
})
// Returns: { miles, source, cached }

// 3. Sort nodes by miles, render ranked list
```

---

## Public API Surface Summary

| Table / View | Accessible | Filter Tip |
|---|---|---|
| `brand_categories` | ✅ | `is_active = true` |
| `brands` | ✅ | `is_active = true` |
| `brand_aliases` | ✅ | join via `brand_id` |
| `equipment_types` | ✅ | `is_active = true`, filter by `category_id` |
| `industries` | ✅ | `is_active = true` |
| `brand_equipment_links` | ✅ | join bridge |
| `brand_industry_links` | ✅ | join bridge |
| `users` | ✅ | `is_public = true`; filter by `actor_type` |
| `user_brand_links` | ✅ | filter by `user_id` or `brand_id` |
| `user_industry_links` | ✅ | filter by `user_id` |
| `user_equipment_links` | ✅ | filter by `user_id` |
| `supply_chain_links` | ✅ | `is_active = true` |
| `shipping_nodes` | ✅ | filter by `node_type`, `user_id` |
| `carriers` | ✅ | `is_active = true` |
| `zip_distances` | ✅ | cache — prefer Edge Function |
| `v_brands_full` | ✅ | best for brand detail pages |
| `v_equipment_brands` | ✅ | best for equipment → brand lookup |
| `v_supply_chain_graph` | ✅ | best for graph viz |
| `v_shipment_legs_costed` | ✅ | shipping cost detail |
| `v_shipment_cost_summary` | ✅ | shipping cost rollup |
| `get-distance` (Edge Fn) | ✅ | POST `{ zip_from, zip_to }` → miles |
| `sessions` | ❌ | service_role only |

---

## Suggested Route Structure

```
/                        → Home / search entry
/equipment/:slug         → Screen 1 — Equipment type + brands
/brands/:slug            → Screen 2 — Brand profile
/distributors/:slug      → Screen 3 — Distributor profile
/network                 → Screen 4 — Supply chain graph explorer
/find                    → Screen 5 — Find near me (zip input)
```

---

## Notes
- `indB2B` schema is accessed automatically via Supabase PostgREST with `search_path`
- All arrays in views (`shared_brands`, `aliases`, etc.) are native Postgres arrays — use `.contains()` for filtering
- `zip_distance_queue` is currently empty; monitor if `get-distance` calls begin failing
- Phase 2 auth wiring (`auth_user_id FK`) is non-breaking and can be added at any time without frontend changes
