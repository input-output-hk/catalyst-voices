-- Delete ADA or a native asset being spent.
-- This can represent a spend on either immutable data or volatile data.
DELETE FROM txi_by_txn_id
WHERE txn_id = :txn_id
    AND txo = :txo
