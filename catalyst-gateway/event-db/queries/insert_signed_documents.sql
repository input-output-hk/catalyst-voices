INSERT INTO signed_docs
(
  id, 
  ver, 
  type, 
  author, 
  metadata,
  payload, 
  raw
)
VALUES
($1, $2, $3, $4, $5, $6, $7)
ON CONFLICT (id, ver) DO UPDATE
SET 
  type = signed_docs.type
WHERE 
  signed_docs.type = EXCLUDED.type
  AND signed_docs.author = EXCLUDED.author
  AND signed_docs.metadata = EXCLUDED.metadata
  AND signed_docs.payload = EXCLUDED.payload
  AND signed_docs.raw = EXCLUDED.raw
