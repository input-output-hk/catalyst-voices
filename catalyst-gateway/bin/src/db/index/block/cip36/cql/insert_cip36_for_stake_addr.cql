-- Index CIP-36 Registration (Valid)
INSERT INTO cip36_registration_for_stake_addr (
    stake_address,
    vote_key,
    slot_no,
    txn,
    valid,
) VALUES (
    :stake_address,
    :vote_key,
    :slot_no,
    :txn,
    :valid,
);
