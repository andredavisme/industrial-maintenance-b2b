# Session Handoff

> **Always update this file at the end of every work session.**
> The `indB2B`.sessions table is the DB-side audit log — insert a row there too.

## Last Updated
2026-06-25

## Project Scope (Clarified)
**No frontend development focus.** All work limited to:
- Documentation
- Data seeding
- Backend / calculation architecture support

Views and schema objects should be designed to make data accessible for any future frontend, but no UI work is in scope.

## Current State
🟢 **Phase 1 — Data Foundation complete.**
DB: **101 brands / 13 categories / 5 industries / 5 aliases / 59 supplier zip codes / 64 equipment types / 606 brand-equipment links / 250 brand-industry links**
Views: **v_brands_full ✅ / v_equipment_brands ✅**
RLS: **Enabled on all 9 tables ✅**

## Completed — 2026-06-25 (Session 12)
- [x] Created `v_brands_full` view — one row per brand with category, parent brand, and aggregated `aliases[]`, `industries[]`, `equipment_types[]` arrays
- [x] Created `v_equipment_brands` view — one row per equipment type with category, aggregated `brands[]` array (active only, sorted), and `brand_count`
- [x] Clarified project scope: no frontend focus — documentation, seeding, backend architecture only

## Completed — 2026-06-25 (Session 11)
- [x] Seeded `brand_industry_links` — 250 rows total
  - All 101 brands → General Industrial / Plant Maintenance
  - Mining & Aggregate: Caterpillar, Komatsu, John Deere, Bobcat, Metso, Kolberg, Volvo CE, Terex, Case, Hitachi, Takeuchi + bearing/power transmission/material handling brands
  - Food & Beverage Processing: SKF, NSK, Banner Engineering, Keyence, Endress+Hauser, Swan Analytical, Emerson/Rosemount, VEGA, Graco, Donaldson, Mobil, Shell Lubricants
  - Automotive Manufacturing: Fanuc, KUKA, Yaskawa, ABB, Siemens, Allen-Bradley, Toshiba, Lenze, Bodine, Baldor, WEG, Schneider Electric
  - HVAC & Facilities: Air Incorporated, FW Webb, Take 5, Donaldson, Baldor, WEG, ABB, Siemens, Schneider Electric

## Completed — 2026-06-25 (Session 10)
- [x] Seeded `brand_equipment_links` — 606 rows total

## Completed — 2026-06-25 (Session 9)
- [x] Seeded 64 `equipment_types` across all 13 categories

## Completed — 2026-06-25 (Session 8)
- [x] Updated `schema/indB2B_schema.sql`: added `supplier_zip_codes` DDL + full RLS section

## Completed — 2026-06-25 (Session 7)
- [x] Enabled RLS on all 9 tables; 8 public read policies + sessions locked to service_role

## Completed — 2026-06-25 (Session 6)
- [x] Seeded `supplier_zip_codes` (59 rows); inserted 52 new brands; `brands` at 101 total

## Completed — 2026-06-25 (Sessions 3–5)
- [x] Added Bearings, Belts & Drives, Lubricants & MRO categories + 18 brands
- [x] Created `supplier_zip_codes` table

## Completed — 2026-06-25 (Sessions 1–2)
- [x] Repo created, schema applied, initial seed data, sessions table, branch-shelf.csv analyzed

## Next Steps

| Priority | Task |
|----------|------|
| 🔴 High | Decide: shipping rate/zone logic in Supabase (Edge Functions or tables) vs. AppSheet |
| 🟡 Med  | Update `data/brands_seed.sql` to reflect 52 new brands + zip codes |
| 🟡 Med  | Commit `Package-Shipping-Reference-Supplier-Zip-Codes.csv` to `data/` |
| 🟡 Med  | Commit `branch-shelf.csv` to `data/` |
| 🟡 Med  | Update `schema/indB2B_schema.sql` to include view DDL |
| 🟡 Med  | Update `docs/SCHEMA.md` to document the two new views |

## Shipping Feature Context
A new AppSheet app ([link](https://www.appsheet.com/start/226daf34-cd2d-4d03-b9cd-9b0dd7ea3fe8)) records supplier origin zip codes to calculate estimated shipping costs.

## Open Questions
- Should shipping rate/zone calculation logic live in Supabase (Edge Functions or tables) or remain in AppSheet?
- Is RFQ functionality in scope for Phase 1 or Phase 2?

## Key File Locations

| File | Purpose |
|------|---------|
| `schema/indB2B_schema.sql` | Full DDL — **needs view DDL added** |
| `data/brands_seed.sql` | Cumulative seed data (**needs update for 52 new brands**) |
| `data/branch-shelf.csv` | Physical warehouse shelf catalog (**not yet committed**) |
| `data/Package-Shipping-Reference-Supplier-Zip-Codes.csv` | Supplier zip codes (**not yet committed**) |
| `docs/SCHEMA.md` | Human-readable schema reference (**needs view documentation**) |
| `docs/DATA_CATALOG.md` | Brand/category index with status |
| `docs/DEV_GUIDE.md` | Setup instructions |
