-- Index RBAC 509 Registrations (Valid)
INSERT INTO RBAC509_registration (
    chain_root,
    transaction_id,
    purpose,
    slot_no,
    txn,
    prv_txn_id
) VALUES (
    :chain_root,
    :transaction_id,
    :purpose,
    :slot_no,
    :txn,
    :prv_txn_id
);
