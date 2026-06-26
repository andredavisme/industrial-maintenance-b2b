# Session Handoff

> **Always update this file at the end of every work session.**
> The `indB2B`.sessions table is the DB-side audit log — insert a row there too.

## Last Updated
2026-06-26 (session 31)

## Project Scope
**Frontend scaffolded and live on GitHub Pages. Equipment page click path now working end-to-end.**
- Read-only public API surface is fully ready (anon key, no auth required)
- All writes remain service-role only until Phase 2 auth is scoped

## Current State
🟢 **Phase 1 COMPLETE — Equipment search click path fully functional.**

**Tables (19):** brand_aliases, brand_categories, brand_equipment_links, brand_industry_links, brands, carriers, equipment_types, industries, sessions, shipment_legs, shipments, shipping_nodes, supply_chain_links, user_brand_links, user_equipment_links, user_industry_links, users, zip_distances, zip_distance_queue
**Views (6):** v_brands_full, v_equipment_brands, supplier_zip_codes (compat), v_shipment_cost_summary, v_shipment_legs_costed, v_supply_chain_graph
**Edge Functions (1):** get-distance (Nominatim lazy-load cache)
**RLS:** Enabled on all 19 tables ✅ — all policies now explicitly grant `anon` role

### File Status
| File | Status |
|------|--------|
| `schema/indB2B_schema.sql` | ⚠️ Needs sync — v_equipment_brands rebuilt (session 31) |
| `data/brands_seed.sql` | ⚠️ Needs sync — 140+ distributor brand links added (session 31) |
| `docs/SCHEMA.md` | ⚠️ Needs sync — v_equipment_brands now has brand_slugs column |
| `docs/DATA_CATALOG.md` | ✅ In sync |
| `docs/FRONTEND_GUIDE.md` | ✅ Current |
| `docs/equipment.html` + `docs/brand.html` | ✅ Updated (session 31) |
| `docs/js/equipment.js` | ✅ Fixed (session 31) |
| `docs/js/brand.js` | ✅ Fixed (session 31) |

### DB Counts
101 brands / 13 categories / 5 industries / 59 shipping nodes / 64 equipment types / 606 brand-equipment links / 250 brand-industry links / 14 carriers / 101 users (78 vendor, 23 distributor) / **~241 user_brand_links (101 vendor + ~140 distributor)** / 250 user_industry_links / 606 user_equipment_links / 47 supply_chain_links / 0 zip_distances

## Frontend Build — Next Steps (Active)

| Priority | Task | Status |
|----------|------|--------|
| ✅ | Scaffold GitHub Pages frontend (docs/) | Done session 28 |
| ✅ | Fix RLS anon access (10 tables) | Done session 28 |
| ✅ | Build supply chain graph visualization (Screen 4) | Done session 30 |
| ✅ | Equipment page click path: category→type→brand→distributor | Done session 31 |
| ⬜ 1 | Brand page: add Vendor section (who makes it) | Next |
| ⬜ 2 | Distributor profile page (Screen 3) — verify data flows | Next |
| ⬜ 3 | Graph tooltip: add company logo + website | Backlog |
| ⬜ 4 | Find Near Me (Screen 5) | Wired, needs live test |
| ⬜ 5 | Data refinement: fix brand website URLs (e.g. Schaeffler → EN site) | Backlog |

## Known Data Issues
- Schaeffler website stored as `https://www.schaeffler.com/fork/` — routes to German site. Defer to data refinement pass.

## Phase 2 Backlog (deferred)

| Priority | Task |
|----------|------|
| ⬜ Low | Phase 2 auth wiring: FK `auth_user_id → auth.users(id)` + RLS write policies |
| ⬜ Low | Back-populate `shipping_nodes.user_id` for existing supplier nodes |
| ⬜ Low | RFQ functionality (scope TBD) |
| ⬜ Low | Monitor `zip_distance_queue` for failed geocodes (currently empty) |

## Architecture Quick Reference

### Public Read API (anon key, no auth)
All reads go through Supabase REST or JS client using the anon publishable key.
See `docs/FRONTEND_GUIDE.md` for query patterns per screen.

