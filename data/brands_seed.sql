-- ============================================================
-- indB2B Seed Data — Brand Categories, Industries, Brands
-- Run AFTER schema/indB2B_schema.sql
-- ============================================================

SET search_path TO "indB2B", public;

-- ---- Brand Categories ------------------------------------------
INSERT INTO brand_categories (name, slug, description) VALUES
  ('PLCs & Control Systems',        'plcs-control-systems',        'Programmable logic controllers, HMIs, and industrial control hardware'),
  ('Robotics & Automation',         'robotics-automation',         'Industrial robots, cobots, and automation systems'),
  ('Motors & Drives',               'motors-drives',               'Electric motors, variable frequency drives, and motor controls'),
  ('Sensing & Instrumentation',     'sensing-instrumentation',     'Sensors, cameras, analyzers, and process instrumentation'),
  ('Heavy Equipment',               'heavy-equipment',             'Construction, mining, and aggregate heavy machinery'),
  ('HVAC & Facilities',             'hvac-facilities',             'Heating, ventilation, air conditioning, and building systems'),
  ('Conveyors & Material Handling', 'conveyors-material-handling', 'Conveyor systems, hoists, cranes, and material handling equipment'),
  ('Pneumatics & Hydraulics',       'pneumatics-hydraulics',       'Pneumatic and hydraulic components and systems'),
  ('Safety Equipment',              'safety-equipment',            'Industrial safety systems, guards, and PPE'),
  ('Fasteners & Hardware',          'fasteners-hardware',          'Bolts, nuts, bearings, bushings, and mechanical hardware')
ON CONFLICT (slug) DO NOTHING;

-- ---- Industries ------------------------------------------------
INSERT INTO industries (name, slug) VALUES
  ('Automotive Manufacturing',              'automotive'),
  ('Food & Beverage Processing',            'food-beverage'),
  ('Mining & Aggregate',                    'mining-aggregate'),
  ('General Industrial / Plant Maintenance','general-industrial'),
  ('HVAC & Facilities',                     'hvac-facilities')
ON CONFLICT (slug) DO NOTHING;

-- ---- Brands ----------------------------------------------------
-- PLCs & Control Systems
INSERT INTO brands (name, slug, category_id)
SELECT b.name, b.slug, bc.id
FROM (VALUES
  ('Allen-Bradley',    'allen-bradley'),
  ('Siemens',          'siemens'),
  ('Omron',            'omron'),
  ('Schneider Electric','schneider-electric'),
  ('ABB',              'abb'),
  ('Eaton',            'eaton')
) AS b(name, slug)
JOIN brand_categories bc ON bc.slug = 'plcs-control-systems'
ON CONFLICT (slug) DO NOTHING;

-- Robotics & Automation
INSERT INTO brands (name, slug, category_id)
SELECT b.name, b.slug, bc.id
FROM (VALUES
  ('Fanuc',           'fanuc'),
  ('Yaskawa Motoman', 'yaskawa-motoman'),
  ('KUKA',            'kuka'),
  ('Star Automation', 'star-automation')
) AS b(name, slug)
JOIN brand_categories bc ON bc.slug = 'robotics-automation'
ON CONFLICT (slug) DO NOTHING;

-- Motors & Drives
INSERT INTO brands (name, slug, category_id)
SELECT b.name, b.slug, bc.id
FROM (VALUES
  ('Baldor',        'baldor'),
  ('Regal-Beloit',  'regal-beloit'),
  ('Leeson',        'leeson'),
  ('Nidec',         'nidec')
) AS b(name, slug)
JOIN brand_categories bc ON bc.slug = 'motors-drives'
ON CONFLICT (slug) DO NOTHING;

-- Sensing & Instrumentation
INSERT INTO brands (name, slug, category_id)
SELECT b.name, b.slug, bc.id
FROM (VALUES
  ('Keyence',             'keyence'),
  ('Endress+Hauser',      'endress-hauser'),
  ('Emerson / Rosemount', 'emerson-rosemount'),
  ('VEGA',                'vega'),
  ('Swan Analytical',     'swan-analytical'),
  ('Banner Engineering',  'banner-engineering')
) AS b(name, slug)
JOIN brand_categories bc ON bc.slug = 'sensing-instrumentation'
ON CONFLICT (slug) DO NOTHING;

-- Heavy Equipment
INSERT INTO brands (name, slug, category_id)
SELECT b.name, b.slug, bc.id
FROM (VALUES
  ('Caterpillar', 'caterpillar'),
  ('John Deere',  'john-deere'),
  ('Komatsu',     'komatsu'),
  ('Hitachi',     'hitachi'),
  ('Volvo CE',    'volvo-ce'),
  ('Case',        'case'),
  ('Bobcat',      'bobcat'),
  ('Takeuchi',    'takeuchi'),
  ('Metso',       'metso'),
  ('Kolberg',     'kolberg'),
  ('Terex',       'terex')
) AS b(name, slug)
JOIN brand_categories bc ON bc.slug = 'heavy-equipment'
ON CONFLICT (slug) DO NOTHING;

-- ---- Brand Aliases ---------------------------------------------
-- ABB also known as ASEA Brown Boveri
INSERT INTO brand_aliases (brand_id, alias, notes)
SELECT b.id, 'ASEA Brown Boveri', 'Full historical name'
FROM brands b WHERE b.slug = 'abb'
ON CONFLICT DO NOTHING;

-- Allen-Bradley parent is Rockwell Automation
INSERT INTO brand_aliases (brand_id, alias, notes)
SELECT b.id, 'Rockwell Automation', 'Parent company name'
FROM brands b WHERE b.slug = 'allen-bradley'
ON CONFLICT DO NOTHING;

-- Emerson / Rosemount
INSERT INTO brand_aliases (brand_id, alias, notes)
SELECT b.id, 'Rosemount', 'Emerson subsidiary brand'
FROM brands b WHERE b.slug = 'emerson-rosemount'
ON CONFLICT DO NOTHING;

INSERT INTO brand_aliases (brand_id, alias, notes)
SELECT b.id, 'Emerson Electric', 'Parent company name'
FROM brands b WHERE b.slug = 'emerson-rosemount'
ON CONFLICT DO NOTHING;

-- Yaskawa Motoman
INSERT INTO brand_aliases (brand_id, alias, notes)
SELECT b.id, 'Motoman', 'Common trade name'
FROM brands b WHERE b.slug = 'yaskawa-motoman'
ON CONFLICT DO NOTHING;
