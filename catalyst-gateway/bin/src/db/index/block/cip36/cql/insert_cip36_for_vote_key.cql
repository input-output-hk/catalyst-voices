-- Index CIP-36 Registration (Valid)
INSERT INTO cip36_registration_for_stake_addr (
    vote_key,
    stake_address,
    slot_no,
    txn,
    valid,
) VALUES (
    :vote_key,
    :stake_address,
    :slot_no,
    :txn,
    :valid,
);
