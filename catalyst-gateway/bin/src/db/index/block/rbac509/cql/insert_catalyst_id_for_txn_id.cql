-- Index of Catalyst ID For TX ID. RBAC 509 registrations.
INSERT INTO catalyst_id_for_txn_id (
    txn_id,
    catalyst_id,
    slot_no,
    txn_index
) VALUES (
    :txn_id,
    :catalyst_id,
    :slot_no,
    :txn_index
);
