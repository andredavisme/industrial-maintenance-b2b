# indB2B Schema Reference

> Last updated: 2026-06-26 (sessions 1–26)

## Tables (19)

### brand_categories
| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | gen_random_uuid() |
| name | text UNIQUE NOT NULL | |
| slug | text UNIQUE NOT NULL | |
| description | text | |
| is_active | boolean NOT NULL | Default true |
| created_at | timestamptz | |
| updated_at | timestamptz | auto-trigger |

### industries
| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| name | text UNIQUE NOT NULL | |
| slug | text UNIQUE NOT NULL | |
| description | text | |
| is_active | boolean NOT NULL | Default true |
| created_at | timestamptz | |
| updated_at | timestamptz | auto-trigger |

### brands
| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| name | text UNIQUE NOT NULL | |
| slug | text UNIQUE NOT NULL | |
| category_id | uuid FK → brand_categories | ON DELETE SET NULL |
| parent_brand_id | uuid FK → brands | Self-ref, ON DELETE SET NULL |
| website | text | |
| notes | text | |
| is_active | boolean NOT NULL | Default true |
| created_at | timestamptz | |
| updated_at | timestamptz | auto-trigger |

### brand_aliases
| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| brand_id | uuid FK → brands | ON DELETE CASCADE |
| alias | text NOT NULL | |
| notes | text | |
| created_at | timestamptz | |

### equipment_types
| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| name | text UNIQUE NOT NULL | |
| slug | text UNIQUE NOT NULL | |
| category_id | uuid FK → brand_categories | ON DELETE SET NULL |
| description | text | |
| is_active | boolean NOT NULL | Default true |
| created_at | timestamptz | |
| updated_at | timestamptz | auto-trigger |

### brand_industry_links (M:M)
| Column | Type | Notes |
|--------|------|-------|
| brand_id | uuid FK → brands | ON DELETE CASCADE |
| industry_id | uuid FK → industries | ON DELETE CASCADE |

### brand_equipment_links (M:M)
| Column | Type | Notes |
|--------|------|-------|
| brand_id | uuid FK → brands | ON DELETE CASCADE |
| equipment_type_id | uuid FK → equipment_types | ON DELETE CASCADE |

### sessions
| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| started_at | timestamptz | Default now() |
| closed_at | timestamptz | |
| agent | text | |
| summary | text | |
| status | text | completed / attempted / abandoned |
| created_at | timestamptz | |
| updated_at | timestamptz | auto-trigger |

### shipping_nodes
Generalized location node. `supplier_zip_codes` is a compatibility view. `user_id` added session 26.

| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| node_type | text NOT NULL | supplier / warehouse / distributor / customer |
| brand_id | uuid FK → brands | ON DELETE SET NULL |
| user_id | uuid FK → users | ON DELETE SET NULL; nullable; added session 26 |
| name | text NOT NULL | |
| zip_code | varchar(10) NOT NULL | |
| city | varchar(100) | |
| state_code | char(2) | |
| is_primary | boolean NOT NULL | Default false |
| notes | text | |
| created_at | timestamptz | |
| updated_at | timestamptz | auto-trigger |

### carriers
| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| name | text NOT NULL | |
| scac_code | varchar(4) | UNIQUE where not null |
| website | text | |
| is_active | boolean NOT NULL | Default true |
| notes | text | |
| created_at | timestamptz | auto-trigger |

### shipments
| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| reference_number | text UNIQUE NOT NULL | |
| origin_node_id | uuid FK → shipping_nodes | ON DELETE RESTRICT |
| destination_node_id | uuid FK → shipping_nodes | ON DELETE RESTRICT |
| status | text NOT NULL | draft / active / completed / cancelled |
| notes | text | |
| created_at | timestamptz | |
| updated_at | timestamptz | auto-trigger |

### shipment_legs
| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| shipment_id | uuid FK → shipments | ON DELETE CASCADE |
| sequence | integer NOT NULL | UNIQUE per shipment |
| from_node_id | uuid FK → shipping_nodes | ON DELETE RESTRICT |
| to_node_id | uuid FK → shipping_nodes | ON DELETE RESTRICT |
| status | text NOT NULL | pending / in_transit / delivered / cancelled |
| carrier_id | uuid FK → carriers | ON DELETE RESTRICT, nullable |
| tracking_number | text | |
| shipped_at | timestamptz | |
| received_at | timestamptz | |
| weight_lbs | numeric(10,5) | Weight for this leg |
| est_miles | numeric(10,5) | Manual distance override |
| est_cost_per_mile | numeric(10,5) | Carrier/route rate estimate |
| est_freight_cost | numeric(10,5) GENERATED STORED | weight_lbs × est_miles × est_cost_per_mile |
| est_freight_cost_override | numeric(10,5) | Manual cost override |
| created_at | timestamptz | |
| updated_at | timestamptz | auto-trigger |

