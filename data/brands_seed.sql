-- ============================================================
-- indB2B Cumulative Brand Seed Data
-- Last updated: 2026-06-29 (101 brands, 13 categories, 5 industries, 5 aliases, 59 supplier zip codes, 215 user_brand_links)
-- Run after schema/indB2B_schema.sql
-- ============================================================

SET search_path TO "indB2B", public;

-- ---- brand_categories -------------------------------------------
INSERT INTO "indB2B".brand_categories (name, slug, description) VALUES
  ('Bearings',                    'bearings',                  'Ball, roller, sleeve, and specialty bearings'),
  ('Belts & Drives',              'belts-drives',              'V-belts, timing belts, chains, couplings, and power transmission'),
  ('Conveyors & Material Handling','conveyors-material-handling','Conveyor systems, rollers, hoists, and lifting equipment'),
  ('Fasteners & Hardware',        'fasteners-hardware',        'Bolts, nuts, anchors, and general hardware/MRO distributors'),
  ('Heavy Equipment',             'heavy-equipment',           'Construction, mining, and aggregate machinery'),
  ('HVAC & Facilities',           'hvac-facilities',           'Heating, ventilation, air conditioning, and facilities management'),
  ('Lubricants & MRO',            'lubricants-mro',            'Industrial lubricants, greases, maintenance chemicals, and MRO consumables'),
  ('Motors & Drives',             'motors-drives',             'Electric motors, VFDs, servo drives, and gearboxes'),
  ('PLCs & Control Systems',      'plcs-control-systems',      'Programmable logic controllers, HMIs, and industrial automation controls'),
  ('Pneumatics & Hydraulics',     'pneumatics-hydraulics',     'Pneumatic and hydraulic components, cylinders, valves, and hoses'),
  ('Robotics & Automation',       'robotics-automation',       'Industrial robots, automation systems, and motion control'),
  ('Safety Equipment',            'safety-equipment',          'Personal protective equipment, safety systems, and compliance products'),
  ('Sensing & Instrumentation',   'sensing-instrumentation',   'Sensors, transmitters, analyzers, and process instrumentation')
ON CONFLICT (slug) DO NOTHING;

-- ---- industries -------------------------------------------------
INSERT INTO "indB2B".industries (name, slug, description) VALUES
  ('General Industrial / Plant Maintenance', 'general-industrial-plant-maintenance', 'Broad industrial and plant maintenance applications'),
  ('Mining & Aggregate',                     'mining-aggregate',                     'Mining, quarrying, and aggregate processing'),
  ('Food & Beverage Processing',             'food-beverage-processing',             'Food and beverage manufacturing and processing'),
  ('Automotive Manufacturing',               'automotive-manufacturing',             'Automotive OEM and tier supplier manufacturing'),
  ('HVAC & Facilities',                      'hvac-facilities',                      'Commercial and industrial HVAC and facilities maintenance')
ON CONFLICT (slug) DO NOTHING;

