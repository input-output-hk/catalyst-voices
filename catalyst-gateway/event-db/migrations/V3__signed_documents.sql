
UPDATE signed_docs AS t1
SET
  metadata = t1.metadata || jsonb_build_object(
    'parameters', t2.metadata -> 'parameters' -- set referenced proposal document 'parameters' metadata field
  )
FROM
  signed_docs AS t2
WHERE
  t1.metadata IS NOT NULL  
  AND t1.type = 'b679ded3-0e7c-41ba-89f8-da62a17898ea' -- modifying only comments
  AND (t1.metadata -> 'ref' ->> 'id')::uuid = t2.id
  AND (t1.metadata -> 'ref' ->> 'ver')::uuid = t2.ver;
