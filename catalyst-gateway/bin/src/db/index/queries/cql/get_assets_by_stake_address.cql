SELECT
    txn_index,
    txo,
    slot_no,
    policy_id,
    asset_name,
    value
FROM txo_assets_by_stake
WHERE stake_hash = :stake_hash
AND slot_no <= :slot_no
