# Perplexity Space Instructions — IndB2B Dev

Copy the block below into the Perplexity Space system prompt.
Keep this file updated when project identity or schema changes.

---

```
# Industrial Maintenance B2B — Agent Instructions

## Project Identity
- Repo: https://github.com/andredavisme/industrial-maintenance-b2b
- Supabase Project: Web App Development Course - Supabase/Netlify
- Supabase Project ID: nmemmfblpzrkwyljpmvp (us-east-2)
- Schema name: indB2B (always quoted in SQL: "indB2B")
- Owner: andredavisme (André Davis, 207 Analytix)

## Session Initialization (run at the START of every session)
1. Fetch and read:
   https://raw.githubusercontent.com/andredavisme/industrial-maintenance-b2b/main/docs/SESSION_HANDOFF.md
   — This is the authoritative current state. Do not proceed without reading it.
2. Query Supabase project nmemmfblpzrkwyljpmvp:
   SELECT table_name FROM information_schema.tables WHERE table_schema = 'indB2B' ORDER BY table_name;
   — Confirm live schema matches docs/SCHEMA.md before any DB work.
3. Query the last 5 agent sessions for recent history:
   SELECT agent, summary, status, started_at, closed_at
   FROM "indB2B".sessions
   ORDER BY started_at DESC
   LIMIT 5;

## Session Closeout (run after ANY completed or attempted task)
1. Insert a row into "indB2B".sessions:
   INSERT INTO "indB2B".sessions (agent, summary, status, closed_at)
   VALUES ('[agent name]', '[what was done or attempted]', '[completed|attempted|abandoned]', now());
2. Update docs/SESSION_HANDOFF.md in the repo:
   - Move completed items to a dated Completed section
   - Add newly discovered next steps
   - Note failed attempts and why
3. Commit with message: docs: session handoff update YYYY-MM-DD
4. If schema changed: update schema/indB2B_schema.sql and docs/SCHEMA.md
5. If brands/categories changed: update data/brands_seed.sql and docs/DATA_CATALOG.md

## Commit Message Convention
- init:   scaffolding
- schema: DDL changes
- data:   seed/data changes
- docs:   documentation updates
- feat:   new features
- fix:    bug fixes

## Key File Locations
| File | Purpose |
|------|---------|
| schema/indB2B_schema.sql   | Source of truth for DDL |
| data/brands_seed.sql       | Cumulative seed data |
| docs/SCHEMA.md             | Human-readable schema reference |
| docs/DATA_CATALOG.md       | Brand/category index with status |
| docs/SESSION_HANDOFF.md    | Current state + next steps |
| docs/DEV_GUIDE.md          | Setup instructions |
| docs/SPACE_INSTRUCTIONS.md | This file — Space prompt source |

## Schema Quick Reference
Tables in "indB2B":
- brand_categories  (id, name, slug, description, is_active, created_at, updated_at)
- industries        (id, name, slug, description, is_active, created_at, updated_at)
- brands            (id, name, slug, category_id→brand_categories, parent_brand_id→brands, website, notes, is_active, created_at, updated_at)
- brand_aliases     (id, brand_id→brands, alias, notes, created_at)
- equipment_types   (id, name, slug, category_id→brand_categories, description, is_active, created_at, updated_at)
- brand_industry_links   (brand_id, industry_id) — M:M
- brand_equipment_links  (brand_id, equipment_type_id) — M:M
- sessions          (id, started_at, closed_at, agent, summary, status, created_at, updated_at)

All tables: uuid PKs via gen_random_uuid(), updated_at auto-trigger.

## SQL Rules
- Always use "indB2B".tablename or SET search_path TO "indB2B", public
- DDL changes → apply_migration only (never raw SQL for schema changes)
- Seed/data changes → execute_sql, then mirror in data/brands_seed.sql
```
