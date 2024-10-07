-- Index RBAC 509 Registrations (Valid)
INSERT INTO RBAC509_registration (
    chain_root,
    slot_no,
    txn,
    transaction_id,
    purpose,
    prv_txn_id
) VALUES (
    :chain_root,
    :slot_no,
    :txn,
    :transaction_id,
    :purpose,
    :prv_txn_id
);
