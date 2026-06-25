# Project Overview

## Mission

Build a B2B platform and data infrastructure for the **industrial maintenance** industry, enabling:

- Brand and equipment cataloging across industries
- Supplier and vendor data indexing
- RFQ (Request for Quote) workflows
- Locally-served and web-based application support

## Core Goals

| # | Goal | Notes |
|---|------|---------|
| 1 | Catalog industrial brands by category | Sourced from community input (e.g., Reddit, industry data) |
| 2 | Define a portable `indB2B` schema | PostgreSQL-first; usable in Supabase or local Postgres |
| 3 | Support agent-driven development | Docs must be self-sufficient for any developer or AI agent |
| 4 | Enable web + local app development | REST API-ready schema design |
| 5 | RFQ system integration | TBD — see future milestones |

## Industries Targeted (Initial)

- Automotive manufacturing
- Food & beverage processing
- Mining & aggregate
- General industrial / plant maintenance
- HVAC & facilities

## Applications (TBD)

- Web app: Brand/equipment search and comparison
- Local app: Offline-capable maintenance reference tool
- Admin interface: Data curation and brand management

## Key Technologies

- **Database**: PostgreSQL (`indB2B` schema), Supabase-compatible
- **Hosting**: Cloudflare Pages / GitHub Pages (TBD)
- **Backend**: Supabase Edge Functions or local REST server
- **Version Control**: GitHub (`andredavisme/industrial-maintenance-b2b`)
