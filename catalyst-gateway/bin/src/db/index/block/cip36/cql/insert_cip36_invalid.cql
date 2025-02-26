-- Index CIP-36 Registrations by Vote Key
INSERT INTO cip36_registration_invalid (
    stake_public_key,
    slot_no,
    txn_index,
    vote_key,
    payment_address,
    is_payable,
    raw_nonce,
    nonce,
    cip36,
    signed,
    problem_report
) VALUES (
    :stake_public_key,
    :slot_no,
    :txn_index,
    :vote_key,
    :payment_address,
    :is_payable,
    :raw_nonce,
    :nonce,
    :cip36,
    :signed,
    :problem_report
);
