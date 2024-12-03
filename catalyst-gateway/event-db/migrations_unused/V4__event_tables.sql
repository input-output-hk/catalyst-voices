-- Catalyst Voices Database - Event Information
-- sqlfluff:dialect:postgres

-- Title : Event Data

-- Event Tables

-- -------------------------------------------------------------------------------------------------

-- Event defintion.
CREATE TABLE IF NOT EXISTS event (
  id UUID NOT NULL PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
  campaign_id UUID NOT NULL,
  name TEXT NOT NULL UNIQUE,

  CONSTRAINT fk_campaign FOREIGN KEY (campaign_id) REFERENCES campaign (id) ON DELETE CASCADE
);

COMMENT ON TABLE event IS
'Defintion of an Event.';

COMMENT ON COLUMN event.id IS
'Synthetic Unique ID for the event (UUIDv4).';
COMMENT ON COLUMN event.name IS
'The UNIQUE name for the event.';
