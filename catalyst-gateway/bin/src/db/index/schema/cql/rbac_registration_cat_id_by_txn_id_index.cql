-- Secondary index for RBAC 509 registrations table.
CREATE INDEX IF NOT EXISTS cat_id_by_txn_id ON rbac_registration (txn_id);
