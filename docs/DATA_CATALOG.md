# Data Catalog

This document tracks entities, their source, and indexing status.

## Brand Categories

| Slug | Name | Status | Notes |
|------|------|--------|-------|
| bearings | Bearings | ✅ Complete | 15 brands, 9 equipment types, links seeded |
| belts-drives | Belts & Drives | ✅ Complete | 12 brands, 7 equipment types, links seeded |
| conveyors-material-handling | Conveyors & Material Handling | ✅ Complete | 3 brands, 4 equipment types, links seeded |
| fasteners-hardware | Fasteners & Hardware | ✅ Complete | 5 brands, 5 equipment types, links seeded |
| heavy-equipment | Heavy Equipment | ✅ Complete | 11 brands, 3 equipment types, links seeded |
| hvac-facilities | HVAC & Facilities | ✅ Complete | 3 brands, 3 equipment types, links seeded |
| lubricants-mro | Lubricants & MRO | ✅ Complete | 14 brands, 5 equipment types, links seeded |
| motors-drives | Motors & Drives | ✅ Complete | 9 brands, 5 equipment types, links seeded |
| plcs-control-systems | PLCs & Control Systems | ✅ Complete | 6 brands, 5 equipment types, links seeded |
| pneumatics-hydraulics | Pneumatics & Hydraulics | ✅ Complete | 5 brands, 6 equipment types, links seeded |
| robotics-automation | Robotics & Automation | ✅ Complete | 4 brands, 3 equipment types, links seeded |
| safety-equipment | Safety Equipment | ✅ Complete | 1 brand, 3 equipment types, links seeded |
| sensing-instrumentation | Sensing & Instrumentation | ✅ Complete | 9 brands, 6 equipment types, links seeded |

## Link Tables

| Table | Rows | Status |
|-------|------|--------|
| `brand_equipment_links` | 606 | ✅ Seeded |
| `brand_industry_links` | 250 | ✅ Seeded |

## Industries

| Slug | Name | Brand Count |
|------|------|-------------|
| general-industrial | General Industrial / Plant Maintenance | 101 (all brands) |
| mining-aggregate | Mining & Aggregate | ~23 |
| automotive | Automotive Manufacturing | ~12 |
| food-beverage | Food & Beverage Processing | ~12 |
| hvac-facilities | HVAC & Facilities | ~9 |

## Warehouse Inventory Source (branch-shelf.csv)

Physical shelf catalog captured 2026-06-25. Shelf count used as volume proxy.

| Category (mapped) | Shelf Count | Top Product Types |
|---|---|---|
| Bearings | 27 | Pillow Block (10), Roller (9), Flanged (5) |
| Fasteners & Hardware | 13 | Bushings (3), Split Taper Bushings (2) |
| Belts & Drives | 11 | Multiple belt cross-sections, sheaves, pulleys |
| Conveyors & Material Handling | 8 | Couplings, Chain, Sprockets |
| Pneumatics & Hydraulics | 7 | Seals (4), O-Rings, Tubing |
| Motors & Drives | 4 | Motors (2), VFDs, Compact Drives |
| Lubricants & MRO | 3 | Grease, Lubricant, Grease Zerks |
| PLCs & Control Systems | 2 | PLC Components, Contacts |
| Tools & Accessories | 1 | Power Wrenches |

## Data Sources

| Source | Type | Date Accessed | Notes |
|--------|------|---------------|-------|
| r/IndustrialMaintenance – brands thread | Community | 2026-06-25 | Initial brand seed list |
| branch-shelf.csv | Physical Inventory | 2026-06-25 | Shelf-by-shelf warehouse catalog, volume proxy analysis |
