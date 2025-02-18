-- Index RBAC 509 Registrations (invalid)
INSERT INTO rbac_invalid_registration (
    catalyst_id,
    slot_no,
    txn_index,
    txn_id,
    prv_txn_id,
    purpose,
    problem_report
) VALUES (
    :catalyst_id,
    :slot_no,
    :txn_index,
    :txn_id,
    :prv_txn_id,
    :purpose,
    :problem_report
);
