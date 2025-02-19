
SELECT
    catalyst_id
FROM
    catalyst_id_for_txn_id
WHERE
    txn_id = :txn_id
