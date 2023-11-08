-- Catalyst Event Database
-- Version of the schema.
CREATE TABLE IF NOT EXISTS
  refinery_schema_history (
    VERSION INTEGER NOT NULL PRIMARY KEY,
    NAME VARCHAR(255),
    applied_on VARCHAR(255),
    checksum VARCHAR(255)
  );

COMMENT ON TABLE refinery_schema_history IS 'History of Schema Updates to the Database.
Managed by the `refinery` cli tool.';

-- Config Table
-- This table is looked up with three keys, `id`, `id2` and `id3`
CREATE TABLE
  config (
    row_id SERIAL PRIMARY KEY,
    id VARCHAR NOT NULL,
    id2 VARCHAR NOT NULL,
    id3 VARCHAR NOT NULL,
    VALUE JSONB NULL
  );

-- id+id2+id3 must be unique, they are a combined key.
CREATE UNIQUE INDEX config_idx ON config (id, id2, id3);

COMMENT ON TABLE config IS 'General JSON Configuration and Data Values.
Defined  Data Formats:
  Currently None
';

COMMENT ON COLUMN config.row_id IS 'Synthetic unique key.
Always lookup using id.';

COMMENT ON COLUMN config.id IS 'The name/id of the general config value/variable';

COMMENT ON COLUMN config.id2 IS '2nd ID of the general config value.
Must be defined, use "" if not required.';

COMMENT ON COLUMN config.id3 IS '3rd ID of the general config value.
Must be defined, use "" if not required.';

COMMENT ON COLUMN config.value IS 'The JSON value of the system variable id.id2.id3';

COMMENT ON INDEX config_idx IS 'We use three keys combined uniquely rather than forcing string concatenation at the app level to allow for querying groups of data.';
