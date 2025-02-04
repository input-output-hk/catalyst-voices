-- Index of Chain Root For Stake Address. RBAC 509 registrations.
INSERT INTO rbac_catalyst_id_for_stake_addr (
    stake_addr,
    slot_no,
    txn,
    catalyst_id,
    chain_root_slot,
    chain_root_txn
) VALUES (
    :stake_addr,
    :slot_no,
    :txn,
    :catalyst_id,
    :chain_root_slot,
    :chain_root_txn
);
