-- Index of Catalyst ID public key. RBAC 509 registrations.
INSERT INTO catalyst_id_for_public_key (
    public_key,
    catalyst_id,
    slot_no
) VALUES (
    :public_key,
    :catalyst_id,
    :slot_no
);
