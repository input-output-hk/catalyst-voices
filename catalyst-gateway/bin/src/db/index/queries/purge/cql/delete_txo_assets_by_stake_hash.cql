-- Delete Transaction Output Assets by Stake Address.
DELETE FROM txo_assets_by_stake
WHERE stake_hash = :stake_hash
    AND slot_no = :slot_no
    AND txn_index = :txn_index
    AND txo = :txo
    AND policy_id = :policy_id
    AND asset_name = :asset_name
