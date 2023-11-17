-- Catalyst Event Database
-- sqlfluff:dialect:postgres

-- Configuration Tables

-- -------------------------------------------------------------------------------------------------

-- Version of the schema (Used by Refinery to manage migrations.).
CREATE TABLE IF NOT EXISTS refinery_schema_history (
    version INTEGER NOT NULL PRIMARY KEY,
    name VARCHAR(255),
    applied_on VARCHAR(255),
    checksum VARCHAR(255)
);

COMMENT ON TABLE refinery_schema_history IS
'History of Schema Updates to the Database.
Managed by the `refinery` cli tool.';

-- -------------------------------------------------------------------------------------------------

-- All known Json Schema Types
CREATE TABLE json_schema_type_names (
    id TEXT PRIMARY KEY
);

COMMENT ON TABLE json_schema_type_names IS 'All known Json Schema Types.';

-- Known Schema Types are inserted when the Table which uses that type is created.


-- -------------------------------------------------------------------------------------------------

-- Json Schema Library
-- Json Schemas used to validate the contents of JSONB fields in this database.
-- Catalyst Event Database
CREATE TABLE json_schema_type (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type TEXT NOT NULL,
    name TEXT NOT NULL,
    schema JSONB NOT NULL,

    FOREIGN KEY ("type") REFERENCES json_schema_type_names (id) ON DELETE CASCADE
);

CREATE INDEX json_schema_type_idx ON json_schema_type ("type");
CREATE UNIQUE INDEX json_schema_type_name_idx ON json_schema_type ("type", "name");

COMMENT ON TABLE json_schema_type IS
'Library of defined json schemas used to validate JSONB field contents.';

COMMENT ON COLUMN json_schema_type.id IS
'Synthetic Unique ID for each json_schema_type (UUIDv4).';
COMMENT ON COLUMN json_schema_type.type IS
'The type of the json schema type.
eg. "Event Description"';
COMMENT ON COLUMN json_schema_type.name IS
'The name of the json schema type.
eg. "Catalyst V1"';

-- -------------------------------------------------------------------------------------------------

-- Config Table
-- This table is looked up with three keys, `id`, `id2` and `id3`
CREATE TABLE config (
    row_id SERIAL PRIMARY KEY,
    id VARCHAR NOT NULL,
    id2 VARCHAR NOT NULL,
    id3 VARCHAR NOT NULL,
    value JSONB NULL,
    value_schema UUID,

    FOREIGN KEY (value_schema) REFERENCES json_schema_type (id) ON DELETE CASCADE
);

-- id+id2+id3 must be unique, they are a combined key.
CREATE UNIQUE INDEX config_idx ON config (id, id2, id3);

COMMENT ON TABLE config IS
'General JSON Configuration and Data Values.
Defined  Data Formats:
  Currently None
';

COMMENT ON COLUMN config.row_id IS
'Synthetic unique key. 
Always lookup using `id.id2.id3`';
COMMENT ON COLUMN config.id IS
'The name/id of the general config value/variable';
COMMENT ON COLUMN config.id2 IS
'2nd ID of the general config value. 
Must be defined, use "" if not required.';

COMMENT ON COLUMN config.id3 IS
'3rd ID of the general config value.
Must be defined, use "" if not required.';
COMMENT ON COLUMN config.value IS
'The JSON value of the system variable `id.id2.id3`';
COMMENT ON COLUMN config.value_schema IS
'The Schema the Config Value conforms to.
The `value` field must conform to this schema.';

COMMENT ON INDEX config_idx IS
'We use three keys combined uniquely rather than forcing string concatenation 
at the app level to allow for querying groups of data.';

-- Add Config Schemas to the known schema types.
INSERT INTO json_schema_type_names (id)
VALUES
('config');-- Configuration Data Schemas

-- Add the Initial Schemas for configuration.
INSERT INTO json_schema_type (id, type, name, schema)
VALUES
(
    'd899cd44-3513-487b-ab46-fdca662a724d',
    'config',
    'dbsync',
    (SELECT jsonb FROM pg_read_file('../json_schemas/config/dbsync_connection.json'))
);
