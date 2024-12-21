-- Get all primary keys from Transaction Output Assets by Stake Address.
SELECT
    stake_address,
    slot_no,
    txn,
    txo,
    policy_id,
    policy_name
FROM txo_assets_by_stake
