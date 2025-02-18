-- Index RBAC 509 Registrations (Valid)
INSERT INTO rbac_registration (
    catalyst_id,
    slot_no,
    txn_index,
    txn_id,
    prv_txn_id,
    purpose
) VALUES (
    :catalyst_id,
    :txn_id,
    :slot_no,
    :txn_index,
    :prv_txn_id,
    :purpose
);
