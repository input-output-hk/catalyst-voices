-- Index CIP-36 Registrations by Vote Key
INSERT INTO cip36_registration_invalid (
    vote_key,
    slot_no,
    txn,
    stake_address,
    payment_address,
    is_payable,
    raw_nonce,
    nonce,
    cip36,
    signed,
    error_report,
) VALUES (
    :vote_key,
    :slot_no,
    :txn,
    :stake_address,
    :payment_address,
    :is_payable,
    :raw_nonce,
    :nonce,
    :cip36,
    :signed,
    :error_report
);
