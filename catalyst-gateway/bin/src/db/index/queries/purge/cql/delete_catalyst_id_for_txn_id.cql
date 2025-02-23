-- Delete Catalyst ID For TX ID (RBAC 509 registrations).
DELETE FROM catalyst_id_for_txn_id
WHERE txn_id = :txn_id
