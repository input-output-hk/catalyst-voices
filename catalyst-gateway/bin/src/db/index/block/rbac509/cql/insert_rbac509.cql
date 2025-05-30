-- Index RBAC 509 Registrations (Valid)
INSERT INTO rbac_registration (
    catalyst_id,
    txn_id,
    slot_no,
    txn_index,
    prv_txn_id
) VALUES (
    :catalyst_id,
    :txn_id,
    :slot_no,
    :txn_index,
    :prv_txn_id
);
