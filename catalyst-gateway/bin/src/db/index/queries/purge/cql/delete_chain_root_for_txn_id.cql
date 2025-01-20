-- Delete Chain Root For TX ID (RBAC 509 registrations).
DELETE FROM chain_root_for_txn_id
WHERE transaction_id = :transaction_id
