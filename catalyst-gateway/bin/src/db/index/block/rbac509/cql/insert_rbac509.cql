-- Index RBAC 509 Registrations (Valid)
INSERT INTO rbac_registration (
    catalyst_id,
    slot_no,
    txn_index,
    txn_id,
    prv_txn_id,
    removed_stake_addresses
) VALUES (
    :catalyst_id,
    :slot_no,
    :txn_index,
    :txn_id,
    :prv_txn_id,
    :removed_stake_addresses
);
