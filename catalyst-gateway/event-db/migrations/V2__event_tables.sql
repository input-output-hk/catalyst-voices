-- Catalyst Event Database

CREATE TABLE event_type (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description_schema UUID NOT NULL,
    data_schema UUID NOT NULL,

    FOREIGN KEY (description_schema) REFERENCES json_schema_type (id) ON DELETE CASCADE,
    FOREIGN KEY (data_schema) REFERENCES json_schema_type (id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX event_type_name_idx ON event_type (name);

COMMENT ON TABLE event_type IS
'The types of event which have been defined.';

COMMENT ON COLUMN event_type.id IS
'Synthetic Unique ID for each event_type (UUIDv4).';
COMMENT ON COLUMN event_type.name IS
'The name of the event type.
eg. "Catalyst V1"';
COMMENT ON COLUMN event_type.description_schema IS
'The JSON Schema which defines the structure of the data in the `description` field in the event record.';
COMMENT ON COLUMN event_type.data_schema IS
'The JSON Schema which defines the structure of the data in the `extra_data` field in the event record.';

-- TODO: Would be better to read the schemas, extract the ID, and add or update new schemas.
-- Run as required after migrations.

-- Add Event Schemas to the known schema types.
INSERT INTO json_schema_type_names (id)
VALUES
('event_description'), -- Event Description schemas
('event_data');        -- Event Data Schemas

-- Add the Initial Schemas for events.
INSERT INTO json_schema_type (id, type, name, schema)
VALUES
(
    'd899cd44-3513-487b-ab46-fdca662a724d', -- From the schema file.
    'event_description',
    'multiline_text',
    (SELECT jsonb FROM pg_read_file('../json_schemas/event/description/multiline_text.json'))
),
(
    '9c5df318-fa9a-4310-80fa-490f46d1cc43', -- From the schema file.
    'event_data',
    'catalyst_v1',
    (SELECT jsonb FROM pg_read_file('../json_schemas/event/description/catalyst_v1.json'))
);


-- Event Table - Defines each voting or decision event
CREATE TABLE "event" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type UUID REFERENCES event_type (id),
    name TEXT NOT NULL,
    description JSONB NOT NULL,
    start_time TIMESTAMP,
    backing_start TIMESTAMP,
    backing_end TIMESTAMP,
    end_time TIMESTAMP,
    data JSONB NOT NULL
);

CREATE UNIQUE INDEX event_name_idx ON event (name);

COMMENT ON TABLE event IS
'The basic parameters of a related set of funding campaigns.';

COMMENT ON COLUMN event.id IS
'Synthetic Unique ID for each event (UUIDv4).';

COMMENT ON COLUMN event.name IS
'The name of the event.
eg. "Fund9" or "SVE1"';

COMMENT ON COLUMN event.type IS
'The type of the event.';

COMMENT ON COLUMN event.description IS
'A detailed description of the purpose of the event.
Must conform to the JSON Schema defined by `event_type.description_schema.`';
COMMENT ON COLUMN event.start_time IS
'The time (UTC) the event starts.
NULL = Not yet defined.';
COMMENT ON COLUMN event.backing_start IS
'The time (UTC) when backers may start backing the campaigns in the event.
This must >= event.start_time.
NULL = Not yet defined.';
COMMENT ON COLUMN event.backing_end IS
'The time (UTC) when backers may no longer back the campaigns in the event.
This must > event.backing_start and <= event.end_time.
NULL = Not yet defined.';
COMMENT ON COLUMN event.end_time IS
'The time (UTC) the event ends.
Must be >= event.backing_end.
NULL = Not yet defined.';
COMMENT ON COLUMN event.data IS
'Event Type specific data defined about the event.
Must conform to the JSON Schema defined by `event_type.extra_data_schema.`';
