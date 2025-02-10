-- Delete RBAC 509 registration.
DELETE FROM rbac_registration
WHERE catalyst_id = :catalyst_id
    AND transaction_id = :slot_no
    AND slot_no = :txn
    AND txn = :transaction_id
