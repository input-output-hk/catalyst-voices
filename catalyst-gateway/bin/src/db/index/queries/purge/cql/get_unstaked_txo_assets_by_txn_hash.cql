-- Get all primary keys from Transaction Outputs (Native Assets) by Transaction Hash.
SELECT
    txn_hash,
    txo,
    policy_id,
    asset_name,
    slot_no
FROM unstaked_txo_assets_by_txn_hash
