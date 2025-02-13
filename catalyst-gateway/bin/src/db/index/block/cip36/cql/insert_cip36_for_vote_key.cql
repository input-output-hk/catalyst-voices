-- Index CIP-36 Registration (For each Vote Key)
INSERT INTO cip36_registration_for_vote_key (
    vote_key,
    stake_address,
    slot_no,
    txn_index,
    valid
) VALUES (
    :vote_key,
    :stake_address,
    :slot_no,
    :txn_index,
    :valid
);
