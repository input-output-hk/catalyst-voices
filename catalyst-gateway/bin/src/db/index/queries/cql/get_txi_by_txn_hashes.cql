SELECT
    txn_hash,
    txo,
    slot_no
FROM txi_by_txn_hash
WHERE txn_hash IN :txn_hashes
