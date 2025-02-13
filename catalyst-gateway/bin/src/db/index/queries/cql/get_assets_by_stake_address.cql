SELECT
    txn_index,
    txo,
    slot_no,
    policy_id,
    asset_name,
    value
FROM txo_assets_by_stake
WHERE stake_key_hash = :stake_key_hash
AND slot_no <= :slot_no
