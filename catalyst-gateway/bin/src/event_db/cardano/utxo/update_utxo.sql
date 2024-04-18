UPDATE cardano_utxo

SET spent_tx_id = $1

WHERE
  tx_id = $2
  AND index = $3;
