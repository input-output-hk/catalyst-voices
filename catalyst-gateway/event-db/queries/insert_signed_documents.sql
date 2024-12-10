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
  id = EXCLUDED.id
WHERE 
  type = EXCLUDED.type
  AND author = EXCLUDED.author
  AND metadata = EXCLUDED.metadata
  AND payload = EXCLUDED.payload
  AND raw = EXCLUDED.raw
