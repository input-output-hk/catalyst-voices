-- Index Stake Registrations
INSERT INTO stake_registration (
    stake_address,
    slot_no,
    txn_index,
    stake_public_key,
    script,
    register,
    deregister,
    cip36,
    pool_delegation
) VALUES (
    :stake_address,
    :slot_no,
    :txn_index,
    :stake_public_key,
    :script,
    :register,
    :deregister,
    :cip36,
    :pool_delegation
);
