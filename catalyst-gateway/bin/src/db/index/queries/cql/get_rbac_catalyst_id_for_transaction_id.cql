SELECT
    catalyst_id,
    slot_no,
    txn_idx
FROM
    rbac_catalyst_id_for_txn_id
WHERE
    transaction_id = :transaction_id
