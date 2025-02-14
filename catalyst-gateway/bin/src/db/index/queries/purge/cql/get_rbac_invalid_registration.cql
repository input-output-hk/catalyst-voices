-- Get all primary keys from RBAC 509 invalid registration.
SELECT
    catalyst_id,
    txn_id,
    slot_no,
    txn_index
FROM rbac_invalid_registration
