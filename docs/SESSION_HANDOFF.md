# Session Handoff

> **Always update this file at the end of every work session.**
> The `indB2B`.sessions table is the DB-side audit log — insert a row there too.

## Last Updated
2026-06-25

## Current State
🟡 **Phase 1 — Data Foundation** in progress.
DB: **49 brands / 13 categories / 5 industries / 5 aliases**

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
  - ~14% non-stock (Unused, Facility Storage, Discards)
  - Top categories by shelf count: Bearings (27), Fasteners & Hardware (13), Belts & Drives (11)
  - Top product types: Pillow Block Bearings (10 shelves), Roller Bearings (9 shelves)
- [x] Generated shelf-frequency analysis and category volume charts
- [x] Identified **Lubricants & MRO** as a new category needed (Grease, Lubricant, Grease Zerks)

## Completed — 2026-06-25 (Session 1)
- [x] Created repo `andredavisme/industrial-maintenance-b2b`
- [x] Defined project structure and all foundation documents
- [x] Drafted and applied `indB2B` schema to Supabase (project: nmemmfblpzrkwyljpmvp)
- [x] Seeded brand categories (10), industries (5), brands (27→31), aliases (5)
- [x] Added `indB2B`.sessions table for agent audit logging
- [x] Updated Space instructions to use live session-init/closeout pattern

## Next Steps

| Priority | Task |
|----------|------|
| 🔴 High | **Create `supplier_zip_codes` table** — FK to `brands.id` (NOT NULL). Brand inserts must be accompanied by a zip code row. |
| 🔴 High | **Seed 60 supplier zip codes** from `Package-Shipping-Reference-Supplier-Zip-Codes.csv` — insert new brands first, then zip code rows. Only Keyence and Eaton already exist in `brands`. |
| 🔴 High | Add RLS policies for public read on `brands`, `brand_categories`, `industries` |
| 🟡 Med  | Seed `equipment_types` using `branch-shelf.csv` product types as source data |
| 🟡 Med  | Seed brands for remaining empty categories: HVAC, Conveyors, Pneumatics, Safety, Fasteners |
| 🟡 Med  | Seed `brand_industry_links` and `brand_equipment_links` (M:M — currently empty) |
| 🟡 Med  | Create views: v_brands_full, v_equipment_brands |
| 🟡 Med  | Add SCHEMA.md entry for sessions table |
| ⬜ Low  | Scaffold web app consuming indB2B schema |
| ⬜ Low  | Design local-serve app architecture |

## Shipping Feature Context
A new AppSheet app ([link](https://www.appsheet.com/start/226daf34-cd2d-4d03-b9cd-9b0dd7ea3fe8)) records supplier origin zip codes to calculate estimated shipping costs. The CSV source (`Package-Shipping-Reference-Supplier-Zip-Codes.csv`) has 60 supplier → zip code pairs. These suppliers map to brands in the schema. The `supplier_zip_codes` table will enforce:
- `brand_id` is NOT NULL with a FK constraint to `brands.id`
- No zip code row can exist without a valid brand
- Brand inserts should always include a corresponding zip code row

## Open Questions
- Will the web app be Cloudflare Pages or GitHub Pages?
- Is RFQ functionality in scope for Phase 1 or Phase 2?
- Should `branch-shelf.csv` be committed to the repo as source data?
- Should shipping rate/zone calculation logic live in Supabase (Edge Functions or tables) or remain in AppSheet?

## Key File Locations

| File | Purpose |
|------|---------|
| `schema/indB2B_schema.sql` | Full DDL — run to init DB |
| `data/brands_seed.sql` | Cumulative seed data |
| `data/branch-shelf.csv` | Physical warehouse shelf catalog (source of truth for product types) |
| `data/Package-Shipping-Reference-Supplier-Zip-Codes.csv` | Supplier origin zip codes for shipping cost estimation |
| `docs/SCHEMA.md` | Human-readable schema reference |
| `docs/DATA_CATALOG.md` | Brand/category index with status |
| `docs/DEV_GUIDE.md` | Setup instructions |