-- ---- brands -----------------------------------------------------
INSERT INTO "indB2B".brands (name, slug, category_id, website, notes) VALUES
  -- Bearings
  ('SKF',                        'skf',                        (SELECT id FROM "indB2B".brand_categories WHERE slug='bearings'),                   'https://www.skf.com',                      'Swedish multinational, world leader in bearings and seals'),
  ('Timken',                     'timken',                     (SELECT id FROM "indB2B".brand_categories WHERE slug='bearings'),                   'https://www.timken.com',                   'US-based, known for tapered roller bearings and steel'),
  ('NSK',                        'nsk',                        (SELECT id FROM "indB2B".brand_categories WHERE slug='bearings'),                   'https://www.nskamericas.com',              'Japanese bearing manufacturer, strong in precision bearings'),
  ('NTN',                        'ntn',                        (SELECT id FROM "indB2B".brand_categories WHERE slug='bearings'),                   'https://www.ntnamericas.com',              'Japanese manufacturer, wide range of bearing types'),
  ('FAG',                        'fag',                        (SELECT id FROM "indB2B".brand_categories WHERE slug='bearings'),                   'https://www.schaeffler.com',               'Schaeffler brand; broad bearing portfolio'),
  ('INA',                        'ina',                        (SELECT id FROM "indB2B".brand_categories WHERE slug='bearings'),                   'https://www.schaeffler.com',               'Schaeffler brand; needle and specialty bearings'),
  ('Schaeffler',                 'schaeffler',                 (SELECT id FROM "indB2B".brand_categories WHERE slug='bearings'),                   NULL,                                       NULL),
  ('AMI Bearings',               'ami-bearings',               (SELECT id FROM "indB2B".brand_categories WHERE slug='bearings'),                   NULL,                                       NULL),
  ('Bunting Bearings',           'bunting-bearings',           (SELECT id FROM "indB2B".brand_categories WHERE slug='bearings'),                   NULL,                                       NULL),
  ('Consolidated Bearings',      'consolidated-bearings',      (SELECT id FROM "indB2B".brand_categories WHERE slug='bearings'),                   NULL,                                       NULL),
  ('Pacific International Bearing','pacific-international-bearing',(SELECT id FROM "indB2B".brand_categories WHERE slug='bearings'),              NULL,                                       NULL),
  ('Peer Chain',                 'peer-chain',                 (SELECT id FROM "indB2B".brand_categories WHERE slug='bearings'),                   NULL,                                       NULL),
  ('RBC',                        'rbc',                        (SELECT id FROM "indB2B".brand_categories WHERE slug='bearings'),                   NULL,                                       NULL),
  ('Royal Bearing',              'royal-bearing',              (SELECT id FROM "indB2B".brand_categories WHERE slug='bearings'),                   NULL,                                       NULL),
  ('Simatec',                    'simatec',                    (SELECT id FROM "indB2B".brand_categories WHERE slug='bearings'),                   NULL,                                       NULL),
  -- Belts & Drives
  ('Gates',                      'gates',                      (SELECT id FROM "indB2B".brand_categories WHERE slug='belts-drives'),              'https://www.gates.com',                    'Leading manufacturer of belts, hoses, and fluid power products'),
  ('ContiTech',                  'contitech',                  (SELECT id FROM "indB2B".brand_categories WHERE slug='belts-drives'),              'https://www.continental-industry.com',     'Continental brand; industrial belts and conveyor solutions'),
  ('Dayco',                      'dayco',                      (SELECT id FROM "indB2B".brand_categories WHERE slug='belts-drives'),              'https://www.dayco.com',                    'V-belts, timing belts, and tensioners'),
  ('Dodge',                      'dodge-pt',                   (SELECT id FROM "indB2B".brand_categories WHERE slug='belts-drives'),              'https://www.regalrexnord.com',             'Regal Rexnord brand; bearings, couplings, and PT components'),
  ('Browning',                   'browning',                   (SELECT id FROM "indB2B".brand_categories WHERE slug='belts-drives'),              'https://www.regalrexnord.com',             'Regal Rexnord brand; sheaves, sprockets, and V-belts'),
  ('Fenner',                     'fenner',                     (SELECT id FROM "indB2B".brand_categories WHERE slug='belts-drives'),              'https://www.fennerdrives.com',             'Specialty belts and drives, part of Michelin Group'),
  ('Tsubaki',                    'tsubaki',                    (SELECT id FROM "indB2B".brand_categories WHERE slug='belts-drives'),              NULL,                                       NULL),
  ('Ammega / Megadyne / Jason',  'ammega-megadyne-jason',      (SELECT id FROM "indB2B".brand_categories WHERE slug='belts-drives'),              NULL,                                       NULL),
  ('Magnaloy',                   'magnaloy',                   (SELECT id FROM "indB2B".brand_categories WHERE slug='belts-drives'),              NULL,                                       NULL),
  ('Martin',                     'martin',                     (SELECT id FROM "indB2B".brand_categories WHERE slug='belts-drives'),              NULL,                                       NULL),
  ('Martin Vibration Systems',   'martin-vibration-systems',   (SELECT id FROM "indB2B".brand_categories WHERE slug='belts-drives'),              NULL,                                       NULL),
  ('Palmer Johnson Power Systems','palmer-johnson-power-systems',(SELECT id FROM "indB2B".brand_categories WHERE slug='belts-drives'),            NULL,                                       NULL),
  -- Conveyors & Material Handling
  ('A Stucki',                   'a-stucki',                   (SELECT id FROM "indB2B".brand_categories WHERE slug='conveyors-material-handling'), NULL,                                      NULL),
  ('Anfield',                    'anfield',                    (SELECT id FROM "indB2B".brand_categories WHERE slug='conveyors-material-handling'), NULL,                                      NULL),
  ('Tractel Solutions',          'tractel-solutions',          (SELECT id FROM "indB2B".brand_categories WHERE slug='conveyors-material-handling'), NULL,                                      NULL),
  -- Fasteners & Hardware
  ('FilterMart',                 'filtermart',                 (SELECT id FROM "indB2B".brand_categories WHERE slug='fasteners-hardware'),         NULL,                                       NULL),
  ('Harwal',                     'harwal',                     (SELECT id FROM "indB2B".brand_categories WHERE slug='fasteners-hardware'),         NULL,                                       NULL),
  ('Newark',                     'newark',                     (SELECT id FROM "indB2B".brand_categories WHERE slug='fasteners-hardware'),         NULL,                                       NULL),
  ('TCI Supply',                 'tci-supply',                 (SELECT id FROM "indB2B".brand_categories WHERE slug='fasteners-hardware'),         NULL,                                       NULL),
  ('Zoro',                       'zoro',                       (SELECT id FROM "indB2B".brand_categories WHERE slug='fasteners-hardware'),         NULL,                                       NULL),
  -- Heavy Equipment
  ('Bobcat',                     'bobcat',                     (SELECT id FROM "indB2B".brand_categories WHERE slug='heavy-equipment'),            NULL,                                       NULL),
  ('Case',                       'case',                       (SELECT id FROM "indB2B".brand_categories WHERE slug='heavy-equipment'),            NULL,                                       NULL),
  ('Caterpillar',                'caterpillar',                (SELECT id FROM "indB2B".brand_categories WHERE slug='heavy-equipment'),            NULL,                                       NULL),
  ('Hitachi',                    'hitachi',                    (SELECT id FROM "indB2B".brand_categories WHERE slug='heavy-equipment'),            NULL,                                       NULL),
  ('John Deere',                 'john-deere',                 (SELECT id FROM "indB2B".brand_categories WHERE slug='heavy-equipment'),            NULL,                                       NULL),
  ('Kolberg',                    'kolberg',                    (SELECT id FROM "indB2B".brand_categories WHERE slug='heavy-equipment'),            NULL,                                       NULL),
  ('Komatsu',                    'komatsu',                    (SELECT id FROM "indB2B".brand_categories WHERE slug='heavy-equipment'),            NULL,                                       NULL),
  ('Metso',                      'metso',                      (SELECT id FROM "indB2B".brand_categories WHERE slug='heavy-equipment'),            NULL,                                       NULL),
  ('Off Road',                   'off-road',                   (SELECT id FROM "indB2B".brand_categories WHERE slug='heavy-equipment'),            NULL,                                       NULL),
  ('Takeuchi',                   'takeuchi',                   (SELECT id FROM "indB2B".brand_categories WHERE slug='heavy-equipment'),            NULL,                                       NULL),
  ('Terex',                      'terex',                      (SELECT id FROM "indB2B".brand_categories WHERE slug='heavy-equipment'),            NULL,                                       NULL),
  ('Volvo CE',                   'volvo-ce',                   (SELECT id FROM "indB2B".brand_categories WHERE slug='heavy-equipment'),            NULL,                                       NULL),
  -- HVAC & Facilities
  ('Air Incorporated',           'air-incorporated',           (SELECT id FROM "indB2B".brand_categories WHERE slug='hvac-facilities'),           NULL,                                       NULL),
  ('FW Webb',                    'fw-webb',                    (SELECT id FROM "indB2B".brand_categories WHERE slug='hvac-facilities'),           NULL,                                       NULL),
  ('Take 5',                     'take-5',                     (SELECT id FROM "indB2B".brand_categories WHERE slug='hvac-facilities'),           NULL,                                       NULL),
  -- Lubricants & MRO
  ('Mobil',                      'mobil',                      (SELECT id FROM "indB2B".brand_categories WHERE slug='lubricants-mro'),            'https://www.mobil.com',                    'ExxonMobil brand; industrial lubricants, greases, and hydraulic fluids'),
  ('Shell Lubricants',           'shell-lubricants',           (SELECT id FROM "indB2B".brand_categories WHERE slug='lubricants-mro'),            'https://www.shell.com/lubricants',         'Shell industrial and food-grade lubricants'),
  ('Permatex',                   'permatex',                   (SELECT id FROM "indB2B".brand_categories WHERE slug='lubricants-mro'),            'https://www.permatex.com',                 'Thread sealants, gasket makers, and maintenance chemicals'),
  ('CRC Industries',             'crc-industries',             (SELECT id FROM "indB2B".brand_categories WHERE slug='lubricants-mro'),            'https://www.crcindustries.com',            'Maintenance sprays, degreasers, and electrical cleaners'),
  ('WD-40',                      'wd-40',                      (SELECT id FROM "indB2B".brand_categories WHERE slug='lubricants-mro'),            'https://www.wd40.com',                     'Penetrating oil, lubricant sprays, and MRO consumables'),
  ('Donaldson',                  'donaldson',                  (SELECT id FROM "indB2B".brand_categories WHERE slug='lubricants-mro'),            NULL,                                       NULL),
  ('Climax',                     'climax',                     (SELECT id FROM "indB2B".brand_categories WHERE slug='lubricants-mro'),            NULL,                                       NULL),
  ('Hamilton',                   'hamilton',                   (SELECT id FROM "indB2B".brand_categories WHERE slug='lubricants-mro'),            NULL,                                       NULL),
  ('Jet',                        'jet',                        (SELECT id FROM "indB2B".brand_categories WHERE slug='lubricants-mro'),            NULL,                                       NULL),
  ('Koehler',                    'koehler',                    (SELECT id FROM "indB2B".brand_categories WHERE slug='lubricants-mro'),            NULL,                                       NULL),
  ('M.J. Dunn',                  'mj-dunn',                    (SELECT id FROM "indB2B".brand_categories WHERE slug='lubricants-mro'),            NULL,                                       NULL),
  ('Mesco Corporation',          'mesco-corporation',          (SELECT id FROM "indB2B".brand_categories WHERE slug='lubricants-mro'),            NULL,                                       NULL),
  ('RAS',                        'ras',                        (SELECT id FROM "indB2B".brand_categories WHERE slug='lubricants-mro'),            NULL,                                       NULL),
  ('Solve',                      'solve',                      (SELECT id FROM "indB2B".brand_categories WHERE slug='lubricants-mro'),            NULL,                                       NULL),
  ('Superior Industries',        'superior-industries',        (SELECT id FROM "indB2B".brand_categories WHERE slug='lubricants-mro'),            NULL,                                       NULL),
  ('Zerk (Generic)',             'zerk-generic',               (SELECT id FROM "indB2B".brand_categories WHERE slug='lubricants-mro'),            NULL,                                       'Generic/unbranded zerk grease fittings used in warehouse catalog'),
  -- Motors & Drives
  ('Baldor',                     'baldor',                     (SELECT id FROM "indB2B".brand_categories WHERE slug='motors-drives'),            NULL,                                       NULL),
  ('Bodine',                     'bodine',                     (SELECT id FROM "indB2B".brand_categories WHERE slug='motors-drives'),            NULL,                                       NULL),
  ('Leeson',                     'leeson',                     (SELECT id FROM "indB2B".brand_categories WHERE slug='motors-drives'),            NULL,                                       NULL),
  ('Lenze',                      'lenze',                      (SELECT id FROM "indB2B".brand_categories WHERE slug='motors-drives'),            NULL,                                       NULL),
  ('Nidec',                      'nidec',                      (SELECT id FROM "indB2B".brand_categories WHERE slug='motors-drives'),            NULL,                                       NULL),
  ('PEMS (Precision Electric Motor Sales)','pems',             (SELECT id FROM "indB2B".brand_categories WHERE slug='motors-drives'),            NULL,                                       NULL),
  ('Regal-Beloit',               'regal-beloit',               (SELECT id FROM "indB2B".brand_categories WHERE slug='motors-drives'),            NULL,                                       NULL),
  ('Toshiba',                    'toshiba',                    (SELECT id FROM "indB2B".brand_categories WHERE slug='motors-drives'),            NULL,                                       NULL),
  ('WEG',                        'weg',                        (SELECT id FROM "indB2B".brand_categories WHERE slug='motors-drives'),            NULL,                                       NULL),
  -- PLCs & Control Systems
  ('ABB',                        'abb',                        (SELECT id FROM "indB2B".brand_categories WHERE slug='plcs-control-systems'),     NULL,                                       NULL),
  ('Allen-Bradley',              'allen-bradley',              (SELECT id FROM "indB2B".brand_categories WHERE slug='plcs-control-systems'),     NULL,                                       NULL),
  ('Eaton',                      'eaton',                      (SELECT id FROM "indB2B".brand_categories WHERE slug='plcs-control-systems'),     NULL,                                       NULL),
  ('Omron',                      'omron',                      (SELECT id FROM "indB2B".brand_categories WHERE slug='plcs-control-systems'),     NULL,                                       NULL),
  ('Schneider Electric',         'schneider-electric',         (SELECT id FROM "indB2B".brand_categories WHERE slug='plcs-control-systems'),     NULL,                                       NULL),
  ('Siemens',                    'siemens',                    (SELECT id FROM "indB2B".brand_categories WHERE slug='plcs-control-systems'),     NULL,                                       NULL),
  -- Pneumatics & Hydraulics
  ('Flodraulic Group',           'flodraulic-group',           (SELECT id FROM "indB2B".brand_categories WHERE slug='pneumatics-hydraulics'),    NULL,                                       NULL),
  ('Graco',                      'graco',                      (SELECT id FROM "indB2B".brand_categories WHERE slug='pneumatics-hydraulics'),    NULL,                                       NULL),
  ('Hydraulic Technologies',     'hydraulic-technologies',     (SELECT id FROM "indB2B".brand_categories WHERE slug='pneumatics-hydraulics'),    NULL,                                       NULL),
  ('phd solution',               'phd-solution',               (SELECT id FROM "indB2B".brand_categories WHERE slug='pneumatics-hydraulics'),    NULL,                                       NULL),
  ('Power Brushes',              'power-brushes',              (SELECT id FROM "indB2B".brand_categories WHERE slug='pneumatics-hydraulics'),    NULL,                                       NULL),
  -- Robotics & Automation
  ('Fanuc',                      'fanuc',                      (SELECT id FROM "indB2B".brand_categories WHERE slug='robotics-automation'),      NULL,                                       NULL),
  ('KUKA',                       'kuka',                       (SELECT id FROM "indB2B".brand_categories WHERE slug='robotics-automation'),      NULL,                                       NULL),
  ('Star Automation',            'star-automation',            (SELECT id FROM "indB2B".brand_categories WHERE slug='robotics-automation'),      NULL,                                       NULL),
  ('Yaskawa Motoman',            'yaskawa-motoman',            (SELECT id FROM "indB2B".brand_categories WHERE slug='robotics-automation'),      NULL,                                       NULL),
  -- Safety Equipment
  ('Alpine',                     'alpine',                     (SELECT id FROM "indB2B".brand_categories WHERE slug='safety-equipment'),         NULL,                                       NULL),
  -- Sensing & Instrumentation
  ('APG',                        'apg',                        (SELECT id FROM "indB2B".brand_categories WHERE slug='sensing-instrumentation'),  NULL,                                       NULL),
  ('Banner Engineering',         'banner-engineering',         (SELECT id FROM "indB2B".brand_categories WHERE slug='sensing-instrumentation'),  NULL,                                       NULL),
  ('Emerson / Rosemount',        'emerson-rosemount',          (SELECT id FROM "indB2B".brand_categories WHERE slug='sensing-instrumentation'),  NULL,                                       NULL),
  ('Endress+Hauser',             'endress-hauser',             (SELECT id FROM "indB2B".brand_categories WHERE slug='sensing-instrumentation'),  NULL,                                       NULL),
  ('Keyence',                    'keyence',                    (SELECT id FROM "indB2B".brand_categories WHERE slug='sensing-instrumentation'),  NULL,                                       NULL),
  ('RS',                         'rs',                         (SELECT id FROM "indB2B".brand_categories WHERE slug='sensing-instrumentation'),  NULL,                                       NULL),
  ('SAE',                        'sae',                        (SELECT id FROM "indB2B".brand_categories WHERE slug='sensing-instrumentation'),  NULL,                                       NULL),
  ('Santa Clara Systems',        'santa-clara-systems',        (SELECT id FROM "indB2B".brand_categories WHERE slug='sensing-instrumentation'),  NULL,                                       NULL),
  ('Swan Analytical',            'swan-analytical',            (SELECT id FROM "indB2B".brand_categories WHERE slug='sensing-instrumentation'),  NULL,                                       NULL),
  ('VEGA',                       'vega',                       (SELECT id FROM "indB2B".brand_categories WHERE slug='sensing-instrumentation'),  NULL,                                       NULL)
