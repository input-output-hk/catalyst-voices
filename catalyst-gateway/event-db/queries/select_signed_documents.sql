SELECT
  signed_docs.id,
  signed_docs.ver,
  signed_docs.type,
  signed_docs.author,
  signed_docs.metadata,
  signed_docs.payload,
  signed_docs.raw
FROM signed_docs
WHERE
  signed_docs.id = $1
  AND signed_docs.ver = $2
