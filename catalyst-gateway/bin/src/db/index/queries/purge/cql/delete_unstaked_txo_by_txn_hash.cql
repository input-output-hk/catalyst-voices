-- Delete Unstaked Transaction Output Assets by Transaction Hash.
DELETE FROM unstaked_txo_by_txn_hash
WHERE txn_hash = :txn_hash
    AND txo = :txo
