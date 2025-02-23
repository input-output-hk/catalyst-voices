-- Delete Unstaked Transaction Output Assets by Transaction Hash.
DELETE FROM unstaked_txo_by_txn_id
WHERE txn_id = :txn_id
    AND txo = :txo
