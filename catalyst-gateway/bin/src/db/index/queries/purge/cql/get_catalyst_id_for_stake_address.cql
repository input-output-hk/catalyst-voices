-- Get all primary keys from Catalyst ID for stake address (RBAC 509 registrations).
SELECT
    stake_address,
    slot_no,
    txn_index
FROM catalyst_id_for_stake_address
