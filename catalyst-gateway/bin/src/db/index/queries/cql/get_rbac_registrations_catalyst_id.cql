SELECT transaction_id,
       slot_no,
       txn,
       prv_txn_id,
       purpose
FROM rbac_registration
WHERE catalyst_id = :catalyst_id
