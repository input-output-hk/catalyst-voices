-- Get all primary keys from Stake Registration.
SELECT 
    stake_address,
    script,
    slot_no,
    txn_index
FROM stake_registration
