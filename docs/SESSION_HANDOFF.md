# Session Handoff

> **Always update this file at the end of every work session.**
> The `indB2B`.sessions table is the DB-side audit log — insert a row there too.

## Last Updated
2026-06-26

## Project Scope
**No frontend development focus.** All work limited to:
- Documentation
- Data seeding
- Backend / calculation architecture support

## Current State
🟢 **Phase 1 — COMPLETE. v_supply_chain_graph view created (session 24). Ready for auth wiring or next Phase 2 task.**

**Tables (19):** brand_aliases, brand_categories, brand_equipment_links, brand_industry_links, brands, carriers, equipment_types, industries, sessions, shipment_legs, shipments, shipping_nodes, supply_chain_links, user_brand_links, user_equipment_links, user_industry_links, users, zip_distances, zip_distance_queue
**Views (6):** v_brands_full, v_equipment_brands, supplier_zip_codes (compat), v_shipment_cost_summary, v_shipment_legs_costed, **v_supply_chain_graph** ✅
**Edge Functions (1):** get-distance (Nominatim lazy-load cache)
**RLS:** Enabled on all 19 tables ✅

### File Status
| File | Status |
|------|--------|
| `schema/indB2B_schema.sql` | ⚠️ Needs sync (v_supply_chain_graph DDL not yet committed) |
| `data/brands_seed.sql` | ✅ 101 brands / 13 categories / 5 industries / 5 aliases / 59 zip codes / 14 carriers |
| `data/branch-shelf.csv` | ✅ Committed |
| `data/Package-Shipping-Reference-Supplier-Zip-Codes-2.csv` | ✅ Committed |
| `docs/SCHEMA.md` | ⚠️ Needs sync (v_supply_chain_graph not yet documented) |
| `docs/DATA_CATALOG.md` | ✅ In sync |

### DB Counts
101 brands / 13 categories / 5 industries / 59 shipping nodes (supplier) / 64 equipment types / 606 brand-equipment links / 250 brand-industry links / 14 carriers / **101 users (78 vendor, 23 distributor)** / **101 user_brand_links** / **250 user_industry_links** / **606 user_equipment_links** / **47 supply_chain_links** / 0 zip_distances (populates on-demand via get-distance Edge Function)

## v_supply_chain_graph (Session 24)

One row per directed supply chain edge (`supply_chain_links`), enriched with full node context.

### Columns
| Column | Description |
|--------|-------------|
| `link_id`, `link_type`, `link_active` | Edge metadata |
| `supplier_id/name/slug/type/website` | Upstream node (vendor) |
| `buyer_id/name/slug/type/website` | Downstream node (distributor/end_user) |
| `shared_brands[]` | Brands both parties carry |
| `shared_categories[]` | Brand categories bridging the edge |
| `shared_industries[]` | Industries both parties serve |
| `shared_equipment_types[]` | Equipment types both parties cover |

## User / Supply Chain Architecture (Session 22)

### Actor Types
- `end_user` — sources from distributors only
- `distributor` — sources from vendors/distributors, supplies customers/distributors/vendors
- `vendor` — sources from vendors/distributors, supplies distributors/end users

### New Tables
| Table | Purpose |
|-------|---------|
| `users` | Public company directory; `actor_type` enforced by CHECK; `auth_user_id uuid UNIQUE` nullable for Phase 2 auth |
| `user_brand_links` | M:M users ↔ brands (role: authorized_dealer, distributor, manufacturer_rep) |
| `user_industry_links` | M:M users ↔ industries |
| `user_equipment_links` | M:M users ↔ equipment_types |
| `supply_chain_links` | Graph edge table: supplier_id → buyer_id with link_type CHECK |

### RLS
- `users`: public SELECT where `is_public = true`
- `supply_chain_links`: public SELECT where `is_active = true`
- All link tables: public SELECT unrestricted
- Writes: service role only (Phase 2 will add auth-gated policies)

### Phase 2 Auth Wiring (non-breaking)
```sql
ALTER TABLE "indB2B".users
  ADD CONSTRAINT users_auth_user_id_fkey
  FOREIGN KEY (auth_user_id) REFERENCES auth.users(id) ON DELETE SET NULL;
```

