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