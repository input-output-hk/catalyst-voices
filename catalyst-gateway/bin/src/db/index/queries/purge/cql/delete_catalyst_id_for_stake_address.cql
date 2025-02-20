-- Delete Catalyst ID For Stake Address (RBAC 509 registrations).
DELETE FROM catalyst_id_for_stake_address
WHERE stake_address = :stake_address
