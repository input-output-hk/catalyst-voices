SELECT
    catalyst_id,
    slot_no
FROM
    catalyst_id_for_txn_id
WHERE
    txn_id = :txn_id
