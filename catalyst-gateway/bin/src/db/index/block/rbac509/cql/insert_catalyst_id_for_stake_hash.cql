-- Index of Catalyst ID For Stake Address. RBAC 509 registrations.
INSERT INTO catalyst_id_for_stake_hash (
    stake_hash,
    slot_no,
    txn_index,
    catalyst_id
) VALUES (
    :stake_hash,
    :slot_no,
    :txn_index,
    :catalyst_id
);
