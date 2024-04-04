-- Select total UTXO's corresponded to the provided stake credential from the given network that have occurred before the given time. 
SELECT
  SUM(cardano_utxo.value)::BIGINT AS total_utxo_amount,
  MAX(cardano_txn_index.slot_no) AS slot_no

FROM cardano_utxo

INNER JOIN cardano_txn_index
  ON cardano_utxo.tx_id = cardano_txn_index.id

LEFT JOIN cardano_txn_index AS spent_txn_index
  ON cardano_utxo.spent_tx_id = spent_txn_index.id

-- filter out orphaned transactions
INNER JOIN cardano_update_state
  ON
    cardano_txn_index.slot_no <= cardano_update_state.slot_no
    AND cardano_txn_index.network = cardano_update_state.network

WHERE
  cardano_utxo.stake_credential = $1
  AND cardano_txn_index.network = $2
  AND (cardano_utxo.spent_tx_id IS NULL OR spent_txn_index.slot_no > $3)
  AND cardano_txn_index.slot_no <= $3;
