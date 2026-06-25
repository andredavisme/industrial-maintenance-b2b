# Session Handoff

> **Always update this file at the end of every work session.**
> The `indB2B`.sessions table is the DB-side audit log — insert a row there too.

## Last Updated
2026-06-25

## Current State
🟡 **Phase 1 — Data Foundation** in progress.
DB: **101 brands / 13 categories / 5 industries / 5 aliases / 59 supplier zip codes / 64 equipment types**
RLS: **Enabled on all 9 tables ✅**

## Completed — 2026-06-25 (Session 9)
- [x] Seeded 64 `equipment_types` across all 13 categories
  - Bearings (9), Belts & Drives (7), Motors & Drives (5), Pneumatics & Hydraulics (6)
  - PLCs & Control (5), Sensing & Instrumentation (6), Conveyors (4), Fasteners (5)
  - HVAC (3), Safety (3), Robotics (3), Heavy Equipment (3), Lubricants & MRO (5)

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
| 🔴 High | Seed `brand_equipment_links` — link brands to equipment types (M:M, currently empty) |
| 🔴 High | Seed `brand_industry_links` — link brands to industries (M:M, currently empty) |
| 🟡 Med  | Create views: `v_brands_full`, `v_equipment_brands` |
| 🟡 Med  | Commit `Package-Shipping-Reference-Supplier-Zip-Codes.csv` to `data/` |
| 🟡 Med  | Commit `branch-shelf.csv` to `data/` |
| 🟡 Med  | Update `data/brands_seed.sql` to reflect 52 new brands + zip codes |
| ⬜ Low  | Scaffold web app consuming indB2B schema |

## Shipping Feature Context
A new AppSheet app ([link](https://www.appsheet.com/start/226daf34-cd2d-4d03-b9cd-9b0dd7ea3fe8)) records supplier origin zip codes to calculate estimated shipping costs.

## Open Questions
- Will the web app be Cloudflare Pages or GitHub Pages?
- Is RFQ functionality in scope for Phase 1 or Phase 2?
- Should shipping rate/zone calculation logic live in Supabase (Edge Functions or tables) or remain in AppSheet?

## Key File Locations

| File | Purpose |
|------|---------|
| `schema/indB2B_schema.sql` | Full DDL — in sync with live DB ✅ |
| `data/brands_seed.sql` | Cumulative seed data (**needs update for 52 new brands**) |
| `data/branch-shelf.csv` | Physical warehouse shelf catalog (**not yet committed**) |
| `data/Package-Shipping-Reference-Supplier-Zip-Codes.csv` | Supplier zip codes (**not yet committed**) |
| `docs/SCHEMA.md` | Human-readable schema reference |
| `docs/DATA_CATALOG.md` | Brand/category index with status |
| `docs/DEV_GUIDE.md` | Setup instructions |
