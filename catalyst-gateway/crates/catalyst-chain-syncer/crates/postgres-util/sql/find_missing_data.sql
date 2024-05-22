WITH block_no_ranges AS (
   SELECT
        block_no,
        slot_no,
        LEAD (block_no) OVER (ORDER BY block_no) AS next_block_no
   FROM cardano_blocks
)
SELECT
    r.slot_no,
    b.slot_no AS next_slot_no
FROM block_no_ranges r
JOIN cardano_blocks b ON b.block_no = next_block_no
WHERE (r.next_block_no - r.block_no) > 1
