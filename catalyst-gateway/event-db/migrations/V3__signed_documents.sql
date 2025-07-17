-- Signed Documents Repository updates:
-- * `type` metadata field changed from the single `UUIDv4` value to become an array `[UUIDv4]`.

ALTER TABLE signed_docs
ALTER COLUMN type TYPE UUID[] USING ARRAY[type];
