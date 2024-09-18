-- Index CIP-36 Registrations (Valid)
INSERT INTO cip36_registration (
    vote_key,
    stake_address,
    nonce,
    slot_no,
    txn,
    payment_address,
    is_payable,
    raw_nonce,
    cip36,
) VALUES (
    :vote_key,
    :stake_address,
    :nonce,
    :slot_no,
    :txn,
    :payment_address,
    :is_payable,
    :raw_nonce,
    :cip36,
);
