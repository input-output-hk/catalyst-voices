-- Index CIP-36 Registrations by Stake Address
INSERT INTO cip36_registration_by_stake_address (
    stake_address,
    vote_key,
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
    :stake_address,
    :vote_key,
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
