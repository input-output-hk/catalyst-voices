SELECT transaction_id,
       slot_no,
       txn,
       prv_txn_id,
       purpose,
       problem_report
FROM rbac_invalid_registration
WHERE catalyst_id = :catalyst_id
