SELECT txn_id,
       slot_no,
       txn_index,
       prv_txn_id,
       removed_stake_addresses
FROM rbac_registration
WHERE catalyst_id = :catalyst_id
