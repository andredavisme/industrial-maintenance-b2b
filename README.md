# Industrial Maintenance B2B

This repository is the **canonical reference** for the Industrial Maintenance B2B platform. Any agent — human or automated — should be able to pick up development tasks using only the documents in this repo.

## Repository Structure

```
/
├── README.md                  ← You are here
├── docs/
│   ├── PROJECT_OVERVIEW.md    ← Goals, scope, and vision
│   ├── SCHEMA.md              ← indB2B database schema reference
│   ├── DATA_CATALOG.md        ← Indexed entities, brands, categories
│   ├── DEV_GUIDE.md           ← Setup and development workflow
│   └── SESSION_HANDOFF.md     ← Latest work state for continuity
├── schema/
│   └── indB2B_schema.sql      ← PostgreSQL DDL for indB2B schema
└── data/
    └── brands_seed.sql        ← Seed data: brands and categories
```

## Quick Start

1. Read `docs/PROJECT_OVERVIEW.md` for context and goals
2. Read `docs/SCHEMA.md` for the data model
3. Read `docs/SESSION_HANDOFF.md` for current work state
4. Use `schema/indB2B_schema.sql` to initialize or migrate the database

## Schema

All database objects live in the PostgreSQL schema named **`indB2B`**.

## Status

> 🟡 **In Progress** — Initial scaffolding. See `docs/SESSION_HANDOFF.md` for latest state.
