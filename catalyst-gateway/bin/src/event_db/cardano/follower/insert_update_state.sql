-- If no last updated metadata, init with metadata. If present update metadata.
INSERT INTO cardano_update_state
(
  id,
  started,
  ended,
  updater_id,
  slot_no,
  network,
  block_hash,
  update
)

VALUES ($1, $2, $3, $4, $5, $6, $7, $8)

ON CONFLICT (id) DO UPDATE SET
ended = $2,
slot_no = $5,
block_hash = $7;
