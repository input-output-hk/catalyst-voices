-- Get all primary keys from RBAC 509 registration.
SELECT
    catalyst_id,
    transaction_id,
    slot_no,
    txn
FROM rbac_registration
