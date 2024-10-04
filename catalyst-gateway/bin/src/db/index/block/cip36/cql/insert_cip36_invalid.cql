-- Index CIP-36 Registrations by Vote Key
INSERT INTO cip36_registration_invalid (
    stake_address,
    slot_no,
    txn,
    vote_key,
    payment_address,
    is_payable,
    raw_nonce,
    nonce,
    cip36,
    signed,
    error_report
) VALUES (
    :stake_address,
    :slot_no,
    :txn,
    :vote_key,
    :payment_address,
    :is_payable,
    :raw_nonce,
    :nonce,
    :cip36,
    :signed,
    :error_report
);
