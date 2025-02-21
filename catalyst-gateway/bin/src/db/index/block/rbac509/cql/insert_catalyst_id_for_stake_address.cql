-- Index of Catalyst ID For Stake Address. RBAC 509 registrations.
INSERT INTO catalyst_id_for_stake_address (
    stake_address,
    catalyst_id,
    slot_no
) VALUES (
    :stake_address,
    :catalyst_id,
    :slot_no
);
