-- Delete Chain Root For Stake Address (RBAC 509 registrations).
DELETE FROM chain_root_for_stake_addr
WHERE stake_addr = :stake_addr
    AND slot_no = :slot_no
    AND txn = :txn
