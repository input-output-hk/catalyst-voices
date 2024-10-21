-- Insert a new configuration entry into the 'config' table
INSERT INTO config (id1, id2, id3, value)
VALUES ($1, $2, $3, $4) -- Values to insert for each column

-- Handle conflicts when attempting to insert a row that would violate the unique constraint
ON CONFLICT (id1, id2, id3)  -- Specify the unique constraint columns that identify conflicts

-- If a conflict occurs, update the existing row 'value' column with the new value provided
DO UPDATE SET value = excluded.value;  -- 'EXCLUDED' refers to the values that were proposed for insertion
