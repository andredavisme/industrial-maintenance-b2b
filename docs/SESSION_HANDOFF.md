# Session Handoff

> **Always update this file at the end of every work session.**
> The `indB2B`.sessions table is the DB-side audit log — insert a row there too.

## Last Updated
2026-06-25

## Project Scope
**No frontend development focus.** All work limited to:
- Documentation
- Data seeding
- Backend / calculation architecture support

## Current State
🟢 **Phase 1 — COMPLETE. Distance lookup layer complete (sessions 21). Ready for Phase 2.**

**Tables (14):** brand_aliases, brand_categories, brand_equipment_links, brand_industry_links, brands, carriers, equipment_types, industries, sessions, shipment_legs, shipments, shipping_nodes, zip_distances, zip_distance_queue
**Views (5):** v_brands_full, v_equipment_brands, supplier_zip_codes (compat), v_shipment_cost_summary, v_shipment_legs_costed
**Edge Functions (1):** get-distance (Nominatim lazy-load cache)
**RLS:** Enabled on all 14 tables ✅

### File Status
| File | Status |
|------|--------|
| `schema/indB2B_schema.sql` | ✅ In sync |
| `data/brands_seed.sql` | ✅ 101 brands / 13 categories / 5 industries / 5 aliases / 59 zip codes / 14 carriers |
| `data/branch-shelf.csv` | ✅ Committed |
| `data/Package-Shipping-Reference-Supplier-Zip-Codes-2.csv` | ✅ Committed |
| `docs/SCHEMA.md` | ✅ In sync |
| `docs/DATA_CATALOG.md` | ✅ In sync |

### DB Counts
101 brands / 13 categories / 5 industries / 59 shipping nodes (supplier) / 64 equipment types / 606 brand-equipment links / 250 brand-industry links / 14 carriers / 0 zip_distances (populates on-demand via get-distance Edge Function)

## Distance Lookup Architecture
- **Edge Function:** `get-distance` — `POST /functions/v1/get-distance` with `{ zip_from, zip_to }`
- **Cache:** `zip_distances` table — bidirectional lookup, `source = 'nominatim'` for auto-resolved
- **Fallback:** `zip_distance_queue` — `status = 'pending'` rows need manual agent review
- **Algorithm:** Nominatim geocode → haversine × 1.3 road factor
- **No API key required**

## Shipping Journey Model
- **Point A** — supplier origin (`shipping_nodes` where `node_type = 'supplier'`)
- **Point B** — first receiver (warehouse, distributor, etc.)
- **Point C+** — any subsequent nodes
- Each leg recorded in `shipment_legs` with sequence, carrier, tracking, timestamps
- Cost inputs: `weight_lbs`, `est_miles`, `est_cost_per_mile`
- `est_freight_cost` = GENERATED STORED (`weight_lbs * est_miles * est_cost_per_mile`)
- `est_freight_cost_override` = manual override; takes precedence in all rollups
- `zip_distances` = lazy-load cache, auto-populated by get-distance function
- `v_shipment_legs_costed` = full costed view with auto distance lookup

## Completed — 2026-06-25 (Session 21)
- [x] Created `zip_distance_queue` table (pending/resolved/failed, RLS, trigger)
- [x] Deployed `get-distance` Edge Function v1 (Nominatim geocode, haversine × 1.3, lazy-load cache, queue fallback)
- [x] Updated `zip_distances` source CHECK to include `nominatim`
- [x] Synced `schema/indB2B_schema.sql`, `docs/SCHEMA.md`, `docs/SESSION_HANDOFF.md`

## Completed — 2026-06-25 (Session 20 — closeout)
- [x] Updated SESSION_HANDOFF.md with confirmed next step: API script to populate zip_distances

## Completed — 2026-06-25 (Session 19)
- [x] Created `zip_distances` table (zip_from, zip_to PK, miles, source, RLS, trigger)
- [x] Created `v_shipment_legs_costed` view
- [x] Synced schema and docs

## Completed — 2026-06-25 (Session 18)
- [x] Added cost fields to `shipment_legs`
- [x] Created `v_shipment_cost_summary` view

## Completed — 2026-06-25 (Sessions 15–17)
- [x] Seeded carriers (14 rows), committed CSV data files

## Completed — 2026-06-25 (Sessions 1–14)
- [x] Full schema, all seed data, brand/category/industry/equipment/links, views, RLS, shipping architecture

## Next Steps (Phase 2)

| Priority | Task |
|----------|------|
| ⬜ Medium | Monitor `zip_distance_queue` for failed geocodes; resolve manually |
| ⬜ Low | RFQ functionality (scope TBD) |
| ⬜ Low | Financial tables for actual/invoiced costs per order |

## Open Questions
- Is RFQ functionality in scope for Phase 2?
- What are the known destination zip codes (warehouses/distributors)?

## AppSheet Reference
[AppSheet app](https://www.appsheet.com/start/226daf34-cd2d-4d03-b9cd-9b0dd7ea3fe8) — reference library for supplier zip codes only.

## Key File Locations

| File | Purpose |
|------|---------|
| `schema/indB2B_schema.sql` | Full DDL — ✅ in sync |
| `data/brands_seed.sql` | Cumulative seed data — ✅ complete |
| `data/branch-shelf.csv` | Physical warehouse shelf catalog — ✅ committed |
| `data/Package-Shipping-Reference-Supplier-Zip-Codes-2.csv` | Supplier zip codes source reference — ✅ committed |
| `docs/SCHEMA.md` | Human-readable schema reference — ✅ in sync |
| `docs/DATA_CATALOG.md` | Brand/category index with status — ✅ in sync |
