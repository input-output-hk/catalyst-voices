SELECT
  payment_address,
  tx_id

FROM cardano_voter_registration

INNER JOIN cardano_txn_index
  ON cardano_voter_registration.tx_id = cardano_txn_index.id

-- filter out orphaned transactions
INNER JOIN cardano_update_state
  ON
    cardano_txn_index.slot_no <= cardano_update_state.slot_no
    AND cardano_txn_index.network = cardano_update_state.network

WHERE
  cardano_voter_registration.valid = TRUE
  AND cardano_voter_registration.stake_credential = $1
  AND cardano_txn_index.network = $2
  AND cardano_txn_index.slot_no <= $3
  
ORDER BY cardano_txn_index.nonce DESC 

LIMIT 1;