SELECT
    catalyst_id,
    slot_no,
    txn_index
FROM
    catalyst_id_for_txn_id
WHERE
    txn_id = :txn_id
