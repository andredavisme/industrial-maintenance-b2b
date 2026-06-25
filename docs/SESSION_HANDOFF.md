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
🟢 **Phase 1 — Data Foundation complete. Shipping architecture in progress.**
DB: **101 brands / 13 categories / 5 industries / 5 aliases / 59 shipping nodes (supplier) / 64 equipment types / 606 brand-equipment links / 250 brand-industry links**
Views: **v_brands_full ✅ / v_equipment_brands ✅ / supplier_zip_codes (compat view) ✅**
RLS: **Enabled on all 10 tables ✅**

## Shipping Journey Model
A shipment is a sequence of legs:
- **Point A** — supplier origin (lives in `shipping_nodes` as `node_type = 'supplier'`)
- **Point B** — first receiver (warehouse, distributor, etc.)
- **Point C+** — any subsequent nodes in the chain

Each leg (A→B, B→C, etc.) is an independent unit: `origin_node × destination_node → cost`.
Cost calculation logic is **Phase 2** — no calc logic exists yet.
AppSheet app is a **reference library only** (no calc logic).

## Completed — 2026-06-25 (Session 13)
- [x] Created `shipping_nodes` table with `node_type` (supplier/warehouse/distributor/customer), `brand_id` FK, zip/city/state, `is_primary`, `notes`
- [x] Migrated all 59 `supplier_zip_codes` rows into `shipping_nodes` as `node_type = 'supplier'`
- [x] Replaced `supplier_zip_codes` table with a compatibility view over `shipping_nodes`
- [x] RLS enabled on `shipping_nodes` (public read)
- [x] Defined shipping journey model (Point A/B/C leg architecture)

## Completed — 2026-06-25 (Session 12)
- [x] Created `v_brands_full` and `v_equipment_brands` views
- [x] Clarified project scope: no frontend focus

## Completed — 2026-06-25 (Session 11)
- [x] Seeded `brand_industry_links` — 250 rows total

## Completed — 2026-06-25 (Session 10)
- [x] Seeded `brand_equipment_links` — 606 rows total

## Completed — 2026-06-25 (Session 9)
- [x] Seeded 64 `equipment_types` across all 13 categories

## Completed — 2026-06-25 (Sessions 1–8)
- [x] Full schema, RLS, seed data, brands/categories/industries/aliases/zip codes

## Next Steps

| Priority | Task |
|----------|------|
| 🔴 High | Design `shipment_legs` table (from_node, to_node, sequence, cost fields) |
| 🔴 High | Update `schema/indB2B_schema.sql` with `shipping_nodes` DDL + new views |
| 🔴 High | Update `docs/SCHEMA.md` to document `shipping_nodes`, views, and shipping model |
| 🟡 Med  | Update `data/brands_seed.sql` (52 new brands + zip codes) |
| 🟡 Med  | Commit `Package-Shipping-Reference-Supplier-Zip-Codes.csv` to `data/` |
| 🟡 Med  | Commit `branch-shelf.csv` to `data/` |

## Open Questions
- Should `shipment_legs` be built now (schema only, no calc logic) or deferred to Phase 2?
- Is RFQ functionality in scope for Phase 1 or Phase 2?

## AppSheet Reference
[AppSheet app](https://www.appsheet.com/start/226daf34-cd2d-4d03-b9cd-9b0dd7ea3fe8) — reference library for supplier zip codes only, no calculation logic.

## Key File Locations

| File | Purpose |
|------|---------|
| `schema/indB2B_schema.sql` | Full DDL — **needs shipping_nodes + view updates** |
| `data/brands_seed.sql` | Cumulative seed data (**needs update for 52 new brands**) |
| `data/branch-shelf.csv` | Physical warehouse shelf catalog (**not yet committed**) |
| `data/Package-Shipping-Reference-Supplier-Zip-Codes.csv` | Supplier zip codes (**not yet committed**) |
| `docs/SCHEMA.md` | Human-readable schema reference (**needs shipping_nodes + views**) |
| `docs/DATA_CATALOG.md` | Brand/category index with status |
