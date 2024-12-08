-- Index of Chain Root For TX ID. RBAC 509 registrations.
INSERT INTO rbac_chain_root_for_txn_id (
    transaction_id,
    chain_root,
    slot_no,
    txn_idx
) VALUES (
    :transaction_id,
    :chain_root,
    :slot_no,
    :txn_idx
);
