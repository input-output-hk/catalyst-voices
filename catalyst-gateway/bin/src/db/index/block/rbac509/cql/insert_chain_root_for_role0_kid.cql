-- Index of Chain Root For Role0 Key. RBAC 509 registrations.
INSERT INTO rbac_chain_root_for_role0_key (
    role0_kid,
    slot_no,
    txn,
    chain_root,
    chain_root_slot,
    chain_root_txn,
    signature_alg,
    public_key
) VALUES (
    :role0_kid,
    :slot_no,
    :txn,
    :chain_root,
    :chain_root_slot,
    :chain_root_txn,
    :signature_alg,
    :public_key
);
