# indB2B Schema Reference

All tables reside in the PostgreSQL schema `indB2B`.

## Design Principles

- UUID primary keys throughout
- `created_at` / `updated_at` on every table
- Soft deletes via `is_active` boolean where appropriate
- Normalized to 3NF; denormalized views for app consumption
- RLS-ready for Supabase deployment

## Entity Relationship Summary

```
brand_categories
    └── brands (many per category)
            └── brand_aliases (alternate names)
            └── brand_industry_links (many-to-many with industries)

industries
    └── brand_industry_links

equipment_types
    └── brand_equipment_links (brands that make this equipment type)
```

## Tables

### `indB2B.brand_categories`
Top-level groupings (e.g., PLCs, Robotics, Motors, Heavy Equipment).

| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| name | text UNIQUE NOT NULL | e.g., 'PLCs & Control Systems' |
| slug | text UNIQUE NOT NULL | e.g., 'plcs-control-systems' |
| description | text | |
| is_active | boolean | default true |
| created_at | timestamptz | |
| updated_at | timestamptz | |

### `indB2B.industries`
Target industries for brand/equipment associations.

| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| name | text UNIQUE NOT NULL | e.g., 'Automotive' |
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
| name | text UNIQUE NOT NULL | Canonical brand name |
| slug | text UNIQUE NOT NULL | URL-safe identifier |
| category_id | uuid FK → brand_categories | Primary category |
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
| brand_id | uuid FK → brands | |
| alias | text NOT NULL | |
| notes | text | |
| created_at | timestamptz | |

### `indB2B.equipment_types`
Types of equipment (e.g., VFD, Conveyor, Robot Arm).

| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| name | text UNIQUE NOT NULL | |
| slug | text UNIQUE NOT NULL | |
| category_id | uuid FK → brand_categories | |
| description | text | |
| is_active | boolean | default true |
| created_at | timestamptz | |
| updated_at | timestamptz | |

### `indB2B.brand_industry_links`
Many-to-many: brands ↔ industries.

| Column | Type | Notes |
|--------|------|-------|
| brand_id | uuid FK → brands | |
| industry_id | uuid FK → industries | |
| PRIMARY KEY | (brand_id, industry_id) | |

### `indB2B.brand_equipment_links`
Many-to-many: brands ↔ equipment types.

| Column | Type | Notes |
|--------|------|-------|
| brand_id | uuid FK → brands | |
| equipment_type_id | uuid FK → equipment_types | |
| PRIMARY KEY | (brand_id, equipment_type_id) | |

## Views (Planned)

- `indB2B.v_brands_full` — brands joined with category, industries, aliases
- `indB2B.v_equipment_brands` — equipment types with all associated brands
