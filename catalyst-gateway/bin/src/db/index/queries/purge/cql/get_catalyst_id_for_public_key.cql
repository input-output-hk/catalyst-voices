-- Get primary key (public_key) and slot from Catalyst ID For public key (RBAC 509 registrations).
SELECT
    public_key,
    slot_no
FROM catalyst_id_for_public_key
