-- Index Stake Registrations
INSERT INTO stake_registration (
    stake_hash,
    slot_no,
    txn_index,
    stake_address,
    script,
    register,
    deregister,
    pool_delegation
) VALUES (
    :stake_hash,
    :slot_no,
    :txn_index,
    :stake_address,
    :script,
    :register,
    :deregister,
    :pool_delegation
);