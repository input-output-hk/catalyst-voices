-- Index RBAC 509 Registrations (Valid)
INSERT INTO rbac_registration_invalid (
    catalyst_id,
    transaction_id,
    slot_no,
    txn,
    prv_txn_id,
    purpose,
    problem_report
) VALUES (
    :catalyst_id,
    :transaction_id,
    :slot_no,
    :txn,
    :prv_txn_id
    :purpose,
    :problem_report
);
