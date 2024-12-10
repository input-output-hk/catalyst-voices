-- Get all primary keys from Transaction Output by Stake Address.
SELECT
    stake_address,
    slot_no,
    txn,
    txo
FROM txo_by_stake
