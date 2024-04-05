SELECT
  cardano_slot_index.slot_no,
  cardano_slot_index.block_hash

FROM cardano_slot_index

WHERE
  cardano_slot_index.network = $1
  AND cardano_slot_index.block_time >= $2

ORDER by cardano_slot_index.slot_no

LIMIT 1;