## Distance Lookup Architecture
- **Edge Function:** `get-distance` — `POST /functions/v1/get-distance` with `{ zip_from, zip_to }`
- **Cache:** `zip_distances` table — bidirectional lookup, `source = 'nominatim'` for auto-resolved
- **Fallback:** `zip_distance_queue` — `status = 'pending'` rows need manual agent review
- **Algorithm:** Nominatim geocode → haversine × 1.3 road factor

## Shipping Journey Model
- Each leg recorded in `shipment_legs` with sequence, carrier, tracking, timestamps
- Cost inputs: `weight_lbs`, `est_miles`, `est_cost_per_mile`
- `est_freight_cost` = GENERATED STORED (`weight_lbs * est_miles * est_cost_per_mile`)
- `est_freight_cost_override` = manual override; takes precedence in all rollups
- `v_shipment_legs_costed` = full costed view with auto distance lookup

## Completed — 2026-06-26 (Session 24)
- [x] Created `v_supply_chain_graph` view: directed edge per supply_chain_links row, enriched with supplier/buyer user details and aggregated arrays of shared_brands, shared_categories, shared_industries, shared_equipment_types
- [x] Verified with sample query — returning correct vendor→distributor edges (e.g. Siemens→Santa Clara Systems, Gates→Zoro, SKF→TCI Supply)

## Completed — 2026-06-25 (Session 23)
- [x] Seeded `users` table: 101 rows (78 vendor, 23 distributor) from brands data via slug match
- [x] Auto-populated `user_brand_links` (101 rows) by slug match, role = authorized_dealer or distributor
- [x] Auto-populated `user_industry_links` (250 rows) mirroring `brand_industry_links`
- [x] Auto-populated `user_equipment_links` (606 rows) mirroring `brand_equipment_links`
- [x] Seeded `supply_chain_links` (47 rows): known vendor→distributor relationships across Bearings, Belts & Drives, Motors & Drives, PLCs & Control Systems, Pneumatics & Hydraulics, Lubricants & MRO categories

## Completed — 2026-06-25 (Session 22)
- [x] Designed user/supply-chain relationship model (end_user, distributor, vendor)
- [x] Applied migration `add_users_and_supply_chain_tables`
- [x] `auth_user_id` column pre-placed (nullable) for non-breaking Phase 2 auth wiring
- [x] Synced `schema/indB2B_schema.sql` and `docs/SCHEMA.md` with 5 new tables

## Completed — 2026-06-25 (Session 21)
- [x] Created `zip_distance_queue` table
- [x] Deployed `get-distance` Edge Function v1
- [x] Updated `zip_distances` source CHECK to include `nominatim`

## Completed — 2026-06-25 (Sessions 1–20)
- [x] Full schema, all seed data, brand/category/industry/equipment/links, views, RLS, shipping architecture

## Next Steps (Phase 2)

| Priority | Task |
|----------|------|
| ⬜ High | Sync `schema/indB2B_schema.sql` and `docs/SCHEMA.md` with v_supply_chain_graph DDL |
| ⬜ Medium | Add `user_id` FK to `shipping_nodes` and `supplier_zip_codes` |
| ⬜ Medium | Monitor `zip_distance_queue` for failed geocodes; resolve manually |
| ⬜ Low | Phase 2 auth wiring: add FK constraint `auth_user_id → auth.users(id)` + RLS write policies |
| ⬜ Low | RFQ functionality (scope TBD) |

## Open Questions
- Is RFQ functionality in scope for Phase 2?
- What are the known destination zip codes (warehouses/distributors)?

## AppSheet Reference
[AppSheet app](https://www.appsheet.com/start/226daf34-cd2d-4d03-b9cd-9b0dd7ea3fe8) — reference library for supplier zip codes only.

## Key File Locations

| File | Purpose |
|------|---------|
| `schema/indB2B_schema.sql` | Full DDL — ⚠️ needs sync |
| `data/brands_seed.sql` | Cumulative seed data — ✅ complete |
| `data/branch-shelf.csv` | Physical warehouse shelf catalog — ✅ committed |
| `data/Package-Shipping-Reference-Supplier-Zip-Codes-2.csv` | Supplier zip codes source reference — ✅ committed |
| `docs/SCHEMA.md` | Human-readable schema reference — ⚠️ needs sync |
| `docs/DATA_CATALOG.md` | Brand/category index with status — ✅ in sync |
