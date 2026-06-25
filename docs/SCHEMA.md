# indB2B Schema Reference

> Last updated: 2026-06-25 (sessions 1–19)

## Tables (13)

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
Generalized location node. `supplier_zip_codes` is a compatibility view.

| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| node_type | text NOT NULL | supplier / warehouse / distributor / customer |
| brand_id | uuid FK → brands | ON DELETE SET NULL |
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
| created_at | timestamptz | |
| updated_at | timestamptz | auto-trigger |

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
| est_freight_cost | numeric(10,5) GENERATED STORED | weight_lbs × est_miles × est_cost_per_mile; NULL if any input is NULL |
| est_freight_cost_override | numeric(10,5) | Manual cost override; takes precedence in all rollups |
| created_at | timestamptz | |
| updated_at | timestamptz | auto-trigger |

### zip_distances
Pre-populated zip code pair distance lookup. Bidirectional: store one direction, view queries both.

| Column | Type | Notes |
|--------|------|-------|
| zip_from | varchar(5) NOT NULL | 5-digit zip |
| zip_to | varchar(5) NOT NULL | 5-digit zip |
| miles | numeric(10,5) NOT NULL | Must be > 0 |
| source | text NOT NULL | manual / api / estimate |
| notes | text | |
| created_at | timestamptz | |
| updated_at | timestamptz | auto-trigger |
| PK | (zip_from, zip_to) | |

## Views (5)

### supplier_zip_codes
Compatibility view over `shipping_nodes WHERE node_type = 'supplier'`.

### v_brands_full
One row per brand with category, parent brand, and aggregated aliases, industries, and equipment types.

### v_equipment_brands
One row per equipment type with aggregated brand list and count.

### v_shipment_cost_summary
Estimated freight cost rollup per shipment. Uses `est_freight_cost_override` when populated, otherwise `est_freight_cost`.

| Column | Notes |
|--------|-------|
| shipment_id | |
| reference_number | |
| status | |
| leg_count | |
| total_est_freight_cost | SUM of COALESCE(override, generated) per leg |
| total_weight_lbs | |
| total_est_miles | |

### v_shipment_legs_costed
Per-leg costed view with automatic zip-to-zip distance lookup.

**Priority chains:**
- `effective_miles`: `est_miles` (manual) → `zip_distances` lookup (bidirectional)
- `effective_freight_cost`: `est_freight_cost_override` → `est_freight_cost` (generated) → on-the-fly using `looked_up_miles`

| Column | Notes |
|--------|-------|
| id, shipment_id, sequence, status | |
| carrier_id, tracking_number, shipped_at, received_at | |
| from_zip, to_zip | From shipping_nodes |
| weight_lbs, est_cost_per_mile | |
| est_miles | Manual entry on leg |
| est_freight_cost | Generated column value |
| est_freight_cost_override | Manual override |
| looked_up_miles | From zip_distances (bidirectional) |
| effective_miles | COALESCE(est_miles, looked_up_miles) |
| effective_freight_cost | Override → generated → on-the-fly with lookup |
| created_at, updated_at | |

## Shipping Journey Model
- **Point A** — supplier origin (`node_type = 'supplier'`)
- **Point B** — first receiver (warehouse, distributor, etc.)
- **Point C+** — any subsequent nodes
- Each hop is one row in `shipment_legs` with a `sequence` number
- Cost fields: inputs → `est_freight_cost` (generated) → optional override
- Distance lookup via `zip_distances`; auto-applied in `v_shipment_legs_costed`
- Actual/invoiced costs live in financial tables (separate schema, Phase 2+)

## RLS Summary
| Table | Policy |
|-------|--------|
| brand_categories, brands, industries, equipment_types, carriers | Public SELECT where is_active = true |
| brand_aliases, brand_equipment_links, brand_industry_links, shipping_nodes, shipments, shipment_legs, zip_distances | Public SELECT (all rows) |
| sessions | No public policy — service_role only |
