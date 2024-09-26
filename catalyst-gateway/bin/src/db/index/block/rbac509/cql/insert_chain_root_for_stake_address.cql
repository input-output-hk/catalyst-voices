-- Index of Chain Root For Stake Address. RBAC 509 registrations.
INSERT INTO chain_root_for_stake_addr (
    stake_addr,
    slot_no,
    txn,
    chain_root
) VALUES (
    :stake_addr,
    :slot_no,
    :txn,
    :chain_root
);
