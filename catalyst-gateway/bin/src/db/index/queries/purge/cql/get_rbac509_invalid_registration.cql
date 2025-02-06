-- Get all primary keys from RBAC 509 invalid registration.
SELECT
    chain_root,
    slot_no,
    txn,
    transaction_id
FROM rbac509_invalid_registration
