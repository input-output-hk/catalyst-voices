-- Index Stake Registrations
INSERT INTO stake_registration (
    stake_hash,
    slot_no,
    txn,
    stake_address,
    script,
    register,
    deregister,
    pool_delegation
) VALUES (
    :stake_hash,
    :slot_no,
    :txn,
    :stake_address,
    :script,
    :register,
    :deregister,
    :pool_delegation
);