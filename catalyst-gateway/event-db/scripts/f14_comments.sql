BEGIN;
-- Updating the Fund 14 Comments documents, by adding a 'parameters' field into the metadata column
UPDATE signed_docs AS t1
SET
  metadata = t1.metadata || JSONB_BUILD_OBJECT(
    'parameters', t2.metadata -> 'parameters' -- set referenced proposal document 'parameters' metadata field
  )
FROM
  signed_docs AS t2
WHERE
  t1.metadata IS NOT NULL
  AND t1.type = 'b679ded3-0e7c-41ba-89f8-da62a17898ea' -- modifying only comments
  AND (t1.metadata -> 'ref' ->> 'id')::UUID = t2.id
  AND (t1.metadata -> 'ref' ->> 'ver')::UUID = t2.ver;
COMMIT;
