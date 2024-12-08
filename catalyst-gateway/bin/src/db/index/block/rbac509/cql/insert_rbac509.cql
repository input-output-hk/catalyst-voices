-- Index RBAC 509 Registrations (Valid)
INSERT INTO rbac_registration (
    chain_root,
    transaction_id,
    slot_no,
    txn,
    prv_txn_id
    purpose,
) VALUES (
    :chain_root,
    :transaction_id,
    :slot_no,
    :txn,
    :prv_txn_id
    :purpose,
);
