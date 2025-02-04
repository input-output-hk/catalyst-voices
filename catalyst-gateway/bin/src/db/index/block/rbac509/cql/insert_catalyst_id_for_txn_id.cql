-- Index of Chain Root For TX ID. RBAC 509 registrations.
INSERT INTO rbac_catalyst_id_for_txn_id (
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