ON CONFLICT (slug) DO NOTHING;

-- ---- brand_aliases ----------------------------------------------
INSERT INTO "indB2B".brand_aliases (brand_id, alias, notes) VALUES
  ((SELECT id FROM "indB2B".brands WHERE slug='allen-bradley'), 'Rockwell Automation', 'Parent company'),
  ((SELECT id FROM "indB2B".brands WHERE slug='fag'),           'FAG Bearings',        'Common trade reference'),
  ((SELECT id FROM "indB2B".brands WHERE slug='ina'),           'INA Bearings',        'Common trade reference'),
  ((SELECT id FROM "indB2B".brands WHERE slug='yaskawa-motoman'),'Yaskawa',            'Parent company name'),
  ((SELECT id FROM "indB2B".brands WHERE slug='emerson-rosemount'),'Rosemount',        'Instrument division brand')
ON CONFLICT DO NOTHING;

-- ---- supplier zip codes (shipping_nodes node_type=supplier) -----
-- Inserted via shipping_nodes table; supplier_zip_codes is a view.
INSERT INTO "indB2B".shipping_nodes (node_type, brand_id, name, zip_code, is_primary) VALUES
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='ras'),                        'RAS',                          '01007', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='ami-bearings'),               'AMI Bearings',                 '01507', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='lenze'),                      'Lenze',                        '01569', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='alpine'),                     'Alpine',                       '01862', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='air-incorporated'),           'Air Incorporated',             '02038', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='mesco-corporation'),          'Mesco Corporation',            '02871', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='fw-webb'),                    'FW Webb',                      '02920', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='harwal'),                     'Harwal',                       '05641', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='ammega-megadyne-jason'),      'Ammega / Megadyne / Jason',    '07006', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='consolidated-bearings'),      'Consolidated Bearings',        '07927', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='weg'),                        'WEG',                          '17072', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='fenner'),                     'Fenner',                       '17543', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='tci-supply'),                 'TCI Supply',                   '19026', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='simatec'),                    'Simatec',                      '28273', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='rbc'),                        'RBC',                          '29010', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='eaton'),                      'Eaton',                        '29334', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='newark'),                     'Newark',                       '29341', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='sae'),                        'SAE',                          '29526', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='martin'),                     'Martin',                       '30079', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='anfield'),                    'Anfield',                      '30265', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='toshiba'),                    'Toshiba',                      '30340', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='jet'),                        'Jet',                          '37086', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='filtermart'),                 'FilterMart',                   '38503', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='schaeffler'),                 'Schaeffler',                   '38555', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='timken'),                     'Timken',                       '38555', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='skf'),                        'SKF',                          '38555', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='dodge-pt'),                   'Dodge',                        '38555', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='regal-beloit'),               'Regal-Beloit',                 '41042', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='bunting-bearings'),           'Bunting Bearings',             '43528', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='power-brushes'),              'Power Brushes',                '43617', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='climax'),                     'Climax',                       '44060', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='koehler'),                    'Koehler',                      '44131', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='hamilton'),                   'Hamilton',                     '45011', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='flodraulic-group'),           'Flodraulic Group',             '46140', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='phd-solution'),               'phd solution',                 '46899', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='donaldson'),                  'Donaldson',                    '47978', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='martin-vibration-systems'),   'Martin Vibration Systems',     '48039', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='magnaloy'),                   'Magnaloy',                     '49707', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='off-road'),                   'Off Road',                     '51247', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='bodine'),                     'Bodine',                       '52068', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='palmer-johnson-power-systems'),'Palmer Johnson Power Systems', '53590', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='mj-dunn'),                    'M.J. Dunn',                    '55060', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='solve'),                      'Solve',                        '55317', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='graco'),                      'Graco',                        '55327', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='superior-industries'),        'Superior Industries',          '56267', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='peer-chain'),                 'Peer Chain',                   '60085', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='tsubaki'),                    'Tsubaki',                      '60090', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='keyence'),                    'Keyence',                      '60143', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='a-stucki'),                   'A Stucki',                     '60439', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='pems'),                       'PEMS',                         '60532', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='zoro'),                       'Zoro',                         '60661', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='hydraulic-technologies'),     'Hydraulic Technologies',       '61109', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='rs'),                         'RS',                           '76118', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='tractel-solutions'),          'Tractel Solutions',            '77040', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='apg'),                        'APG',                          '77067', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='take-5'),                     'Take 5',                       '93901', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='santa-clara-systems'),        'Santa Clara Systems',          '94502', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='pacific-international-bearing'),'Pacific International Bearing','94587', true),
  ('supplier',(SELECT id FROM "indB2B".brands WHERE slug='royal-bearing'),              'Royal Bearing',                '97230', true)
