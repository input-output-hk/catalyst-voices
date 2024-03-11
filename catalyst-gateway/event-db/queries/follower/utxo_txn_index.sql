INSERT INTO cardano_txn_index
(
  id,
  slot_no,
  network
) 

VALUES ($1, $2, $3)

ON CONFLICT(id) DO NOTHING