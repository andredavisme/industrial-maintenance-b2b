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
