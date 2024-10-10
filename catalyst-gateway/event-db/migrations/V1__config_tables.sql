-- Catalyst Voices Database - Configuration Data
-- sqlfluff:dialect:postgres

-- Title : Configuration Data

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

-- Json Schema Library
-- Json Schemas used to validate the contents of JSONB fields in this database.
-- * `id,type,name` matches the $id URI in the schema itself.
-- * The URI format is customized and is of the form `catalyst_schema://<id>/<type>/<name>`
-- * Schemas will be added here automatically during migration of the database, or interactively
-- * during operation of the system.
-- * They should match the schema they hold, and on read they should be validated.
-- * The code should refuse to serve or use any schema that does not match.
-- *
-- * id - This is unique and can uniquely identify any schema.
-- * type - This allows us to find all schemas of a known type.
-- * name - This is the unique name of the schema. `id` always equals the same `type/name`.
-- * for convention `type` and `name` string should only used a-z,0-9 and underscore. 
-- * Dashes, symbols or upper case should not be used.
-- Catalyst Event Database
CREATE TABLE json_schema_type (
  id UUID PRIMARY KEY,
  type TEXT NOT NULL,
  name TEXT NOT NULL,
  schema JSONB NOT NULL
);

CREATE INDEX json_schema_type_idx ON json_schema_type ("type");
CREATE UNIQUE INDEX json_schema_type_name_idx ON json_schema_type (
  "type", "name"
);

COMMENT ON TABLE json_schema_type IS
'Library of defined json schemas used to validate JSONB field contents.';

COMMENT ON COLUMN json_schema_type.id IS
'Synthetic Unique ID for each json_schema_type (UUIDv4).
Must match the `UUID` component of the $id URI inside the schema.';
COMMENT ON COLUMN json_schema_type.type IS
'The type of the json schema type.
eg. "event"
Must match the `type` component of the $id URI inside the schema.';
COMMENT ON COLUMN json_schema_type.name IS
'The name of the json schema type.
eg. "catalyst_v1"
Must match the `name` component of the $id URI inside the schema.';

-- Known Schema Types are inserted when the Table which uses that type is created.
-- Or can be added by migrations as the database evolves.
-- They could also be added outside of the schema setup by inserting directly into the database.

-- -------------------------------------------------------------------------------------------------

-- Config Table
-- This table is looked up with three keys, `id1`, `id2` and `id3`
CREATE TABLE config (
  row_id SERIAL PRIMARY KEY,
  id1 VARCHAR NOT NULL,
  id2 VARCHAR NOT NULL,
  id3 VARCHAR NOT NULL,
  value JSONB NULL,
  value_schema UUID,

  FOREIGN KEY (value_schema) REFERENCES json_schema_type (id) ON DELETE CASCADE
);

-- cardano+follower+preview must be unique, they are a combined key.
CREATE UNIQUE INDEX config_idx ON config (id1, id2, id3);

COMMENT ON TABLE config IS
'General JSON Configuration and Data Values.
Defined  Data Formats:
  Currently None
';

COMMENT ON COLUMN config.row_id IS
'Synthetic unique key. 
Always lookup using `cardano.follower.preview`';
COMMENT ON COLUMN config.id1 IS
'The primary ID of the config.';
COMMENT ON COLUMN config.id2 IS
'The secondary ID of the config.
Must be defined, use "" if not required.';
COMMENT ON COLUMN config.id3 IS
'The tertiary ID of the config.
Must be defined, use "" if not required.';
COMMENT ON COLUMN config.value IS
'The configuration value in JSON format.';
COMMENT ON COLUMN config.value_schema IS
'The Schema the Config Value conforms to.
The `value` field must conform to this schema.';

COMMENT ON INDEX config_idx IS
'We use three keys combined uniquely rather than forcing string concatenation 
at the app level to allow for querying groups of data.';

-- -------------------------------------------------------------------------------------------------

-- * Temporary.  
-- * Insert known json schema manually until automated json schema migration scripting is added.
-- * This will be removed in the future.

-- Add the Initial Schemas for configuration.
--INSERT INTO json_schema_type (id, type, name, schema)
--VALUES
--(
--  'd899cd44-3513-487b-ab46-fdca662a724d', -- Fix the Schema ID so that it is consistent.
--  'config',
--  'dbsync',
--  (SELECT PG_READ_FILE('../json_schemas/config/dbsync.json'))::JSONB), (
--  '62d614c0-97a7-41ec-a976-91294b8f4384', -- Fix the Schema ID so that it is consistent.
--  'config',
--  'registration',
--  (SELECT PG_READ_FILE('../json_schemas/config/registration.json'))::JSONB
--);