ON CONFLICT DO NOTHING;

-- ---- carriers ---------------------------------------------------
INSERT INTO "indB2B".carriers (name, scac_code, website, is_active, notes) VALUES
  ('UPS',                       'UPSN', 'https://www.ups.com',           true,  'Parcel carrier'),
  ('FedEx',                     'FDXG', 'https://www.fedex.com',         true,  'Parcel carrier'),
  ('USPS',                      'USPS', 'https://www.usps.com',          true,  'Parcel / postal carrier'),
  ('SAIA LTL Freight',          'SAIA', 'https://www.saia.com',          true,  'LTL regional/national'),
  ('XPO Logistics',             'XPOL', 'https://www.xpo.com',           true,  'LTL national'),
  ('Old Dominion Freight Line', 'ODFL', 'https://www.odfl.com',          true,  'LTL national'),
  ('Estes Express Lines',       'EXLA', 'https://www.estes-express.com', true,  'LTL regional/national'),
  ('R+L Carriers',              'RLCA', 'https://www.rlcarriers.com',    true,  'LTL regional/national'),
  ('AAA Cooper Transportation', 'AACT', 'https://www.aaacooper.com',     true,  'LTL Southeast/regional'),
  ('Forward Air',               'FWDA', 'https://www.forwardair.com',    true,  'LTL / expedited freight'),
  ('FedEx Freight',             'FXFE', 'https://www.fedex.com/freight', true,  'LTL/heavy freight; formerly Watkins Motor Lines'),
  ('TForce Freight',            'UPGF', 'https://www.tforcefreight.com', true,  'LTL/heavy freight; formerly UPS Freight'),
  ('C.H. Robinson',             NULL,   'https://www.chrobinson.com',    true,  '3PL broker; non-asset, no SCAC'),
  ('Ross Express',              'ROSX', NULL,                            false, 'New England regional LTL; ceased operations late 1990s')
