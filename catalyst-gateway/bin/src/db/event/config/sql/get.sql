-- Select the 'value' column from the 'config' table
SELECT value
FROM config
-- Filter the results based on the following conditions
WHERE id1 = $1  -- Match rows where 'id1' equals the first parameter
  AND id2 = $2  -- Match rows where 'id2' equals the second parameter
  AND id3 = $3; -- Match rows where 'id3' equals the third parameter
