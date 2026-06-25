-- ============================================================
-- indB2B Schema — Industrial Maintenance B2B Platform
-- PostgreSQL 14+  |  Supabase-compatible
-- Run this file to initialize the indB2B schema from scratch.
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

-- ---- supplier_zip_codes -----------------------------------------
CREATE TABLE IF NOT EXISTS "indB2B".supplier_zip_codes (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  brand_id   uuid NOT NULL REFERENCES "indB2B".brands(id) ON DELETE RESTRICT,
  zip_code   varchar(10) NOT NULL,
  city       varchar(100),
  state_code char(2),
  notes      text,
  is_primary boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_supplier_zip_brand_primary
  ON "indB2B".supplier_zip_codes (brand_id) WHERE is_primary = true;

CREATE INDEX IF NOT EXISTS idx_supplier_zip_codes_brand_id
  ON "indB2B".supplier_zip_codes (brand_id);

CREATE INDEX IF NOT EXISTS idx_supplier_zip_codes_zip
  ON "indB2B".supplier_zip_codes (zip_code);

CREATE TRIGGER set_updated_at_supplier_zip_codes
  BEFORE UPDATE ON "indB2B".supplier_zip_codes
  FOR EACH ROW EXECUTE FUNCTION "indB2B".set_updated_at();

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

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

-- Enable RLS on all tables
ALTER TABLE "indB2B".brand_categories       ENABLE ROW LEVEL SECURITY;
ALTER TABLE "indB2B".industries             ENABLE ROW LEVEL SECURITY;
ALTER TABLE "indB2B".brands                 ENABLE ROW LEVEL SECURITY;
ALTER TABLE "indB2B".brand_aliases          ENABLE ROW LEVEL SECURITY;
ALTER TABLE "indB2B".equipment_types        ENABLE ROW LEVEL SECURITY;
ALTER TABLE "indB2B".brand_industry_links   ENABLE ROW LEVEL SECURITY;
ALTER TABLE "indB2B".brand_equipment_links  ENABLE ROW LEVEL SECURITY;
ALTER TABLE "indB2B".supplier_zip_codes     ENABLE ROW LEVEL SECURITY;
ALTER TABLE "indB2B".sessions               ENABLE ROW LEVEL SECURITY;

-- Public read: active records only
CREATE POLICY "public_read_brand_categories"
  ON "indB2B".brand_categories FOR SELECT
  TO anon, authenticated USING (is_active = true);

CREATE POLICY "public_read_brands"
  ON "indB2B".brands FOR SELECT
  TO anon, authenticated USING (is_active = true);

CREATE POLICY "public_read_industries"
  ON "indB2B".industries FOR SELECT
  TO anon, authenticated USING (is_active = true);

CREATE POLICY "public_read_equipment_types"
  ON "indB2B".equipment_types FOR SELECT
  TO anon, authenticated USING (is_active = true);

-- Public read: all rows
CREATE POLICY "public_read_brand_aliases"
  ON "indB2B".brand_aliases FOR SELECT
  TO anon, authenticated USING (true);

CREATE POLICY "public_read_brand_equipment_links"
  ON "indB2B".brand_equipment_links FOR SELECT
  TO anon, authenticated USING (true);

CREATE POLICY "public_read_brand_industry_links"
  ON "indB2B".brand_industry_links FOR SELECT
  TO anon, authenticated USING (true);

CREATE POLICY "public_read_supplier_zip_codes"
  ON "indB2B".supplier_zip_codes FOR SELECT
  TO anon, authenticated USING (true);

-- sessions: NO public policy — service_role only (bypasses RLS by default)
