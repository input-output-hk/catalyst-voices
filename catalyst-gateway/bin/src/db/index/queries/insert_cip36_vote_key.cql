-- Index CIP-36 Registrations by Vote Key
INSERT INTO cip36_registration_by_vote_key (
    vote_key,
    stake_address,
    slot_no,
    txn,
    payment_address,
    is_payable,
    raw_nonce,
    nonce,
    purpose,
    signed,
    strict_catalyst,
    error_report
) VALUES (
    :vote_key,
    :stake_address,
    :slot_no,
    :txn,
    :payment_address,
    :is_payable,
    :raw_nonce,
    :nonce,
    :purpose,
    :signed,
    :strict_catalyst,
    :error_report
);
