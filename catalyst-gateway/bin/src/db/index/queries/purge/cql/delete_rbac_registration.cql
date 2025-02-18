-- Delete RBAC 509 registration.
DELETE FROM rbac_registration
WHERE catalyst_id = :catalyst_id
    AND slot_no = :slot_no
    AND txn_index = :txn_index
