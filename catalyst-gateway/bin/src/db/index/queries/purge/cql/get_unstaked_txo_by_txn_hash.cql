-- Get ALL Primary Keys from Unstaked Transaction Outputs (Native Assets) per stake address.
SELECT
    txn_id,
    txo,
    slot_no
FROM unstaked_txo_by_txn_id
