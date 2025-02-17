-- Get all primary keys from Transaction Output by Stake Address.
SELECT
    stake_hash,
    slot_no,
    txn_index,
    txo
FROM txo_by_stake
