-- Index RBAC 509 Registrations (invalid)
INSERT INTO rbac_invalid_registration (
    catalyst_id,
    txn_id,
    slot_no,
    txn_index,
    prv_txn_id,
    purpose,
    problem_report
) VALUES (
    :catalyst_id,
    :txn_id,
    :slot_no,
    :txn_index,
    :prv_txn_id,
    :purpose,
    :problem_report
);

