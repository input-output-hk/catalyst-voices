-- Index of Chain Root For Stake Address. RBAC 509 registrations.
INSERT INTO rbac_chain_root_for_stake_addr (
    stake_addr,
    slot_no,
    txn,
    chain_root,
    chain_root_slot,
    chain_root_txn
) VALUES (
    :stake_addr,
    :slot_no,
    :txn,
    :chain_root,
    :chain_root_slot,
    :chain_root_txn
);
