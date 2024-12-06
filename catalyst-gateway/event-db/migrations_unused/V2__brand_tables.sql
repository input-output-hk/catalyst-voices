-- Catalyst Voices Database - Brand Information
-- sqlfluff:dialect:postgres

-- Title : Brand  Data

-- Brand Tables

-- -------------------------------------------------------------------------------------------------

-- Brand defintion.
CREATE TABLE IF NOT EXISTS brand (
  id UUID NOT NULL PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
  name TEXT NOT NULL UNIQUE
);

COMMENT ON TABLE brand IS
'Defintion of a Brand.';

COMMENT ON COLUMN brand.id IS
'Synthetic Unique ID for the brand (UUIDv4).';
COMMENT ON COLUMN brand.name IS
'The UNIQUE name for the brand.';