ON CONFLICT DO NOTHING;

-- ---- user_brand_links (215 rows — synced 2026-06-29) ------------
-- Vendors (78): self-link as authorized_dealer
-- Distributors (23): self-link + carried brands as distributor
INSERT INTO "indB2B".user_brand_links (user_id, brand_id, role)
SELECT u.id, b.id, v.role
FROM (VALUES
  -- a-stucki (vendor)
  ('a-stucki','a-stucki','authorized_dealer'),
  -- abb (vendor)
  ('abb','abb','authorized_dealer'),
  -- air-incorporated (distributor)
  ('air-incorporated','air-incorporated','distributor'),
  ('air-incorporated','fw-webb','distributor'),
  ('air-incorporated','graco','distributor'),
  ('air-incorporated','take-5','distributor'),
  -- allen-bradley (vendor)
  ('allen-bradley','allen-bradley','authorized_dealer'),
  -- alpine (vendor)
  ('alpine','alpine','authorized_dealer'),
  -- ami-bearings (vendor)
  ('ami-bearings','ami-bearings','authorized_dealer'),
  -- ammega-megadyne-jason (vendor)
  ('ammega-megadyne-jason','ammega-megadyne-jason','authorized_dealer'),
  -- anfield (distributor)
  ('anfield','a-stucki','distributor'),
  ('anfield','ammega-megadyne-jason','distributor'),
  ('anfield','anfield','distributor'),
  ('anfield','gates','distributor'),
  ('anfield','skf','distributor'),
  -- apg (vendor)
  ('apg','apg','authorized_dealer'),
  -- baldor (vendor)
  ('baldor','baldor','authorized_dealer'),
  -- banner-engineering (vendor)
  ('banner-engineering','banner-engineering','authorized_dealer'),
  -- bobcat (vendor)
  ('bobcat','bobcat','authorized_dealer'),
  -- bodine (vendor)
  ('bodine','bodine','authorized_dealer'),
  -- browning (vendor)
  ('browning','browning','authorized_dealer'),
  -- bunting-bearings (vendor)
  ('bunting-bearings','bunting-bearings','authorized_dealer'),
  -- case (vendor)
  ('case','case','authorized_dealer'),
  -- caterpillar (vendor)
  ('caterpillar','caterpillar','authorized_dealer'),
  -- climax (vendor)
  ('climax','climax','authorized_dealer'),
  -- consolidated-bearings (distributor)
  ('consolidated-bearings','ami-bearings','distributor'),
  ('consolidated-bearings','bunting-bearings','distributor'),
  ('consolidated-bearings','consolidated-bearings','distributor'),
  ('consolidated-bearings','fag','distributor'),
  ('consolidated-bearings','ina','distributor'),
  ('consolidated-bearings','nsk','distributor'),
  ('consolidated-bearings','ntn','distributor'),
  ('consolidated-bearings','rbc','distributor'),
  ('consolidated-bearings','schaeffler','distributor'),
  ('consolidated-bearings','skf','distributor'),
  ('consolidated-bearings','timken','distributor'),
  -- contitech (vendor)
  ('contitech','contitech','authorized_dealer'),
  -- crc-industries (vendor)
  ('crc-industries','crc-industries','authorized_dealer'),
  -- dayco (vendor)
  ('dayco','dayco','authorized_dealer'),
  -- dodge-pt (vendor)
  ('dodge-pt','dodge-pt','authorized_dealer'),
  -- donaldson (vendor)
  ('donaldson','donaldson','authorized_dealer'),
  -- eaton (vendor)
  ('eaton','eaton','authorized_dealer'),
  -- emerson-rosemount (vendor)
  ('emerson-rosemount','emerson-rosemount','authorized_dealer'),
  -- endress-hauser (vendor)
  ('endress-hauser','endress-hauser','authorized_dealer'),
  -- fag (vendor)
  ('fag','fag','authorized_dealer'),
  -- fanuc (vendor)
  ('fanuc','fanuc','authorized_dealer'),
  -- fenner (vendor)
  ('fenner','fenner','authorized_dealer'),
  -- filtermart (distributor)
  ('filtermart','donaldson','distributor'),
  ('filtermart','filtermart','distributor'),
  ('filtermart','shell-lubricants','distributor'),
  ('filtermart','take-5','distributor'),
  -- flodraulic-group (distributor)
  ('flodraulic-group','flodraulic-group','distributor'),
  ('flodraulic-group','gates','distributor'),
  ('flodraulic-group','graco','distributor'),
  ('flodraulic-group','hydraulic-technologies','distributor'),
  ('flodraulic-group','power-brushes','distributor'),
  -- fw-webb (distributor)
  ('fw-webb','air-incorporated','distributor'),
  ('fw-webb','filtermart','distributor'),
  ('fw-webb','fw-webb','distributor'),
  ('fw-webb','permatex','distributor'),
  ('fw-webb','take-5','distributor'),
  -- gates (vendor)
  ('gates','gates','authorized_dealer'),
  -- graco (vendor)
  ('graco','graco','authorized_dealer'),
  -- hamilton (vendor)
  ('hamilton','hamilton','authorized_dealer'),
  -- harwal (distributor)
  ('harwal','filtermart','distributor'),
  ('harwal','harwal','distributor'),
  ('harwal','tci-supply','distributor'),
  ('harwal','wd-40','distributor'),
  ('harwal','zoro','distributor'),
  -- hitachi (vendor)
  ('hitachi','hitachi','authorized_dealer'),
  -- hydraulic-technologies (distributor)
  ('hydraulic-technologies','flodraulic-group','distributor'),
  ('hydraulic-technologies','graco','distributor'),
  ('hydraulic-technologies','hydraulic-technologies','distributor'),
  ('hydraulic-technologies','phd-solution','distributor'),
  -- ina (vendor)
  ('ina','ina','authorized_dealer'),
  -- jet (vendor)
  ('jet','jet','authorized_dealer'),
  -- john-deere (vendor)
  ('john-deere','john-deere','authorized_dealer'),
  -- keyence (vendor)
  ('keyence','keyence','authorized_dealer'),
  -- koehler (vendor)
  ('koehler','koehler','authorized_dealer'),
  -- kolberg (vendor)
  ('kolberg','kolberg','authorized_dealer'),
  -- komatsu (vendor)
  ('komatsu','komatsu','authorized_dealer'),
  -- kuka (vendor)
  ('kuka','kuka','authorized_dealer'),
  -- leeson (vendor)
  ('leeson','leeson','authorized_dealer'),
  -- lenze (vendor)
  ('lenze','lenze','authorized_dealer'),
  -- magnaloy (vendor)
  ('magnaloy','magnaloy','authorized_dealer'),
  -- martin (vendor)
  ('martin','martin','authorized_dealer'),
  -- martin-vibration-systems (vendor)
  ('martin-vibration-systems','martin-vibration-systems','authorized_dealer'),
  -- mesco-corporation (distributor)
  ('mesco-corporation','crc-industries','distributor'),
  ('mesco-corporation','donaldson','distributor'),
  ('mesco-corporation','mesco-corporation','distributor'),
  ('mesco-corporation','mobil','distributor'),
  ('mesco-corporation','permatex','distributor'),
  ('mesco-corporation','shell-lubricants','distributor'),
  ('mesco-corporation','wd-40','distributor'),
  -- metso (vendor)
  ('metso','metso','authorized_dealer'),
  -- mj-dunn (distributor)
  ('mj-dunn','crc-industries','distributor'),
  ('mj-dunn','mj-dunn','distributor'),
  ('mj-dunn','mobil','distributor'),
  ('mj-dunn','permatex','distributor'),
  ('mj-dunn','shell-lubricants','distributor'),
  ('mj-dunn','wd-40','distributor'),
  -- mobil (vendor)
  ('mobil','mobil','authorized_dealer'),
  -- newark (distributor)
  ('newark','abb','distributor'),
  ('newark','allen-bradley','distributor'),
  ('newark','apg','distributor'),
  ('newark','banner-engineering','distributor'),
  ('newark','eaton','distributor'),
  ('newark','newark','distributor'),
  ('newark','omron','distributor'),
  ('newark','schneider-electric','distributor'),
  -- nidec (vendor)
  ('nidec','nidec','authorized_dealer'),
  -- nsk (vendor)
  ('nsk','nsk','authorized_dealer'),
  -- ntn (vendor)
  ('ntn','ntn','authorized_dealer'),
  -- off-road (vendor)
  ('off-road','off-road','authorized_dealer'),
  -- omron (vendor)
  ('omron','omron','authorized_dealer'),
  -- pacific-international-bearing (distributor)
  ('pacific-international-bearing','ami-bearings','distributor'),
  ('pacific-international-bearing','browning','distributor'),
  ('pacific-international-bearing','bunting-bearings','distributor'),
  ('pacific-international-bearing','dodge-pt','distributor'),
  ('pacific-international-bearing','gates','distributor'),
  ('pacific-international-bearing','nsk','distributor'),
  ('pacific-international-bearing','pacific-international-bearing','distributor'),
  ('pacific-international-bearing','skf','distributor'),
  ('pacific-international-bearing','timken','distributor'),
  -- palmer-johnson-power-systems (distributor)
  ('palmer-johnson-power-systems','ammega-megadyne-jason','distributor'),
  ('palmer-johnson-power-systems','browning','distributor'),
  ('palmer-johnson-power-systems','dayco','distributor'),
  ('palmer-johnson-power-systems','dodge-pt','distributor'),
  ('palmer-johnson-power-systems','gates','distributor'),
  ('palmer-johnson-power-systems','magnaloy','distributor'),
  ('palmer-johnson-power-systems','palmer-johnson-power-systems','distributor'),
  ('palmer-johnson-power-systems','tsubaki','distributor'),
  -- peer-chain (vendor)
  ('peer-chain','peer-chain','authorized_dealer'),
  -- pems (distributor)
  ('pems','baldor','distributor'),
  ('pems','bodine','distributor'),
  ('pems','leeson','distributor'),
  ('pems','lenze','distributor'),
  ('pems','pems','distributor'),
  ('pems','regal-beloit','distributor'),
  ('pems','toshiba','distributor'),
  ('pems','weg','distributor'),
  -- permatex (vendor)
  ('permatex','permatex','authorized_dealer'),
  -- phd-solution (vendor)
  ('phd-solution','phd-solution','authorized_dealer'),
  -- power-brushes (vendor)
  ('power-brushes','power-brushes','authorized_dealer'),
  -- ras (distributor)
  ('ras','mobil','distributor'),
  ('ras','ras','distributor'),
  ('ras','shell-lubricants','distributor'),
  ('ras','wd-40','distributor'),
  -- rbc (vendor)
  ('rbc','rbc','authorized_dealer'),
  -- regal-beloit (vendor)
  ('regal-beloit','regal-beloit','authorized_dealer'),
  -- royal-bearing (distributor)
  ('royal-bearing','ami-bearings','distributor'),
  ('royal-bearing','fag','distributor'),
  ('royal-bearing','nsk','distributor'),
  ('royal-bearing','ntn','distributor'),
  ('royal-bearing','royal-bearing','distributor'),
  ('royal-bearing','skf','distributor'),
  ('royal-bearing','timken','distributor'),
  -- rs (distributor)
  ('rs','abb','distributor'),
  ('rs','banner-engineering','distributor'),
  ('rs','emerson-rosemount','distributor'),
  ('rs','endress-hauser','distributor'),
  ('rs','keyence','distributor'),
  ('rs','rs','distributor'),
  -- sae (vendor)
  ('sae','sae','authorized_dealer'),
  -- santa-clara-systems (distributor)
  ('santa-clara-systems','allen-bradley','distributor'),
  ('santa-clara-systems','banner-engineering','distributor'),
  ('santa-clara-systems','omron','distributor'),
  ('santa-clara-systems','santa-clara-systems','distributor'),
  ('santa-clara-systems','schneider-electric','distributor'),
  -- schaeffler (vendor)
  ('schaeffler','schaeffler','authorized_dealer'),
  -- schneider-electric (vendor)
  ('schneider-electric','schneider-electric','authorized_dealer'),
  -- shell-lubricants (vendor)
  ('shell-lubricants','shell-lubricants','authorized_dealer'),
  -- siemens (vendor)
  ('siemens','siemens','authorized_dealer'),
  -- simatec (vendor)
  ('simatec','simatec','authorized_dealer'),
  -- skf (vendor)
  ('skf','skf','authorized_dealer'),
  -- solve (distributor)
  ('solve','crc-industries','distributor'),
  ('solve','donaldson','distributor'),
  ('solve','mobil','distributor'),
  ('solve','solve','distributor'),
  ('solve','wd-40','distributor'),
  -- star-automation (vendor)
  ('star-automation','star-automation','authorized_dealer'),
  -- superior-industries (distributor)
  ('superior-industries','a-stucki','distributor'),
  ('superior-industries','anfield','distributor'),
  ('superior-industries','gates','distributor'),
  ('superior-industries','mesco-corporation','distributor'),
  ('superior-industries','superior-industries','distributor'),
  -- swan-analytical (vendor)
  ('swan-analytical','swan-analytical','authorized_dealer'),
  -- take-5 (distributor)
  ('take-5','air-incorporated','distributor'),
  ('take-5','donaldson','distributor'),
  ('take-5','take-5','distributor'),
  -- takeuchi (vendor)
  ('takeuchi','takeuchi','authorized_dealer'),
  -- tci-supply (distributor)
  ('tci-supply','filtermart','distributor'),
  ('tci-supply','harwal','distributor'),
  ('tci-supply','permatex','distributor'),
  ('tci-supply','tci-supply','distributor'),
  ('tci-supply','wd-40','distributor'),
  -- terex (vendor)
  ('terex','terex','authorized_dealer'),
  -- timken (vendor)
  ('timken','timken','authorized_dealer'),
  -- toshiba (vendor)
  ('toshiba','toshiba','authorized_dealer'),
  -- tractel-solutions (vendor)
  ('tractel-solutions','tractel-solutions','authorized_dealer'),
  -- tsubaki (vendor)
  ('tsubaki','tsubaki','authorized_dealer'),
  -- vega (vendor)
  ('vega','vega','authorized_dealer'),
  -- volvo-ce (vendor)
  ('volvo-ce','volvo-ce','authorized_dealer'),
  -- wd-40 (vendor)
  ('wd-40','wd-40','authorized_dealer'),
  -- weg (vendor)
  ('weg','weg','authorized_dealer'),
  -- yaskawa-motoman (vendor)
  ('yaskawa-motoman','yaskawa-motoman','authorized_dealer'),
  -- zerk-generic (vendor)
  ('zerk-generic','zerk-generic','authorized_dealer'),
  -- zoro (distributor)
  ('zoro','baldor','distributor'),
  ('zoro','filtermart','distributor'),
  ('zoro','gates','distributor'),
  ('zoro','mobil','distributor'),
  ('zoro','skf','distributor'),
  ('zoro','tci-supply','distributor'),
  ('zoro','wd-40','distributor'),
  ('zoro','zoro','distributor')
) AS v(user_slug, brand_slug, role)
JOIN "indB2B".users u ON u.slug = v.user_slug
JOIN "indB2B".brands b ON b.slug = v.brand_slug
ON CONFLICT (user_id, brand_id) DO NOTHING;
