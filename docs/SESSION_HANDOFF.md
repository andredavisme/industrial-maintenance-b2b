# Session Handoff

> **Always update this file at the end of every work session.**
> The `indB2B`.sessions table is the DB-side audit log — insert a row there too.

## Last Updated
2026-06-25

## Current State
🟡 **Phase 1 — Data Foundation** in progress.
DB: **49 brands / 13 categories / 5 industries / 5 aliases**

## Completed — 2026-06-25 (Session 5)
- [x] Created `supplier_zip_codes` table via migration (`create_supplier_zip_codes`)
  - Columns: `id`, `brand_id` (FK→brands, NOT NULL), `zip_code`, `city`, `state_code`, `notes`, `is_primary`, `created_at`, `updated_at`
  - Unique index: one primary zip per brand (`WHERE is_primary = true`)
  - Indexes on `brand_id` and `zip_code`
  - `updated_at` trigger applied
- [ ] **Seeding blocked** — `data/Package-Shipping-Reference-Supplier-Zip-Codes.csv` not found in repo; must be uploaded before seeding

## Completed — 2026-06-25 (Session 4)
- [x] Added `Lubricants & MRO` to `brand_categories` (`c2e15a09`)
- [x] Seeded 6 Lubricants & MRO brands: Mobil, Shell Lubricants, WD-40, Zerk (Generic), Permatex, CRC Industries
- [x] `brands` now at **49 total**, `brand_categories` at **13 total**

## Completed — 2026-06-25 (Session 3)
- [x] Added 2 missing `brand_categories`: **Bearings** (`aff4f4c2`) and **Belts & Drives** (`d1edbdd1`)
- [x] Seeded 6 Bearings brands: SKF, NSK, Timken, FAG, NTN, INA
- [x] Seeded 6 Belts & Drives brands: Gates, Dayco, Browning, Dodge, Fenner, ContiTech

## Completed — 2026-06-25 (Session 2)
- [x] Reviewed live DB state: 10 categories, 31 brands, 5 industries, 5 aliases confirmed
- [x] Received and analyzed `data/branch-shelf.csv` — physical warehouse inventory catalog
  - 72 unique shelves, 77 distinct product types, 125 total entries
  - Top categories by shelf count: Bearings (27), Fasteners & Hardware (13), Belts & Drives (11)
- [x] Identified **Lubricants & MRO** as a new category needed

## Completed — 2026-06-25 (Session 1)
- [x] Created repo, defined project structure, applied `indB2B` schema to Supabase
- [x] Seeded brand categories (10), industries (5), brands (27→31), aliases (5)
- [x] Added `indB2B`.sessions table for agent audit logging

## Next Steps

| Priority | Task |
|----------|------|
| 🔴 High | **Upload `Package-Shipping-Reference-Supplier-Zip-Codes.csv`** to `data/` in repo, then seed `supplier_zip_codes` table (60 rows). Add missing brands first if not in `brands`. |
| 🔴 High | Add RLS policies for public read on `brands`, `brand_categories`, `industries`, `supplier_zip_codes` |
| 🟡 Med  | Seed `equipment_types` using `branch-shelf.csv` product types as source data |
| 🟡 Med  | Seed brands for remaining empty categories: HVAC, Conveyors, Pneumatics, Safety, Fasteners |
| 🟡 Med  | Seed `brand_industry_links` and `brand_equipment_links` (M:M — currently empty) |
| 🟡 Med  | Update `schema/indB2B_schema.sql` to include `supplier_zip_codes` DDL |
| 🟡 Med  | Create views: v_brands_full, v_equipment_brands |
| ⬜ Low  | Scaffold web app consuming indB2B schema |

## Shipping Feature Context
A new AppSheet app ([link](https://www.appsheet.com/start/226daf34-cd2d-4d03-b9cd-9b0dd7ea3fe8)) records supplier origin zip codes to calculate estimated shipping costs. The CSV source (`Package-Shipping-Reference-Supplier-Zip-Codes.csv`) has 60 supplier → zip code pairs. These suppliers map to brands in the schema.

### supplier_zip_codes Schema
```sql
CREATE TABLE "indB2B".supplier_zip_codes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  brand_id uuid NOT NULL REFERENCES "indB2B".brands(id) ON DELETE RESTRICT,
  zip_code varchar(10) NOT NULL,
  city varchar(100),
  state_code char(2),
  notes text,
  is_primary boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
```

## Open Questions
- Will the web app be Cloudflare Pages or GitHub Pages?
- Is RFQ functionality in scope for Phase 1 or Phase 2?
- Should shipping rate/zone calculation logic live in Supabase (Edge Functions or tables) or remain in AppSheet?

## Key File Locations

| File | Purpose |
|------|---------|
| `schema/indB2B_schema.sql` | Full DDL — run to init DB |
| `data/brands_seed.sql` | Cumulative seed data |
| `data/branch-shelf.csv` | Physical warehouse shelf catalog |
| `data/Package-Shipping-Reference-Supplier-Zip-Codes.csv` | Supplier origin zip codes (**needs upload**) |
| `docs/SCHEMA.md` | Human-readable schema reference |
| `docs/DATA_CATALOG.md` | Brand/category index with status |
| `docs/DEV_GUIDE.md` | Setup instructions |
