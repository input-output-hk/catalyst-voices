-- Index CIP-36 Registrations (Valid)
INSERT INTO cip36_registration (
    stake_public_key,
    nonce,
    slot_no,
    txn_index,
    vote_key,
    payment_address,
    is_payable,
    raw_nonce,
    cip36
) VALUES (
    :stake_public_key,
    :nonce,
    :slot_no,
    :txn_index,
    :vote_key,
    :payment_address,
    :is_payable,
    :raw_nonce,
    :cip36
);
