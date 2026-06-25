# indB2B Data Catalog

Current status of all seeded reference data.
Last updated: 2026-06-25

---

## Brand Categories (13)

| Slug | Name | Active |
|------|------|--------|
| bearings | Bearings | ✅ |
| belts-drives | Belts & Drives | ✅ |
| conveyors-material-handling | Conveyors & Material Handling | ✅ |
| fasteners-hardware | Fasteners & Hardware | ✅ |
| heavy-equipment | Heavy Equipment | ✅ |
| hvac-facilities | HVAC & Facilities | ✅ |
| lubricants-mro | Lubricants & MRO | ✅ |
| motors-drives | Motors & Drives | ✅ |
| plcs-control-systems | PLCs & Control Systems | ✅ |
| pneumatics-hydraulics | Pneumatics & Hydraulics | ✅ |
| robotics-automation | Robotics & Automation | ✅ |
| safety-equipment | Safety Equipment | ✅ |
| sensing-instrumentation | Sensing & Instrumentation | ✅ |

---

## Industries (5)

| Slug | Name |
|------|------|
| general-industrial-plant-maintenance | General Industrial / Plant Maintenance |
| mining-aggregate | Mining & Aggregate |
| food-beverage-processing | Food & Beverage Processing |
| automotive-manufacturing | Automotive Manufacturing |
| hvac-facilities | HVAC & Facilities |

---

## Brands (101)

### Bearings (15)
SKF, Timken, NSK, NTN, FAG, INA, Schaeffler, AMI Bearings, Bunting Bearings, Consolidated Bearings, Pacific International Bearing, Peer Chain, RBC, Royal Bearing, Simatec

### Belts & Drives (11)
Gates, ContiTech, Dayco, Dodge, Browning, Fenner, Tsubaki, Ammega / Megadyne / Jason, Magnaloy, Martin, Martin Vibration Systems, Palmer Johnson Power Systems

> Note: Browning and Dodge are Regal Rexnord brands. Fenner is part of Michelin Group.

### Conveyors & Material Handling (3)
A Stucki, Anfield, Tractel Solutions

### Fasteners & Hardware (5)
FilterMart, Harwal, Newark, TCI Supply, Zoro

### Heavy Equipment (12)
Bobcat, Case, Caterpillar, Hitachi, John Deere, Kolberg, Komatsu, Metso, Off Road, Takeuchi, Terex, Volvo CE

### HVAC & Facilities (3)
Air Incorporated, FW Webb, Take 5

### Lubricants & MRO (15)
Mobil, Shell Lubricants, Permatex, CRC Industries, WD-40, Donaldson, Climax, Hamilton, Jet, Koehler, M.J. Dunn, Mesco Corporation, RAS, Solve, Superior Industries, Zerk (Generic)

> Note: Mobil is an ExxonMobil brand.

### Motors & Drives (9)
Baldor, Bodine, Leeson, Lenze, Nidec, PEMS, Regal-Beloit, Toshiba, WEG

### PLCs & Control Systems (6)
ABB, Allen-Bradley, Eaton, Omron, Schneider Electric, Siemens

> Note: Allen-Bradley is a Rockwell Automation brand.

### Pneumatics & Hydraulics (5)
Flodraulic Group, Graco, Hydraulic Technologies, phd solution, Power Brushes

### Robotics & Automation (4)
Fanuc, KUKA, Star Automation, Yaskawa Motoman

### Safety Equipment (1)
Alpine

### Sensing & Instrumentation (10)
APG, Banner Engineering, Emerson / Rosemount, Endress+Hauser, Keyence, RS, SAE, Santa Clara Systems, Swan Analytical, VEGA

---

## Brand Aliases (5)

| Brand | Alias | Notes |
|-------|-------|-------|
| Allen-Bradley | Rockwell Automation | Parent company |
| FAG | FAG Bearings | Common trade reference |
| INA | INA Bearings | Common trade reference |
| Yaskawa Motoman | Yaskawa | Parent company name |
| Emerson / Rosemount | Rosemount | Instrument division brand |

---

## Supplier Zip Codes / Shipping Nodes (59 supplier nodes)

All stored in `shipping_nodes` table as `node_type = 'supplier'`.
Accessible via `supplier_zip_codes` compatibility view.

| Brand Slug | Zip Code |
|------------|----------|
| ras | 01007 |
| ami-bearings | 01507 |
| lenze | 01569 |
| alpine | 01862 |
| air-incorporated | 02038 |
| mesco-corporation | 02871 |
| fw-webb | 02920 |
| harwal | 05641 |
| ammega-megadyne-jason | 07006 |
| consolidated-bearings | 07927 |
| weg | 17072 |
| fenner | 17543 |
| tci-supply | 19026 |
| simatec | 28273 |
| rbc | 29010 |
| eaton | 29334 |
| newark | 29341 |
| sae | 29526 |
| martin | 30079 |
| anfield | 30265 |
| toshiba | 30340 |
| jet | 37086 |
| filtermart | 38503 |
| schaeffler | 38555 |
| timken | 38555 |
| skf | 38555 |
| dodge-pt | 38555 |
| regal-beloit | 41042 |
| bunting-bearings | 43528 |
| power-brushes | 43617 |
| climax | 44060 |
| koehler | 44131 |
| hamilton | 45011 |
| flodraulic-group | 46140 |
| phd-solution | 46899 |
| donaldson | 47978 |
| martin-vibration-systems | 48039 |
| magnaloy | 49707 |
| off-road | 51247 |
| bodine | 52068 |
| palmer-johnson-power-systems | 53590 |
| mj-dunn | 55060 |
| solve | 55317 |
| graco | 55327 |
| superior-industries | 56267 |
| peer-chain | 60085 |
| tsubaki | 60090 |
| keyence | 60143 |
| a-stucki | 60439 |
| pems | 60532 |
| zoro | 60661 |
| hydraulic-technologies | 61109 |
| rs | 76118 |
| tractel-solutions | 77040 |
| apg | 77067 |
| take-5 | 93901 |
| santa-clara-systems | 94502 |
| pacific-international-bearing | 94587 |
| royal-bearing | 97230 |

---

## Equipment Types (64)

64 types seeded across all 13 categories. See `indB2B.equipment_types` table or `v_equipment_brands` view for full detail.

---

## Carriers (14)

| Name | SCAC | Active | Notes |
|------|------|--------|-------|
| UPS | UPSN | ✅ | Parcel |
| FedEx | FDXG | ✅ | Parcel |
| USPS | USPS | ✅ | Parcel/postal |
| SAIA LTL Freight | SAIA | ✅ | LTL |
| XPO Logistics | XPOL | ✅ | LTL |
| Old Dominion Freight Line | ODFL | ✅ | LTL |
| Estes Express Lines | EXLA | ✅ | LTL |
| R+L Carriers | RLCA | ✅ | LTL |
| AAA Cooper Transportation | AACT | ✅ | LTL Southeast |
| Forward Air | FWDA | ✅ | LTL/expedited |
| FedEx Freight | FXFE | ✅ | LTL/heavy |
| TForce Freight | UPGF | ✅ | LTL/heavy |
| C.H. Robinson | — | ✅ | 3PL broker |
| Ross Express | ROSX | ❌ | Historical; New England LTL |

---

## Link Tables

| Table | Rows |
|-------|------|
| brand_industry_links | 250 |
| brand_equipment_links | 606 |
