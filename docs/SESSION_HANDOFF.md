# Session Handoff

> **Always update this file at the end of every work session.**
> The `indB2B`.sessions table is the DB-side audit log — insert a row there too.

## Last Updated
2026-06-25

## Current State
🟡 **Phase 1 — Data Foundation** in progress.
DB: **101 brands / 13 categories / 5 industries / 5 aliases / 59 supplier zip codes**

## Completed — 2026-06-25 (Session 6)
- [x] Seeded `supplier_zip_codes` table from 60-supplier CSV
- [x] Inserted 52 new brands (matched 7 existing: Dodge, Eaton, Fenner, Keyence, SKF, Timken, Regal-Beloit)
- [x] 59 `supplier_zip_codes` rows inserted; Alpine zip fixed (was UUID, corrected to 01862)
- [x] `brands` now at **101 total**

## Completed — 2026-06-25 (Session 5)
- [x] Created `supplier_zip_codes` table via migration (`create_supplier_zip_codes`)
  - Columns: `id`, `brand_id` (FK→brands, NOT NULL), `zip_code`, `city`, `state_code`, `notes`, `is_primary`, `created_at`, `updated_at`
  - Unique index: one primary zip per brand; indexes on `brand_id` and `zip_code`

## Completed — 2026-06-25 (Session 4)
- [x] Added `Lubricants & MRO` category + 6 brands: Mobil, Shell Lubricants, WD-40, Zerk (Generic), Permatex, CRC Industries

## Completed — 2026-06-25 (Session 3)
- [x] Added Bearings + Belts & Drives categories + 12 brands (SKF, NSK, Timken, FAG, NTN, INA; Gates, Dayco, Browning, Dodge, Fenner, ContiTech)

## Completed — 2026-06-25 (Sessions 1–2)
- [x] Repo created, schema applied, 10 categories / 31 brands / 5 industries / 5 aliases seeded
- [x] sessions table added

## Next Steps

| Priority | Task |
|----------|------|
| 🔴 High | Add RLS policies for public read on `brands`, `brand_categories`, `industries`, `supplier_zip_codes` |
| 🟡 Med  | Update `schema/indB2B_schema.sql` to include `supplier_zip_codes` DDL |
| 🟡 Med  | Seed `equipment_types` using `branch-shelf.csv` product types as source data |
| 🟡 Med  | Seed brands for remaining empty categories: HVAC, Conveyors, Pneumatics, Safety, Fasteners |
| 🟡 Med  | Seed `brand_industry_links` and `brand_equipment_links` (M:M — currently empty) |
| 🟡 Med  | Create views: v_brands_full, v_equipment_brands |
| ⬜ Low  | Scaffold web app consuming indB2B schema |

## Shipping Feature Context
A new AppSheet app ([link](https://www.appsheet.com/start/226daf34-cd2d-4d03-b9cd-9b0dd7ea3fe8)) records supplier origin zip codes to calculate estimated shipping costs.

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
| `schema/indB2B_schema.sql` | Full DDL — run to init DB (**needs supplier_zip_codes update**) |
| `data/brands_seed.sql` | Cumulative seed data (**needs update for new 52 brands**) |
| `data/branch-shelf.csv` | Physical warehouse shelf catalog |
| `data/Package-Shipping-Reference-Supplier-Zip-Codes.csv` | Supplier origin zip codes (**not yet committed to repo**) |
| `docs/SCHEMA.md` | Human-readable schema reference |
| `docs/DATA_CATALOG.md` | Brand/category index with status |
| `docs/DEV_GUIDE.md` | Setup instructions |
