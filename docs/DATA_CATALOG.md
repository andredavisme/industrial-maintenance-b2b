# Data Catalog

This document tracks entities, their source, and indexing status.

## Brand Categories

| Slug | Name | Status | Notes |
|------|------|--------|-------|
| plcs-control-systems | PLCs & Control Systems | 🟡 Seeding | 6 brands seeded |
| robotics-automation | Robotics & Automation | 🟡 Seeding | 4 brands seeded |
| motors-drives | Motors & Drives | 🟡 Seeding | 4 brands seeded |
| sensing-instrumentation | Sensing & Instrumentation | 🟡 Seeding | 6 brands seeded |
| heavy-equipment | Heavy Equipment | 🟡 Seeding | 11 brands seeded |
| hvac-facilities | HVAC & Facilities | ⬜ Planned | No brands yet |
| conveyors-material-handling | Conveyors & Material Handling | ⬜ Planned | No brands yet |
| pneumatics-hydraulics | Pneumatics & Hydraulics | ⬜ Planned | No brands yet |
| safety-equipment | Safety Equipment | ⬜ Planned | No brands yet |
| fasteners-hardware | Fasteners & Hardware | ⬜ Planned | No brands yet |
| bearings | Bearings | 🔴 Missing | #1 warehouse category — needs to be added |
| belts-drives | Belts & Drives | 🔴 Missing | #3 warehouse category — needs to be added |
| lubricants-mro | Lubricants & MRO | 🔴 Missing | Grease, Lubricant, Grease Zerks present in warehouse |

## Brands (Initial Seed — from r/IndustrialMaintenance)

### PLCs & Control Systems
- Allen-Bradley (Rockwell Automation)
- Siemens
- Omron
- Schneider Electric
- ABB
- Eaton

### Robotics & Automation
- Fanuc
- Motoman (Yaskawa)
- Kuka
- Star Automation
- ABB Robotics

### Motors & Drives
- ABB / Baldor
- Siemens
- Regal-Beloit
- Leeson
- Nidec

### Sensing & Instrumentation
- Keyence
- Endress+Hauser
- Emerson / Rosemount
- Vega
- Swan Analytical
- Banner Engineering

### Heavy Equipment
- Caterpillar (Cat)
- John Deere
- Komatsu
- Hitachi
- Volvo CE
- Case
- Bobcat
- Takeuchi
- Metso
- Kolberg
- Terex

### Bearings (🔴 Category not yet in DB)
_Suggested brands to seed: SKF, NSK, Timken, Dodge (Baldor/ABB), Rexnord, NTN, Peer_

### Belts & Drives (🔴 Category not yet in DB)
_Suggested brands to seed: Gates, Dayco, Browning (Rexnord), Jason, Bando, Fenner_

### Lubricants & MRO (🔴 Category not yet in DB)
_Suggested brands to seed: Shell Lubricants, Mobil, Castrol, LPS, WD-40 Industrial_

## Industries (Initial)

| Slug | Name |
|------|------|
| automotive | Automotive Manufacturing |
| food-beverage | Food & Beverage Processing |
| mining-aggregate | Mining & Aggregate |
| general-industrial | General Industrial / Plant Maintenance |
| hvac-facilities | HVAC & Facilities |

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
