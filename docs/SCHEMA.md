# indB2B Schema Reference

All tables and views reside in the PostgreSQL schema `indB2B`.
Last synced: 2026-06-25

## Design Principles

- UUID primary keys throughout
- `created_at` / `updated_at` on every table; `updated_at` auto-set via trigger
- Soft deletes via `is_active` boolean where appropriate
- Normalized to 3NF; denormalized views for app consumption
- RLS enabled on all 12 tables; `sessions` is service_role only

## Entity Relationship Summary

```
brand_categories
    └── brands (many per category)
            └── brand_aliases (alternate names)
            └── brand_industry_links  ─── industries
            └── brand_equipment_links ─── equipment_types

shipping_nodes (node_type: supplier | warehouse | distributor | customer)
    └── shipments (origin_node_id, destination_node_id)
            └── shipment_legs (sequence, from_node_id, to_node_id, carrier_id)
                    └── carriers

Views:
    supplier_zip_codes  ← shipping_nodes WHERE node_type = 'supplier'
    v_brands_full       ← brands + category + aliases + industries + equipment_types
    v_equipment_brands  ← equipment_types + category + brands[]
```

## Shipping Journey Model

A shipment is a sequence of legs:
- **Point A** — supplier origin (`node_type = 'supplier'`)
- **Point B** — first receiver (warehouse, distributor, etc.)
- **Point C+** — any subsequent nodes

Each leg is independent: `from_node × to_node → carrier + tracking + timestamps`.
Cost calculation logic is deferred to Phase 2.

---

## Tables

### `indB2B.brand_categories`
Top-level product groupings (e.g., PLCs, Robotics, Motors).

| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| name | text UNIQUE NOT NULL | |
| slug | text UNIQUE NOT NULL | |
| description | text | |
| is_active | boolean | default true |
| created_at | timestamptz | |
| updated_at | timestamptz | |

### `indB2B.industries`
Target industries for brand/equipment associations.

| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| name | text UNIQUE NOT NULL | |
| slug | text UNIQUE NOT NULL | |
| description | text | |
| is_active | boolean | default true |
| created_at | timestamptz | |
| updated_at | timestamptz | |

### `indB2B.brands`
Core brand registry.

| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| name | text UNIQUE NOT NULL | |
| slug | text UNIQUE NOT NULL | |
| category_id | uuid FK → brand_categories | ON DELETE SET NULL |
| parent_brand_id | uuid FK → brands (self) | For subsidiaries |
| website | text | |
| notes | text | |
| is_active | boolean | default true |
| created_at | timestamptz | |
| updated_at | timestamptz | |

### `indB2B.brand_aliases`
Alternate names, trade names, former names.

| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| brand_id | uuid FK → brands | ON DELETE CASCADE |
| alias | text NOT NULL | |
| notes | text | |
| created_at | timestamptz | |

### `indB2B.equipment_types`
Types of equipment (e.g., VFD, Conveyor Belt, Robot Arm).

| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| name | text UNIQUE NOT NULL | |
| slug | text UNIQUE NOT NULL | |
| category_id | uuid FK → brand_categories | ON DELETE SET NULL |
| description | text | |
| is_active | boolean | default true |
| created_at | timestamptz | |
| updated_at | timestamptz | |

### `indB2B.brand_industry_links`
Many-to-many: brands ↔ industries.

| Column | Type | Notes |
|--------|------|-------|
| brand_id | uuid FK → brands | ON DELETE CASCADE |
| industry_id | uuid FK → industries | ON DELETE CASCADE |
| PRIMARY KEY | (brand_id, industry_id) | |

### `indB2B.brand_equipment_links`
Many-to-many: brands ↔ equipment types.

| Column | Type | Notes |
|--------|------|-------|
| brand_id | uuid FK → brands | ON DELETE CASCADE |
| equipment_type_id | uuid FK → equipment_types | ON DELETE CASCADE |
| PRIMARY KEY | (brand_id, equipment_type_id) | |

