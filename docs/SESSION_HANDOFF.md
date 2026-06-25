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
🟢 **Phase 1 — COMPLETE. Cost estimation layer complete (sessions 18–19).**

**Tables (13):** brand_aliases, brand_categories, brand_equipment_links, brand_industry_links, brands, carriers, equipment_types, industries, sessions, shipment_legs, shipments, shipping_nodes, zip_distances
**Views (5):** v_brands_full, v_equipment_brands, supplier_zip_codes (compat), v_shipment_cost_summary, v_shipment_legs_costed
**RLS:** Enabled on all 13 tables ✅

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
101 brands / 13 categories / 5 industries / 59 shipping nodes (supplier) / 64 equipment types / 606 brand-equipment links / 250 brand-industry links / 14 carriers / 0 zip_distances (empty — needs population)

## Shipping Journey Model
- **Point A** — supplier origin (`shipping_nodes` where `node_type = 'supplier'`)
- **Point B** — first receiver (warehouse, distributor, etc.)
- **Point C+** — any subsequent nodes
- Each leg recorded in `shipment_legs` with sequence, carrier, tracking, timestamps
- Cost inputs: `weight_lbs`, `est_miles`, `est_cost_per_mile`
- `est_freight_cost` = GENERATED STORED (`weight_lbs * est_miles * est_cost_per_mile`)
- `est_freight_cost_override` = manual override; takes precedence in all rollups
- `zip_distances` table = bidirectional zip pair distance lookup
- `v_shipment_legs_costed` = full costed view: auto-fills distance from zip_distances when est_miles not set
- Actual/invoiced costs deferred to financial tables (Phase 2+)

## Completed — 2026-06-25 (Session 19)
- [x] Created `zip_distances` table (zip_from, zip_to PK, miles, source, RLS, trigger)
- [x] Created `v_shipment_legs_costed` view (bidirectional zip lookup, effective_miles, effective_freight_cost priority chain)
- [x] Synced `schema/indB2B_schema.sql`, `docs/SCHEMA.md`, `docs/SESSION_HANDOFF.md`

## Completed — 2026-06-25 (Session 18)
- [x] Added cost fields to `shipment_legs`: `weight_lbs`, `est_miles`, `est_cost_per_mile`, `est_freight_cost` (GENERATED STORED), `est_freight_cost_override`
- [x] Created `v_shipment_cost_summary` view
- [x] Synced schema and docs

## Completed — 2026-06-25 (Sessions 15–17)
- [x] Seeded carriers (14 rows), updated brands_seed.sql, DATA_CATALOG.md
- [x] Committed branch-shelf.csv and Package-Shipping-Reference-Supplier-Zip-Codes-2.csv

## Completed — 2026-06-25 (Sessions 1–14)
- [x] Full schema, all seed data, brand/category/industry/equipment/links, views, RLS, shipping architecture

## Next Steps (Phase 2)

| Priority | Task |
|----------|------|
| ⬜ High | Populate `zip_distances` with actual supplier→destination pairs |
| ⬜ Low | RFQ functionality (scope TBD) |
| ⬜ Low | Financial tables for actual/invoiced costs per order |

## Open Questions
- Is RFQ functionality in scope for Phase 2?
- How should `zip_distances` be populated — manual entry, bulk CSV import, or API script?

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
