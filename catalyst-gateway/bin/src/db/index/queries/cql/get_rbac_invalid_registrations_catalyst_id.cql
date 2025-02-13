SELECT txn_id,
       slot_no,
       txn_index,
       prv_txn_id,
       purpose,
       problem_report
FROM rbac_invalid_registration
WHERE catalyst_id = :catalyst_id
