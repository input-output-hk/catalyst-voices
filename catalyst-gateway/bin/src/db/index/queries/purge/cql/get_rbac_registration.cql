-- Get all primary keys from RBAC 509 registration.
SELECT
    catalyst_id,
    txn_id,
    slot_no,
    txn_index
FROM rbac_registration