### Frontend Stack
- Vanilla HTML + JS ES modules (no build step)
- GitHub Pages serving from `docs/` folder
- Supabase JS v2 via esm.sh CDN
- Publishable key: `sb_publishable_Lc7rXKQ-1TJaQFu7a-nOVQ_5Sf3x__M`
- Project URL: `https://nmemmfblpzrkwyljpmvp.supabase.co`

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
- Graph viz: Cytoscape.js, short node IDs (V1/D1), hover tooltip (name), click → sidebar detail + faded subgraph

### v_equipment_brands (updated session 31)
- Now includes `brand_slugs` array (sorted by b.name, parallel to `brands` name array)
- Filter on `equipment_slug` (not `slug`)

## Completed — 2026-06-26 (Session 31)
- [x] Fixed `equipment.js`: filter column `slug` → `equipment_slug`
- [x] Rebuilt `v_equipment_brands`: added `brand_slugs` array, both arrays sorted by `b.name`
- [x] Seeded ~140 distributor brand links across all 23 distributors (industry-aligned)
- [x] Fixed `equipment.js`: zip `brands`+`brand_slugs` for correct href links
- [x] Added slug normalizer to `brand.js` as safety net
- [x] Cache-busted `equipment.js?v=2` and `brand.js?v=2` in HTML files
- [x] Full click path verified: category → type → brand → distributor ✅

## Completed — 2026-06-26 (Sessions 24–30)
- [x] Created `v_supply_chain_graph` view (session 24)
- [x] Synced schema/indB2B_schema.sql + docs/SCHEMA.md (session 25)
- [x] Added `user_id` FK to `shipping_nodes` (session 26)
- [x] Created docs/FRONTEND_GUIDE.md (session 27)
- [x] Scaffolded full GitHub Pages frontend — 6 HTML, 7 JS, 1 CSS (session 28)
- [x] Fixed RLS: 10 tables updated from {public} → {anon, authenticated} (session 28)
- [x] Fixed 404 on graph API: exposed indB2B schema in API settings + granted USAGE/SELECT to anon/authenticated (session 30)
- [x] Fixed supabase.js: added `db: { schema: 'indB2B' }` to createClient (session 30)
- [x] Graph viz complete: short IDs (V1/D1), legend panel, hover tooltip (name), click sidebar detail (session 30)
- [x] Fixed tooltip 404→visible: moved #graph-tooltip to body level, position:fixed with clientX/Y (session 30)

## Completed — 2026-06-25 (Sessions 1–23)
- [x] Full schema, all seed data, brand/category/industry/equipment/links, shipping architecture, views, RLS
- [x] 101 users seeded (78 vendor, 23 distributor) with full link table population
- [x] 47 supply_chain_links seeded across 6 categories
- [x] get-distance Edge Function deployed

## AppSheet Reference
[AppSheet app](https://www.appsheet.com/start/226daf34-cd2d-4d03-b9cd-9b0dd7ea3fe8) — reference library for supplier zip codes only.

## Key File Locations

| File | Purpose |
|------|---------|
| `schema/indB2B_schema.sql` | Full DDL — ⚠️ needs sync for v_equipment_brands |
| `data/brands_seed.sql` | Cumulative seed data — ⚠️ needs distributor brand links added |
| `docs/SCHEMA.md` | Human-readable schema reference — ⚠️ needs sync |
| `docs/FRONTEND_GUIDE.md` | Public API surface + screen query map |
| `docs/DATA_CATALOG.md` | Brand/category index |
| `docs/index.html` | Home page |
| `docs/js/supabase.js` | Supabase client config (db.schema: indB2B) |
| `docs/js/equipment.js` | Equipment search — category→type→brand drill-down |
| `docs/js/brand.js` | Brand profile — distributors + slug normalizer |
| `docs/js/network.js` | Graph viz — Cytoscape, node IDs, tooltip, legend |
| `docs/css/network.css` | Graph layout + tooltip + legend styles |
