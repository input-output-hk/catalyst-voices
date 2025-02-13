SELECT
    txn_id,
    txo,
    slot_no
FROM txi_by_txn_id
WHERE txn_id IN :txn_id
