-- Delete Catalyst ID For Stake Address (RBAC 509 registrations).
DELETE FROM catalyst_id_for_stake_hash
WHERE stake_hash = :stake_hash
    AND slot_no = :slot_no
    AND txn_index = :txn_index
