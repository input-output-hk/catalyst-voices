-- Get all primary keys from Unstaked Transaction Output Assets by Transaction Hash.
SELECT
    txn_hash,
    txo
FROM unstaked_txo_by_txn_hash
