SELECT
  signed_docs.id,
  signed_docs.ver,
  signed_docs.type,
  signed_docs.author,
  signed_docs.metadata
FROM signed_docs
WHERE
  signed_docs.id = $1
  AND signed_docs.ver = $2
ORDER BY signed_docs.id DESC, signed_docs.ver DESC
LIMIT $3
OFFSET $4