### zip_distances
Lazy-load cache of zip pair distances. Populated on-demand by `get-distance` Edge Function.

| Column | Type | Notes |
|--------|------|-------|
| zip_from | varchar(5) NOT NULL | |
| zip_to | varchar(5) NOT NULL | |
| miles | numeric(10,5) NOT NULL | Must be > 0 |
| source | text NOT NULL | manual / api / estimate / nominatim |
| notes | text | |
| created_at | timestamptz | |
| updated_at | timestamptz | auto-trigger |
| PK | (zip_from, zip_to) | |

### zip_distance_queue
Backlog for zip pairs that could not be auto-resolved by the Edge Function.

| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| zip_from | varchar(10) NOT NULL | |
| zip_to | varchar(10) NOT NULL | |
| status | text NOT NULL | pending / resolved / failed |
| notes | text | Failure reason |
| created_at | timestamptz | |
| updated_at | timestamptz | auto-trigger |
| UNIQUE | (zip_from, zip_to) | |

### users _(added session 22)_
Public company directory. `auth_user_id` nullable for Phase 2 Supabase Auth wiring.

| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| name | text NOT NULL | |
| slug | text UNIQUE NOT NULL | |
| actor_type | text NOT NULL | end_user / distributor / vendor |
| website | text | |
| email | text | |
| auth_user_id | uuid UNIQUE | NULL until Phase 2 auth; FK to auth.users added then |
| is_public | boolean | Default true |
| is_active | boolean | Default true |
| created_at | timestamptz | |
| updated_at | timestamptz | auto-trigger |

### user_brand_links (M:M) _(added session 22)_
| Column | Type | Notes |
|--------|------|-------|
| user_id | uuid FK → users | ON DELETE CASCADE |
| brand_id | uuid FK → brands | ON DELETE CASCADE |
| role | text | authorized_dealer / distributor / manufacturer_rep |

### user_industry_links (M:M) _(added session 22)_
| Column | Type | Notes |
|--------|------|-------|
| user_id | uuid FK → users | ON DELETE CASCADE |
| industry_id | uuid FK → industries | ON DELETE CASCADE |

### user_equipment_links (M:M) _(added session 22)_
| Column | Type | Notes |
|--------|------|-------|
| user_id | uuid FK → users | ON DELETE CASCADE |
| equipment_type_id | uuid FK → equipment_types | ON DELETE CASCADE |

### supply_chain_links _(added session 22)_
Graph edge table representing who supplies whom.

| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| supplier_id | uuid FK → users | ON DELETE CASCADE |
| buyer_id | uuid FK → users | ON DELETE CASCADE |
| link_type | text NOT NULL | vendor_to_distributor / vendor_to_end_user / distributor_to_end_user / distributor_to_distributor / vendor_to_vendor / distributor_to_vendor |
| is_active | boolean | Default true |
| notes | text | |
| created_at | timestamptz | |
| updated_at | timestamptz | auto-trigger |
| CHECK | supplier_id <> buyer_id | No self-loops |

## Edge Functions (1)

### get-distance
**Request:** `POST /functions/v1/get-distance`
```json
{ "zip_from": "04090", "zip_to": "03909" }
```
**Logic:** Check cache → Nominatim geocode → haversine × 1.3 → insert; on failure → queue.
- `200 { miles, source, cached }` — success
- `202 { error, queued: true }` — geocode failed

## Views (6)

### supplier_zip_codes
Compat view over `shipping_nodes WHERE node_type = 'supplier'`. Now exposes `user_id` (session 26).

### v_brands_full
One row per brand with aggregated aliases, industries, and equipment types.

### v_equipment_brands
One row per equipment type with aggregated brand list and count.

### v_shipment_cost_summary
Estimated freight cost rollup per shipment.

### v_shipment_legs_costed
Per-leg costed view with auto distance lookup and effective cost chain.

### v_supply_chain_graph _(added session 24)_
One row per directed supply chain edge with enriched supplier/buyer node details and aggregated shared_brands, shared_categories, shared_industries, shared_equipment_types arrays.

## RLS Summary
| Table | Policy |
|-------|--------|
| brand_categories, brands, industries, equipment_types, carriers | Public SELECT where is_active = true |
| brand_aliases, brand_equipment_links, brand_industry_links, shipping_nodes, shipments, shipment_legs, zip_distances, zip_distance_queue | Public SELECT (all rows) |
| users | Public SELECT where is_public = true |
| supply_chain_links | Public SELECT where is_active = true |
| user_brand_links, user_industry_links, user_equipment_links | Public SELECT (all rows) |
| sessions | No public policy — service_role only |

## Phase 2 Auth Wiring (non-breaking)
```sql
ALTER TABLE "indB2B".users
  ADD CONSTRAINT users_auth_user_id_fkey
  FOREIGN KEY (auth_user_id) REFERENCES auth.users(id) ON DELETE SET NULL;
```
