-- Catalyst Voices Database - Campaign Information
-- sqlfluff:dialect:postgres

-- Title : Campaign Data

-- Campaign Tables

-- -------------------------------------------------------------------------------------------------

-- Campaign defintion.
CREATE TABLE IF NOT EXISTS campaign (
  id UUID NOT NULL PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
  brand_id UUID NOT NULL,
  name TEXT NOT NULL UNIQUE,

  CONSTRAINT fk_brand FOREIGN KEY (brand_id) REFERENCES brand (id) ON DELETE CASCADE
);

COMMENT ON TABLE campaign IS
'Defintion of a Campaign.';

COMMENT ON COLUMN campaign.id IS
'Synthetic Unique ID for the campaign (UUIDv4).';
COMMENT ON COLUMN campaign.name IS
'The UNIQUE name for the campaign.';
