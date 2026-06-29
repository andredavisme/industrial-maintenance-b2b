# Session Handoff

> **Always update this file at the end of every work session.**
> The `indB2B`.sessions table is the DB-side audit log — insert a row there too.

## Last Updated
2026-06-29 (session 32)

## Project Scope
**Frontend scaffolded and live on GitHub Pages. Full equipment click path working end-to-end.**
- Read-only public API surface is fully ready (anon key, no auth required)
- All writes remain service-role only until Phase 2 auth is scoped

## Current State
🟢 **Phase 1 COMPLETE — All core screens functional.**

**Tables (19):** brand_aliases, brand_categories, brand_equipment_links, brand_industry_links, brands, carriers, equipment_types, industries, sessions, shipment_legs, shipments, shipping_nodes, supply_chain_links, user_brand_links, user_equipment_links, user_industry_links, users, zip_distances, zip_distance_queue

**Additional tables in schema (not in docs/SCHEMA.md yet):** supplier_zip_codes

**Views (6):** v_brands_full, v_equipment_brands (updated — includes `brand_slugs` array), v_shipment_cost_summary, v_shipment_legs_costed, v_supply_chain_graph, supplier_zip_codes (compat view)

**Edge Functions (1):** get-distance (Nominatim lazy-load cache)

**RLS:** Enabled on all 19 tables ✅ — all policies explicitly grant `anon` role

### Live DB Counts (as of 2026-06-29)
101 brands / 13 categories / 5 industries / 64 equipment types / 606 brand-equipment links / 250 brand-industry links / 14 carriers / 59 shipping nodes / 101 users (78 vendor, 23 distributor) / 215 user_brand_links / 250 user_industry_links / 606 user_equipment_links / 47 supply_chain_links / 0 zip_distances / 0 zip_distance_queue / 31 sessions

### File Status
| File | Status |
|------|--------|
| `schema/indB2B_schema.sql` | ⚠️ Needs sync — v_equipment_brands rebuilt (session 31); supplier_zip_codes table missing |
| `data/brands_seed.sql` | ⚠️ Needs sync — 140+ distributor brand links added (session 31) |
| `docs/SCHEMA.md` | ⚠️ Needs sync — v_equipment_brands brand_slugs column; supplier_zip_codes table |
| `docs/DATA_CATALOG.md` | ✅ In sync |
| `docs/FRONTEND_GUIDE.md` | ✅ Current |
| `docs/index.html` | ✅ Current |
| `docs/equipment.html` | ✅ Updated (session 31) |
| `docs/brand.html` | ✅ Updated (session 31) |
| `docs/distributor.html` | ✅ Verified functional (session 31) |
| `docs/network.html` | ✅ Current |
| `docs/find.html` | ✅ Wired, needs live test |
| `docs/js/equipment.js` | ✅ Fixed (session 31) |
| `docs/js/brand.js` | ✅ Fixed + slug normalizer (session 31) |
| `docs/js/network.js` | ✅ Current |
| `docs/css/network.css` | ✅ Current |

## Frontend Build — Next Steps

| Priority | Task | Status |
|----------|------|--------|
| ✅ | Scaffold GitHub Pages frontend (docs/) | Done session 28 |
| ✅ | Fix RLS anon access (10 tables) | Done session 28 |
| ✅ | Build supply chain graph visualization (Screen 4) | Done session 30 |
| ✅ | Equipment page click path: category→type→brand→distributor | Done session 31 |
| ✅ | Brand page: add Vendor section (who makes it) | Done session 31 |
| ✅ | Distributor profile page (Screen 3) — verify data flows | Done session 31 |
| ⬜ 1 | Find Near Me (Screen 5) — live test with real zip input | Next |
| ⬜ 2 | Sync schema/indB2B_schema.sql + docs/SCHEMA.md (supplier_zip_codes, v_equipment_brands) | Next |
| ⬜ 3 | Sync data/brands_seed.sql (140+ distributor brand links from session 31) | Next |
| ⬜ 4 | Graph tooltip: add company logo + website link | Backlog |
| ⬜ 5 | Data refinement: fix brand website URLs (e.g. Schaeffler → EN site) | Backlog |

## Known Data Issues
- Schaeffler website stored as `https://www.schaeffler.com/fork/` — routes to German site. Defer to data refinement pass.
- `user_brand_links` count (215) is lower than expected (101 vendor + ~140 distributor = ~241). May indicate some distributor brand links did not seed correctly — worth verifying.

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
- [x] Added Vendor section to brand profile page (brand.js + brand.html)
- [x] Verified distributor profile page data flows — 7 brands, 2 industries, 9 equipment types for Royal Bearing test case
- [x] Full click path verified: category → type → brand → distributor ✅

## Completed — 2026-06-29 (Session 32)
- [x] Audited SESSION_HANDOFF.md against live schema and file tree
- [x] Updated DB counts, file status table, and Next Steps priority list
- [x] Flagged user_brand_links count discrepancy (215 vs expected ~241) as known issue

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
| `schema/indB2B_schema.sql` | Full DDL — ⚠️ needs sync for v_equipment_brands + supplier_zip_codes |
| `data/brands_seed.sql` | Cumulative seed data — ⚠️ needs distributor brand links added |
| `docs/SCHEMA.md` | Human-readable schema reference — ⚠️ needs sync |
| `docs/FRONTEND_GUIDE.md` | Public API surface + screen query map |
| `docs/DATA_CATALOG.md` | Brand/category index |
| `docs/index.html` | Home page |
| `docs/js/supabase.js` | Supabase client config (db.schema: indB2B) |
| `docs/js/equipment.js` | Equipment search — category→type→brand drill-down |
| `docs/js/brand.js` | Brand profile — vendors + distributors + slug normalizer |
| `docs/js/network.js` | Graph viz — Cytoscape, node IDs, tooltip, legend |
| `docs/css/network.css` | Graph layout + tooltip + legend styles |
