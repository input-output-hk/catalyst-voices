-- Delete Primary Keys from Unstaked Transaction Outputs (Native Assets) by their transaction hash.
DELETE FROM unstaked_txo_assets_by_txn_hash
WHERE txn_hash = :txn_hash
    AND txo = :txo
    AND policy_id = :policy_id
    AND asset_name = :asset_name
