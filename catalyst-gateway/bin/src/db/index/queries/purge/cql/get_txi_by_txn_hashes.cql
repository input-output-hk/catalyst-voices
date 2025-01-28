-- Get all primary keys from ADA or a native asset being spent.
SELECT
    txn_hash,
    txo,
    slot_no
FROM txi_by_txn_hash
