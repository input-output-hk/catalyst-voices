SELECT
    txn_index,
    txo,
    slot_no,
    policy_id,
    asset_name,
    value
FROM txo_assets_by_stake
WHERE stake_address = :stake_address
