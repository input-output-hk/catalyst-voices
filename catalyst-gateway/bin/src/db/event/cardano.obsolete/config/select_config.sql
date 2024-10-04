SELECT
  id3,
  value

FROM config

WHERE
  id = $1
  AND id2 = $2;
