INSERT INTO cardano_slot_index
(
  slot_no,
  network,
  epoch_no,
  block_time,
  block_hash
)

VALUES ($1, $2, $3, $4, $5)
