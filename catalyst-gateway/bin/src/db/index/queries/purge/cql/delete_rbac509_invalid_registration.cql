-- Delete RBAC 509 registration.
DELETE FROM rbac509_registration_invalid
WHERE catalyst_id = :catalyst_id
    AND slot_no = :slot_no
    AND txn = :txn
    AND transaction_id = :transaction_id
