SELECT
  slot_no,
  block_hash,
  ended

FROM cardano_update_state

WHERE
  network = $1;
