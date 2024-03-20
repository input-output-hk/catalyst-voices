-- Select total UTXO's corresponded to the provided stake credential from the given network that have occurred before the given time. 
SELECT
  cardano_txn_index.network,
  SUM(cardano_utxo.value) AS total_utxo_amount

FROM cardano_utxo

INNER JOIN cardano_txn_index
  ON cardano_utxo.tx_id = cardano_txn_index.id

INNER JOIN cardano_slot_index
  ON
    cardano_txn_index.slot_no = cardano_slot_index.slot_no
    AND cardano_txn_index.network = cardano_slot_index.network

WHERE
  cardano_utxo.stake_credential = $1
  AND cardano_slot_index.block_time <= $2

GROUP BY cardano_txn_index.network;
