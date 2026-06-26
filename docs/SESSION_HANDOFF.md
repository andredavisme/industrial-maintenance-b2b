# Session Handoff

> **Always update this file at the end of every work session.**
> The `indB2B`.sessions table is the DB-side audit log — insert a row there too.

## Last Updated
2026-06-26 (session 27)

## Project Scope
**Backend complete. Frontend development is the active focus.**
- Read-only public API surface is fully ready (anon key, no auth required)
- All writes remain service-role only until Phase 2 auth is scoped

## Current State
🟢 **Phase 1 COMPLETE — Backend ready for frontend development.**

**Tables (19):** brand_aliases, brand_categories, brand_equipment_links, brand_industry_links, brands, carriers, equipment_types, industries, sessions, shipment_legs, shipments, shipping_nodes, supply_chain_links, user_brand_links, user_equipment_links, user_industry_links, users, zip_distances, zip_distance_queue
**Views (6):** v_brands_full, v_equipment_brands, supplier_zip_codes (compat), v_shipment_cost_summary, v_shipment_legs_costed, v_supply_chain_graph
**Edge Functions (1):** get-distance (Nominatim lazy-load cache)
**RLS:** Enabled on all 19 tables ✅

### File Status
| File | Status |
|------|--------|
| `schema/indB2B_schema.sql` | ✅ Synced (sessions 1–26) |
| `data/brands_seed.sql` | ✅ 101 brands / 13 categories / 5 industries / 5 aliases / 59 zip codes / 14 carriers |
| `data/branch-shelf.csv` | ✅ Committed |
| `data/Package-Shipping-Reference-Supplier-Zip-Codes-2.csv` | ✅ Committed |
| `docs/SCHEMA.md` | ✅ Synced (sessions 1–26) |
| `docs/DATA_CATALOG.md` | ✅ In sync |
| `docs/FRONTEND_GUIDE.md` | ✅ Created (session 27) |

### DB Counts
101 brands / 13 categories / 5 industries / 59 shipping nodes (supplier) / 64 equipment types / 606 brand-equipment links / 250 brand-industry links / 14 carriers / **101 users (78 vendor, 23 distributor)** / 101 user_brand_links / 250 user_industry_links / 606 user_equipment_links / **47 supply_chain_links** / 0 zip_distances (on-demand via Edge Function)

## Frontend Build — Next Steps (Active)

| Priority | Task | Doc Reference |
|----------|------|---------------|
| ⬜ 1 | Define URL/page structure (routes) | FRONTEND_GUIDE.md |
| ⬜ 2 | Decide frontend framework | FRONTEND_GUIDE.md |
| ⬜ 3 | Wire Supabase anon key + client | FRONTEND_GUIDE.md |
| ⬜ 4 | Build Equipment → Brand → Distributor query chain | FRONTEND_GUIDE.md |
| ⬜ 5 | Build supply chain graph visualization | FRONTEND_GUIDE.md |

## Phase 2 Backlog (deferred)

| Priority | Task |
|----------|------|
| ⬜ Low | Phase 2 auth wiring: FK `auth_user_id → auth.users(id)` + RLS write policies |
| ⬜ Low | Back-populate `shipping_nodes.user_id` for existing supplier nodes |
| ⬜ Low | RFQ functionality (scope TBD) |
| ⬜ Low | Monitor `zip_distance_queue` for failed geocodes (currently empty) |

## Open Questions
- What frontend framework? (React, plain HTML/JS, other)
- Is RFQ functionality in scope for Phase 2?

## Architecture Quick Reference

### Public Read API (anon key, no auth)
All reads go through Supabase REST or JS client using the anon publishable key.
See `docs/FRONTEND_GUIDE.md` for query patterns per screen.

### Actor Types (users table)
- `vendor` — brand manufacturer/rep; supplies distributors
- `distributor` — carries vendor brands; sells to end users
- `end_user` — buyer (Phase 2 auth scope)

### Distance Lookup
- **Edge Function:** `POST /functions/v1/get-distance` with `{ zip_from, zip_to }`
- Lazy-load cache: checks `zip_distances` first, geocodes via Nominatim on miss
- Failures queued to `zip_distance_queue` (currently 0 rows)

### Supply Chain Graph
- `supply_chain_links` — raw edges (supplier_id → buyer_id)
- `v_supply_chain_graph` — enriched view with node details + shared brand/industry/equipment arrays

### Shipping Cost
- `v_shipment_legs_costed` — per-leg effective miles + cost (override → generated → lookup)
- `v_shipment_cost_summary` — rollup per shipment

## Completed — 2026-06-26 (Sessions 24–27)
- [x] Created `v_supply_chain_graph` view (session 24)
- [x] Synced schema/indB2B_schema.sql + docs/SCHEMA.md with v_supply_chain_graph (session 25)
- [x] Added `user_id` FK (nullable) to `shipping_nodes`; refreshed `supplier_zip_codes` view (session 26)
- [x] zip_distance_queue confirmed empty — no failures (session 27)
- [x] Created docs/FRONTEND_GUIDE.md with full public API surface map (session 27)
- [x] Updated SESSION_HANDOFF.md to reflect frontend-active phase (session 27)

## Completed — 2026-06-25 (Sessions 1–23)
- [x] Full schema, all seed data, brand/category/industry/equipment/links, shipping architecture, views, RLS
- [x] 101 users seeded (78 vendor, 23 distributor) with full link table population
- [x] 47 supply_chain_links seeded across 6 categories
- [x] get-distance Edge Function deployed
- [x] zip_distances lazy-load cache architecture

## AppSheet Reference
[AppSheet app](https://www.appsheet.com/start/226daf34-cd2d-4d03-b9cd-9b0dd7ea3fe8) — reference library for supplier zip codes only.

## Key File Locations

| File | Purpose |
|------|---------|
| `schema/indB2B_schema.sql` | Full DDL — ✅ synced |
| `data/brands_seed.sql` | Cumulative seed data — ✅ complete |
| `docs/SCHEMA.md` | Human-readable schema reference — ✅ synced |
| `docs/FRONTEND_GUIDE.md` | Public API surface + screen query map — ✅ new |
| `docs/DATA_CATALOG.md` | Brand/category index — ✅ in sync |
| `docs/DEV_GUIDE.md` | Setup instructions |
