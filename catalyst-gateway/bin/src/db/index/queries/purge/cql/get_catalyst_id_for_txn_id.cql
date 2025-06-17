-- Get all primary key (txn_id) and slot from Catalyst ID for transaction ID (RBAC 509 Registrations).
SELECT
    txn_id,
    slot_no
FROM catalyst_id_for_txn_id