### `indB2B.sessions`
Agent audit log. No public RLS policy — service_role only.

| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| started_at | timestamptz | default now() |
| closed_at | timestamptz | nullable |
| agent | text | |
| summary | text | |
| status | text | completed / attempted / abandoned |
| created_at | timestamptz | |
| updated_at | timestamptz | |

### `indB2B.shipping_nodes`
Generalized shipping location node. Covers all points in a shipment journey.
`supplier_zip_codes` is a compatibility view over this table.

| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| node_type | text NOT NULL | supplier / warehouse / distributor / customer |
| brand_id | uuid FK → brands | Nullable; ON DELETE SET NULL |
| name | text NOT NULL | Human-readable label |
| zip_code | varchar(10) NOT NULL | |
| city | varchar(100) | |
| state_code | char(2) | |
| is_primary | boolean | default false |
| notes | text | |
| created_at | timestamptz | |
| updated_at | timestamptz | |

### `indB2B.carriers`
Freight and parcel carriers. Referenced by `shipment_legs` with ON DELETE RESTRICT.

| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| name | text NOT NULL | |
| scac_code | varchar(4) | Unique where not null (Standard Carrier Alpha Code) |
| website | text | |
| is_active | boolean | default true |
| notes | text | |
| created_at | timestamptz | |
| updated_at | timestamptz | |

### `indB2B.shipments`
Parent record grouping all legs of a single shipment journey.

| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| reference_number | text UNIQUE NOT NULL | Human-readable shipment ID |
| origin_node_id | uuid FK → shipping_nodes | ON DELETE RESTRICT |
| destination_node_id | uuid FK → shipping_nodes | ON DELETE RESTRICT |
| status | text | draft / active / completed / cancelled |
| notes | text | |
| created_at | timestamptz | |
| updated_at | timestamptz | |

### `indB2B.shipment_legs`
Individual leg of a shipment (Point A→B, B→C, etc.). Sequence is unique per shipment.

| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| shipment_id | uuid FK → shipments | ON DELETE CASCADE |
| sequence | integer NOT NULL | Leg order within shipment |
| from_node_id | uuid FK → shipping_nodes | ON DELETE RESTRICT |
| to_node_id | uuid FK → shipping_nodes | ON DELETE RESTRICT |
| status | text | pending / in_transit / delivered / cancelled |
| carrier_id | uuid FK → carriers | Nullable; ON DELETE RESTRICT |
| tracking_number | text | |
| shipped_at | timestamptz | Nullable |
| received_at | timestamptz | Nullable |
| created_at | timestamptz | |
| updated_at | timestamptz | |
| UNIQUE | (shipment_id, sequence) | |

---

## Views

### `indB2B.supplier_zip_codes`
Compatibility view over `shipping_nodes WHERE node_type = 'supplier'`.
Exposes: id, brand_id, zip_code, city, state_code, is_primary, notes, created_at, updated_at.
Used by AppSheet reference app.

### `indB2B.v_brands_full`
One row per brand. Joins category, parent brand, and aggregates aliases, industries, and equipment types as arrays.

| Column | Notes |
|--------|-------|
| id, name, slug, website, notes, is_active | From brands |
| category, category_slug | From brand_categories |
| parent_brand | From brands (self-join) |
| aliases | text[] — aggregated from brand_aliases |
| industries | text[] — aggregated from brand_industry_links + industries |
| equipment_types | text[] — aggregated from brand_equipment_links + equipment_types |
| created_at, updated_at | From brands |

### `indB2B.v_equipment_brands`
One row per equipment type. Aggregates all active associated brands alphabetically.

| Column | Notes |
|--------|-------|
| id, equipment_type, equipment_slug, description, is_active | From equipment_types |
| category, category_slug | From brand_categories |
| brands | text[] — active brands sorted alphabetically |
| brand_count | integer |
