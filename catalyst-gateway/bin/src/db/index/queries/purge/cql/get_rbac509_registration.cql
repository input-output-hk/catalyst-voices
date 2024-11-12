-- Get all primary keys from RBAC 509 registration.
SELECT
    chain_root,
    slot_no,
    txn,
    transaction_id,
    purpose
FROM rbac509_registration
