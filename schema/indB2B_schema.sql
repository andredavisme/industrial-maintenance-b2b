-- ============================================================
-- indB2B Schema — Industrial Maintenance B2B Platform
-- PostgreSQL 14+  |  Supabase-compatible
-- Run this file to initialize the indB2B schema from scratch.
-- Last synced: 2026-06-25 (sessions 1–21)
-- ============================================================

CREATE SCHEMA IF NOT EXISTS "indB2B";

-- ---- Utility: auto-update updated_at ----------------------------
CREATE OR REPLACE FUNCTION "indB2B".set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ---- brand_categories -------------------------------------------
CREATE TABLE IF NOT EXISTS "indB2B".brand_categories (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name        text UNIQUE NOT NULL,
  slug        text UNIQUE NOT NULL,
  description text,
  is_active   boolean NOT NULL DEFAULT true,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TRIGGER trg_brand_categories_updated_at
  BEFORE UPDATE ON "indB2B".brand_categories
  FOR EACH ROW EXECUTE FUNCTION "indB2B".set_updated_at();

-- ---- industries -------------------------------------------------
CREATE TABLE IF NOT EXISTS "indB2B".industries (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name        text UNIQUE NOT NULL,
  slug        text UNIQUE NOT NULL,
  description text,
  is_active   boolean NOT NULL DEFAULT true,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TRIGGER trg_industries_updated_at
  BEFORE UPDATE ON "indB2B".industries
  FOR EACH ROW EXECUTE FUNCTION "indB2B".set_updated_at();

-- ---- brands -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "indB2B".brands (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name             text UNIQUE NOT NULL,
  slug             text UNIQUE NOT NULL,
  category_id      uuid REFERENCES "indB2B".brand_categories(id) ON DELETE SET NULL,
  parent_brand_id  uuid REFERENCES "indB2B".brands(id) ON DELETE SET NULL,
  website          text,
  notes            text,
  is_active        boolean NOT NULL DEFAULT true,
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now()
);

CREATE TRIGGER trg_brands_updated_at
  BEFORE UPDATE ON "indB2B".brands
  FOR EACH ROW EXECUTE FUNCTION "indB2B".set_updated_at();

CREATE INDEX IF NOT EXISTS idx_brands_category_id ON "indB2B".brands(category_id);
CREATE INDEX IF NOT EXISTS idx_brands_slug ON "indB2B".brands(slug);

-- ---- brand_aliases ----------------------------------------------
CREATE TABLE IF NOT EXISTS "indB2B".brand_aliases (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  brand_id   uuid NOT NULL REFERENCES "indB2B".brands(id) ON DELETE CASCADE,
  alias      text NOT NULL,
  notes      text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_brand_aliases_brand_id ON "indB2B".brand_aliases(brand_id);

-- ---- equipment_types --------------------------------------------
CREATE TABLE IF NOT EXISTS "indB2B".equipment_types (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name        text UNIQUE NOT NULL,
  slug        text UNIQUE NOT NULL,
  category_id uuid REFERENCES "indB2B".brand_categories(id) ON DELETE SET NULL,
  description text,
  is_active   boolean NOT NULL DEFAULT true,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TRIGGER trg_equipment_types_updated_at
  BEFORE UPDATE ON "indB2B".equipment_types
  FOR EACH ROW EXECUTE FUNCTION "indB2B".set_updated_at();

-- ---- brand_industry_links (M:M) ---------------------------------
CREATE TABLE IF NOT EXISTS "indB2B".brand_industry_links (
  brand_id    uuid NOT NULL REFERENCES "indB2B".brands(id) ON DELETE CASCADE,
  industry_id uuid NOT NULL REFERENCES "indB2B".industries(id) ON DELETE CASCADE,
  PRIMARY KEY (brand_id, industry_id)
);

-- ---- brand_equipment_links (M:M) --------------------------------
CREATE TABLE IF NOT EXISTS "indB2B".brand_equipment_links (
  brand_id          uuid NOT NULL REFERENCES "indB2B".brands(id) ON DELETE CASCADE,
  equipment_type_id uuid NOT NULL REFERENCES "indB2B".equipment_types(id) ON DELETE CASCADE,
  PRIMARY KEY (brand_id, equipment_type_id)
);

-- ---- sessions (agent audit log) ---------------------------------
CREATE TABLE IF NOT EXISTS "indB2B".sessions (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  started_at timestamptz NOT NULL DEFAULT now(),
  closed_at  timestamptz,
  agent      text,
  summary    text,
  status     text CHECK (status IN ('completed', 'attempted', 'abandoned')),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TRIGGER trg_sessions_updated_at
  BEFORE UPDATE ON "indB2B".sessions
  FOR EACH ROW EXECUTE FUNCTION "indB2B".set_updated_at();

CREATE INDEX IF NOT EXISTS idx_sessions_started_at ON "indB2B".sessions(started_at DESC);
CREATE INDEX IF NOT EXISTS idx_sessions_status ON "indB2B".sessions(status);

-- ---- shipping_nodes ---------------------------------------------
CREATE TABLE IF NOT EXISTS "indB2B".shipping_nodes (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  node_type    text NOT NULL CHECK (node_type IN ('supplier','warehouse','distributor','customer')),
  brand_id     uuid REFERENCES "indB2B".brands(id) ON DELETE SET NULL,
  name         text NOT NULL,
  zip_code     varchar(10) NOT NULL,
  city         varchar(100),
  state_code   char(2),
  is_primary   boolean NOT NULL DEFAULT false,
  notes        text,
  created_at   timestamptz NOT NULL DEFAULT now(),
  updated_at   timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_shipping_nodes_node_type ON "indB2B".shipping_nodes(node_type);
CREATE INDEX IF NOT EXISTS idx_shipping_nodes_brand_id  ON "indB2B".shipping_nodes(brand_id);
CREATE INDEX IF NOT EXISTS idx_shipping_nodes_zip_code  ON "indB2B".shipping_nodes(zip_code);

CREATE TRIGGER set_updated_at_shipping_nodes
  BEFORE UPDATE ON "indB2B".shipping_nodes
  FOR EACH ROW EXECUTE FUNCTION "indB2B".set_updated_at();

-- ---- carriers ---------------------------------------------------
CREATE TABLE IF NOT EXISTS "indB2B".carriers (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name       text NOT NULL,
  scac_code  varchar(4),
  website    text,
  is_active  boolean NOT NULL DEFAULT true,
  notes      text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_carriers_scac ON "indB2B".carriers(scac_code) WHERE scac_code IS NOT NULL;

CREATE TRIGGER set_updated_at_carriers
  BEFORE UPDATE ON "indB2B".carriers
  FOR EACH ROW EXECUTE FUNCTION "indB2B".set_updated_at();

-- ---- shipments --------------------------------------------------
CREATE TABLE IF NOT EXISTS "indB2B".shipments (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  reference_number    text NOT NULL UNIQUE,
  origin_node_id      uuid NOT NULL REFERENCES "indB2B".shipping_nodes(id) ON DELETE RESTRICT,
  destination_node_id uuid NOT NULL REFERENCES "indB2B".shipping_nodes(id) ON DELETE RESTRICT,
  status              text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','active','completed','cancelled')),
  notes               text,
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_shipments_origin      ON "indB2B".shipments(origin_node_id);
CREATE INDEX IF NOT EXISTS idx_shipments_destination ON "indB2B".shipments(destination_node_id);
CREATE INDEX IF NOT EXISTS idx_shipments_status      ON "indB2B".shipments(status);

CREATE TRIGGER set_updated_at_shipments
  BEFORE UPDATE ON "indB2B".shipments
  FOR EACH ROW EXECUTE FUNCTION "indB2B".set_updated_at();

-- ---- shipment_legs ----------------------------------------------
CREATE TABLE IF NOT EXISTS "indB2B".shipment_legs (
  id                        uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  shipment_id               uuid NOT NULL REFERENCES "indB2B".shipments(id) ON DELETE CASCADE,
  sequence                  integer NOT NULL,
  from_node_id              uuid NOT NULL REFERENCES "indB2B".shipping_nodes(id) ON DELETE RESTRICT,
  to_node_id                uuid NOT NULL REFERENCES "indB2B".shipping_nodes(id) ON DELETE RESTRICT,
  status                    text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','in_transit','delivered','cancelled')),
  carrier_id                uuid REFERENCES "indB2B".carriers(id) ON DELETE RESTRICT,
  tracking_number           text,
  shipped_at                timestamptz,
  received_at               timestamptz,
  weight_lbs                numeric(10,5),
  est_miles                 numeric(10,5),
  est_cost_per_mile         numeric(10,5),
  est_freight_cost          numeric(10,5) GENERATED ALWAYS AS (
    CASE
      WHEN weight_lbs IS NOT NULL AND est_miles IS NOT NULL AND est_cost_per_mile IS NOT NULL
      THEN ROUND(weight_lbs * est_miles * est_cost_per_mile, 5)
      ELSE NULL
    END
  ) STORED,
  est_freight_cost_override numeric(10,5),
  created_at                timestamptz NOT NULL DEFAULT now(),
  updated_at                timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT uq_shipment_leg_sequence UNIQUE (shipment_id, sequence)
);

CREATE INDEX IF NOT EXISTS idx_shipment_legs_shipment  ON "indB2B".shipment_legs(shipment_id);
CREATE INDEX IF NOT EXISTS idx_shipment_legs_from_node ON "indB2B".shipment_legs(from_node_id);
CREATE INDEX IF NOT EXISTS idx_shipment_legs_to_node   ON "indB2B".shipment_legs(to_node_id);
CREATE INDEX IF NOT EXISTS idx_shipment_legs_carrier   ON "indB2B".shipment_legs(carrier_id);
CREATE INDEX IF NOT EXISTS idx_shipment_legs_status    ON "indB2B".shipment_legs(status);

CREATE TRIGGER set_updated_at_shipment_legs
  BEFORE UPDATE ON "indB2B".shipment_legs
  FOR EACH ROW EXECUTE FUNCTION "indB2B".set_updated_at();

-- ---- zip_distances ----------------------------------------------
CREATE TABLE IF NOT EXISTS "indB2B".zip_distances (
  zip_from   varchar(5)    NOT NULL,
  zip_to     varchar(5)    NOT NULL,
  miles      numeric(10,5) NOT NULL CHECK (miles > 0),
  source     text          NOT NULL DEFAULT 'manual' CHECK (source IN ('manual','api','estimate','nominatim')),
  notes      text,
  created_at timestamptz   NOT NULL DEFAULT now(),
  updated_at timestamptz   NOT NULL DEFAULT now(),
  PRIMARY KEY (zip_from, zip_to)
);

CREATE INDEX IF NOT EXISTS idx_zip_distances_zip_from ON "indB2B".zip_distances(zip_from);
CREATE INDEX IF NOT EXISTS idx_zip_distances_zip_to   ON "indB2B".zip_distances(zip_to);

CREATE TRIGGER set_updated_at_zip_distances
  BEFORE UPDATE ON "indB2B".zip_distances
  FOR EACH ROW EXECUTE FUNCTION "indB2B".set_updated_at();

-- ---- zip_distance_queue -----------------------------------------
-- Backlog for zip pairs that could not be auto-resolved.
-- Agent reviews pending rows and pushes resolved miles to zip_distances.
CREATE TABLE IF NOT EXISTS "indB2B".zip_distance_queue (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  zip_from   varchar(10) NOT NULL,
  zip_to     varchar(10) NOT NULL,
  status     text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','resolved','failed')),
  notes      text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE (zip_from, zip_to)
);

CREATE TRIGGER set_updated_at_zip_distance_queue
  BEFORE UPDATE ON "indB2B".zip_distance_queue
  FOR EACH ROW EXECUTE FUNCTION "indB2B".set_updated_at();

-- ============================================================
-- VIEWS
-- ============================================================

CREATE OR REPLACE VIEW "indB2B".supplier_zip_codes AS
SELECT id, brand_id, zip_code, city, state_code, is_primary, notes, created_at, updated_at
FROM "indB2B".shipping_nodes
WHERE node_type = 'supplier';

CREATE OR REPLACE VIEW "indB2B".v_brands_full AS
SELECT
  b.id, b.name, b.slug, b.website, b.notes, b.is_active,
  bc.name                        AS category,
  bc.slug                        AS category_slug,
  pb.name                        AS parent_brand,
  ARRAY_AGG(DISTINCT ba.alias)   FILTER (WHERE ba.alias IS NOT NULL)  AS aliases,
  ARRAY_AGG(DISTINCT i.name)     FILTER (WHERE i.name IS NOT NULL)    AS industries,
  ARRAY_AGG(DISTINCT et.name)    FILTER (WHERE et.name IS NOT NULL)   AS equipment_types,
  b.created_at, b.updated_at
FROM "indB2B".brands b
LEFT JOIN "indB2B".brand_categories       bc  ON bc.id  = b.category_id
LEFT JOIN "indB2B".brands                 pb  ON pb.id  = b.parent_brand_id
LEFT JOIN "indB2B".brand_aliases          ba  ON ba.brand_id = b.id
LEFT JOIN "indB2B".brand_industry_links   bil ON bil.brand_id = b.id
LEFT JOIN "indB2B".industries             i   ON i.id  = bil.industry_id
LEFT JOIN "indB2B".brand_equipment_links  bel ON bel.brand_id = b.id
LEFT JOIN "indB2B".equipment_types        et  ON et.id = bel.equipment_type_id
GROUP BY b.id, b.name, b.slug, b.website, b.notes, b.is_active,
         bc.name, bc.slug, pb.name, b.created_at, b.updated_at;

CREATE OR REPLACE VIEW "indB2B".v_equipment_brands AS
SELECT
  et.id, et.name AS equipment_type, et.slug AS equipment_slug,
  et.description, et.is_active,
  bc.name        AS category,
  bc.slug        AS category_slug,
  ARRAY_AGG(DISTINCT b.name ORDER BY b.name) FILTER (WHERE b.name IS NOT NULL) AS brands,
  COUNT(DISTINCT b.id) AS brand_count
FROM "indB2B".equipment_types et
LEFT JOIN "indB2B".brand_categories      bc  ON bc.id = et.category_id
LEFT JOIN "indB2B".brand_equipment_links bel ON bel.equipment_type_id = et.id
LEFT JOIN "indB2B".brands               b   ON b.id = bel.brand_id AND b.is_active = true
GROUP BY et.id, et.name, et.slug, et.description, et.is_active, bc.name, bc.slug;

CREATE OR REPLACE VIEW "indB2B".v_shipment_cost_summary AS
SELECT
  s.id                                                                        AS shipment_id,
  s.reference_number,
  s.status,
  COUNT(sl.id)                                                                AS leg_count,
  SUM(COALESCE(sl.est_freight_cost_override, sl.est_freight_cost))           AS total_est_freight_cost,
  SUM(sl.weight_lbs)                                                          AS total_weight_lbs,
  SUM(sl.est_miles)                                                           AS total_est_miles
FROM "indB2B".shipments s
LEFT JOIN "indB2B".shipment_legs sl ON sl.shipment_id = s.id
GROUP BY s.id, s.reference_number, s.status;

CREATE OR REPLACE VIEW "indB2B".v_shipment_legs_costed AS
SELECT
  sl.id,
  sl.shipment_id,
  sl.sequence,
  sl.status,
  sl.carrier_id,
  sl.tracking_number,
  sl.shipped_at,
  sl.received_at,
  fn.zip_code                                      AS from_zip,
  tn.zip_code                                      AS to_zip,
  sl.weight_lbs,
  sl.est_cost_per_mile,
  sl.est_miles,
  sl.est_freight_cost,
  sl.est_freight_cost_override,
  COALESCE(zd_fwd.miles, zd_rev.miles)             AS looked_up_miles,
  COALESCE(sl.est_miles, zd_fwd.miles, zd_rev.miles) AS effective_miles,
  COALESCE(
    sl.est_freight_cost_override,
    sl.est_freight_cost,
    CASE
      WHEN sl.weight_lbs IS NOT NULL
       AND sl.est_cost_per_mile IS NOT NULL
       AND COALESCE(zd_fwd.miles, zd_rev.miles) IS NOT NULL
      THEN ROUND(sl.weight_lbs * COALESCE(zd_fwd.miles, zd_rev.miles) * sl.est_cost_per_mile, 5)
      ELSE NULL
    END
  )                                                AS effective_freight_cost,
  sl.created_at,
  sl.updated_at
FROM "indB2B".shipment_legs sl
JOIN  "indB2B".shipping_nodes fn ON fn.id = sl.from_node_id
JOIN  "indB2B".shipping_nodes tn ON tn.id = sl.to_node_id
LEFT JOIN "indB2B".zip_distances zd_fwd
  ON zd_fwd.zip_from = LEFT(fn.zip_code, 5) AND zd_fwd.zip_to = LEFT(tn.zip_code, 5)
LEFT JOIN "indB2B".zip_distances zd_rev
  ON zd_rev.zip_from = LEFT(tn.zip_code, 5) AND zd_rev.zip_to = LEFT(fn.zip_code, 5);

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

ALTER TABLE "indB2B".brand_categories      ENABLE ROW LEVEL SECURITY;
ALTER TABLE "indB2B".industries            ENABLE ROW LEVEL SECURITY;
ALTER TABLE "indB2B".brands                ENABLE ROW LEVEL SECURITY;
ALTER TABLE "indB2B".brand_aliases         ENABLE ROW LEVEL SECURITY;
ALTER TABLE "indB2B".equipment_types       ENABLE ROW LEVEL SECURITY;
ALTER TABLE "indB2B".brand_industry_links  ENABLE ROW LEVEL SECURITY;
ALTER TABLE "indB2B".brand_equipment_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE "indB2B".sessions              ENABLE ROW LEVEL SECURITY;
ALTER TABLE "indB2B".shipping_nodes        ENABLE ROW LEVEL SECURITY;
ALTER TABLE "indB2B".carriers              ENABLE ROW LEVEL SECURITY;
ALTER TABLE "indB2B".shipments             ENABLE ROW LEVEL SECURITY;
ALTER TABLE "indB2B".shipment_legs         ENABLE ROW LEVEL SECURITY;
ALTER TABLE "indB2B".zip_distances         ENABLE ROW LEVEL SECURITY;
ALTER TABLE "indB2B".zip_distance_queue    ENABLE ROW LEVEL SECURITY;

CREATE POLICY "public_read_brand_categories"  ON "indB2B".brand_categories  FOR SELECT TO anon, authenticated USING (is_active = true);
CREATE POLICY "public_read_brands"            ON "indB2B".brands            FOR SELECT TO anon, authenticated USING (is_active = true);
CREATE POLICY "public_read_industries"        ON "indB2B".industries        FOR SELECT TO anon, authenticated USING (is_active = true);
CREATE POLICY "public_read_equipment_types"   ON "indB2B".equipment_types   FOR SELECT TO anon, authenticated USING (is_active = true);
CREATE POLICY "public_read_carriers"          ON "indB2B".carriers          FOR SELECT TO anon, authenticated USING (is_active = true);

CREATE POLICY "public_read_brand_aliases"          ON "indB2B".brand_aliases          FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "public_read_brand_equipment_links"  ON "indB2B".brand_equipment_links  FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "public_read_brand_industry_links"   ON "indB2B".brand_industry_links   FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "public read shipping_nodes"         ON "indB2B".shipping_nodes         FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "public read shipments"              ON "indB2B".shipments              FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "public read shipment_legs"          ON "indB2B".shipment_legs          FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "public read zip_distances"          ON "indB2B".zip_distances          FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "public read zip_distance_queue"     ON "indB2B".zip_distance_queue     FOR SELECT TO anon, authenticated USING (true);
-- sessions: NO public policy — service_role only
