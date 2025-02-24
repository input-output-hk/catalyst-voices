-- Delete RBAC 509 registration.
DELETE FROM rbac_registration
WHERE catalyst_id = :catalyst_id
    AND txn_id = :txn_id
