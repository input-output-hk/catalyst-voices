-- Index Stake Registrations
INSERT INTO stake_registration (
    stake_key_hash,
    slot_no,
    txn_index,
    stake_public_key,
    script,
    register,
    deregister,
    pool_delegation
) VALUES (
    :stake_key_hash,
    :slot_no,
    :txn_index,
    :stake_public_key,
    :script,
    :register,
    :deregister,
    :pool_delegation
);
