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
🟢 **Phase 1 — COMPLETE. User/supply-chain schema added (session 22). Ready for user directory seeding or auth wiring.**

**Tables (19):** brand_aliases, brand_categories, brand_equipment_links, brand_industry_links, brands, carriers, equipment_types, industries, sessions, shipment_legs, shipments, shipping_nodes, supply_chain_links, user_brand_links, user_equipment_links, user_industry_links, users, zip_distances, zip_distance_queue
**Views (5):** v_brands_full, v_equipment_brands, supplier_zip_codes (compat), v_shipment_cost_summary, v_shipment_legs_costed
**Edge Functions (1):** get-distance (Nominatim lazy-load cache)
**RLS:** Enabled on all 19 tables ✅

### File Status
| File | Status |
|------|--------|
| `schema/indB2B_schema.sql` | ⚠️ Needs sync (session 22 DDL not yet written) |
| `data/brands_seed.sql` | ✅ 101 brands / 13 categories / 5 industries / 5 aliases / 59 zip codes / 14 carriers |
| `data/branch-shelf.csv` | ✅ Committed |
| `data/Package-Shipping-Reference-Supplier-Zip-Codes-2.csv` | ✅ Committed |
| `docs/SCHEMA.md` | ⚠️ Needs sync (5 new tables) |
| `docs/DATA_CATALOG.md` | ✅ In sync |

### DB Counts
101 brands / 13 categories / 5 industries / 59 shipping nodes (supplier) / 64 equipment types / 606 brand-equipment links / 250 brand-industry links / 14 carriers / 0 zip_distances (populates on-demand via get-distance Edge Function) / 0 users / 0 supply_chain_links

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

## Completed — 2026-06-25 (Session 22)
- [x] Designed user/supply-chain relationship model (end_user, distributor, vendor)
- [x] Applied migration `add_users_and_supply_chain_tables`:
  - `users`, `user_brand_links`, `user_industry_links`, `user_equipment_links`, `supply_chain_links`
  - `updated_at` triggers on `users` and `supply_chain_links`
  - RLS with public read policies on all 5 new tables
- [x] `auth_user_id` column pre-placed (nullable) for non-breaking Phase 2 auth wiring

## Completed — 2026-06-25 (Session 21)
- [x] Created `zip_distance_queue` table
- [x] Deployed `get-distance` Edge Function v1
- [x] Updated `zip_distances` source CHECK to include `nominatim`

## Completed — 2026-06-25 (Sessions 1–20)
- [x] Full schema, all seed data, brand/category/industry/equipment/links, views, RLS, shipping architecture

## Next Steps (Phase 2)

| Priority | Task |
|----------|------|
| ⬜ High | Sync `schema/indB2B_schema.sql` and `docs/SCHEMA.md` with 5 new tables from session 22 |
| ⬜ High | Seed initial `users` rows (vendors + distributors from existing brands data) |
| ⬜ High | Seed `supply_chain_links` to map known vendor → distributor relationships |
| ⬜ Medium | Create `v_supply_chain_graph` view for end-user-facing network traversal |
| ⬜ Medium | Add `user_id` FK to `shipping_nodes` and `supplier_zip_codes` |
| ⬜ Medium | Monitor `zip_distance_queue` for failed geocodes; resolve manually |
| ⬜ Low | Phase 2 auth wiring: add FK constraint `auth_user_id → auth.users(id)` + RLS write policies |
| ⬜ Low | RFQ functionality (scope TBD) |

## Open Questions
- Which existing brands should be seeded as `vendor` vs `distributor` users?
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
