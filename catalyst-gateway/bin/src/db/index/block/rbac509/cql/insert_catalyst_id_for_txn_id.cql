-- Index of Catalyst ID For TX ID. RBAC 509 registrations.
INSERT INTO catalyst_id_for_txn_id (
    transaction_id,
    catalyst_id,
    slot_no,
    txn_idx
) VALUES (
    :transaction_id,
    :catalyst_id,
    :slot_no,
    :txn_idx
);
