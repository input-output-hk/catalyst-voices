-- Delete RBAC 509 registration.
DELETE FROM rbac509_registration
WHERE chain_root = :chain_root
    AND slot_no = :slot_no
    AND txn = :txn
    AND transaction_id = :transaction_id
    AND purpose = :purpose
