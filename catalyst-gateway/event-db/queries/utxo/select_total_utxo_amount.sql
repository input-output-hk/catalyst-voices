-- Select total UTXO's corresponded to the provided stake credential from the given network that have occurred before the given time. 
SELECT
  SUM(cardano_utxo.value)::BIGINT AS total_utxo_amount,
  MAX(cardano_slot_index.slot_no) AS slot_no,
  MAX(cardano_slot_index.block_time) AS block_time

FROM cardano_utxo

INNER JOIN cardano_txn_index
  ON cardano_utxo.tx_id = cardano_txn_index.id

-- filter out orphaned transactions
INNER JOIN cardano_update_state
  ON
    cardano_txn_index.slot_no <= cardano_update_state.slot_no
    AND cardano_txn_index.network = cardano_update_state.network

INNER JOIN cardano_slot_index
  ON
    cardano_txn_index.slot_no = cardano_slot_index.slot_no
    AND cardano_txn_index.network = cardano_slot_index.network

WHERE
  cardano_utxo.stake_credential = $1
  AND cardano_txn_index.network = $2
  AND cardano_slot_index.block_time <= $3;
