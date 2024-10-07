-- Index of Chain Root For TX ID. RBAC 509 registrations.
INSERT INTO chain_root_for_txn_id (
    transaction_id,
    chain_root
) VALUES (
    :transaction_id,
    :chain_root
);
