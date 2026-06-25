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
🟢 **Phase 1 — Shipping architecture schema complete.**

**Tables (12):** brand_aliases, brand_categories, brand_equipment_links, brand_industry_links, brands, carriers, equipment_types, industries, sessions, shipment_legs, shipments, shipping_nodes
**Views (3):** v_brands_full, v_equipment_brands, supplier_zip_codes (compat)
**RLS:** Enabled on all 12 tables ✅
**Data:** 101 brands / 13 categories / 5 industries / 59 shipping nodes (supplier) / 64 equipment types / 606 brand-equipment links / 250 brand-industry links

## Shipping Journey Model
- **Point A** — supplier origin (`shipping_nodes` where `node_type = 'supplier'`)
- **Point B** — first receiver (warehouse, distributor, etc.)
- **Point C+** — any subsequent nodes
- Each leg (A→B, B→C…) recorded in `shipment_legs` with sequence, carrier, tracking, timestamps
- Cost calculation logic deferred to Phase 2
- AppSheet app = reference library only (no calc logic)

## Completed — 2026-06-25 (Session 14)
- [x] Created `carriers` table (name, scac_code unique, website, is_active, notes)
- [x] Created `shipments` table (reference_number unique, origin/destination node FKs, status: draft/active/completed/cancelled)
- [x] Created `shipment_legs` table (shipment_id, sequence, from/to node FKs ON DELETE RESTRICT, status: pending/in_transit/delivered/cancelled, carrier_id ON DELETE RESTRICT, tracking_number, shipped_at, received_at)
- [x] All tables: RLS public read, updated_at triggers, indexes
- [x] Unique constraint on (shipment_id, sequence)

## Completed — 2026-06-25 (Session 13)
- [x] Created `shipping_nodes` table; migrated 59 `supplier_zip_codes` rows as `node_type = 'supplier'`
- [x] `supplier_zip_codes` replaced with compatibility view

## Completed — 2026-06-25 (Session 12)
- [x] Created `v_brands_full` and `v_equipment_brands` views
- [x] Clarified project scope: no frontend focus

## Completed — 2026-06-25 (Sessions 1–11)
- [x] Full schema, RLS, all seed data, brands/categories/industries/aliases/zip codes/equipment types/links

## Next Steps

| Priority | Task |
|----------|------|
| 🔴 High | Update `schema/indB2B_schema.sql` with all new DDL (shipping_nodes, carriers, shipments, shipment_legs, views) |
| 🔴 High | Update `docs/SCHEMA.md` to document all new tables and views |
| 🟡 Med  | Seed `carriers` table with common industrial carriers (UPS, FedEx, SAIA, XPO, etc.) |
| 🟡 Med  | Update `data/brands_seed.sql` (52 new brands + zip codes) |
| 🟡 Med  | Commit `Package-Shipping-Reference-Supplier-Zip-Codes.csv` to `data/` |
| 🟡 Med  | Commit `branch-shelf.csv` to `data/` |
| ⬜ Low  | Phase 2: cost calculation logic per shipment leg |

## Open Questions
- Is RFQ functionality in scope for Phase 1 or Phase 2?

## AppSheet Reference
[AppSheet app](https://www.appsheet.com/start/226daf34-cd2d-4d03-b9cd-9b0dd7ea3fe8) — reference library for supplier zip codes only.

## Key File Locations

| File | Purpose |
|------|---------|
| `schema/indB2B_schema.sql` | Full DDL — **needs update for sessions 13–14** |
| `data/brands_seed.sql` | Cumulative seed data (**needs update for 52 new brands**) |
| `data/branch-shelf.csv` | Physical warehouse shelf catalog (**not yet committed**) |
| `data/Package-Shipping-Reference-Supplier-Zip-Codes.csv` | Supplier zip codes (**not yet committed**) |
| `docs/SCHEMA.md` | Human-readable schema reference (**needs update for sessions 13–14**) |
| `docs/DATA_CATALOG.md` | Brand/category index with status |
