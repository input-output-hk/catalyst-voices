-- Delete Catalyst ID for public key (RBAC 509 registrations).
DELETE FROM catalyst_id_for_public_key
WHERE public_key = :public_key
