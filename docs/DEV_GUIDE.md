# Developer Guide

This guide enables any developer (or agent) to set up, understand, and contribute to this project without outside assistance.

## Prerequisites

- PostgreSQL 14+ OR Supabase project
- Node.js 18+ (for any JS tooling)
- Git

## Local Setup

```bash
git clone https://github.com/andredavisme/industrial-maintenance-b2b.git
cd industrial-maintenance-b2b
```

### Database Initialization

**Option A — Local PostgreSQL:**
```bash
psql -U postgres -f schema/indB2B_schema.sql
psql -U postgres -f data/brands_seed.sql
```

**Option B — Supabase:**
1. Open the Supabase SQL editor for your project
2. Run `schema/indB2B_schema.sql`
3. Run `data/brands_seed.sql`
4. Enable RLS policies as needed per table

## Schema Namespace

All objects are in the `indB2B` schema.

To query from a connection defaulting to `public`:
```sql
SELECT * FROM "indB2B".brands;
```

Or set the search path:
```sql
SET search_path TO "indB2B", public;
```

## Branching Strategy

| Branch | Purpose |
|--------|---------|
| `main` | Stable, deployable state |
| `dev` | Active development |
| `feature/*` | Feature branches off `dev` |

## Adding Brands

1. Add to `data/brands_seed.sql` with proper category and industry links
2. Update `docs/DATA_CATALOG.md` to reflect new entries
3. Commit with message: `data: add [BrandName] to [category]`

## Agent Instructions

Any AI agent continuing work should:
1. Read `docs/SESSION_HANDOFF.md` first
2. Confirm current schema state against `schema/indB2B_schema.sql`
3. Only modify files within this repo's structure
4. Update `SESSION_HANDOFF.md` at the end of every work session
