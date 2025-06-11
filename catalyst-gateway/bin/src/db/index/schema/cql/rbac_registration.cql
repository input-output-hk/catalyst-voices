-- Index of RBAC 509 registrations. Valid. 
CREATE TABLE IF NOT EXISTS rbac_registration (
    -- Primary Key Data
    catalyst_id                text,         -- Short Catalyst id
    slot_no                    varint,       -- slot number of the txn_id. (u64)
    txn_index                  smallint,     -- Index of the TX which holds the registration data. (i16)

    -- Non-Key Data
    txn_id                     blob,         -- 32 Bytes of Transaction Hash. (TransactionHash)
    prv_txn_id                 blob,         -- 32 Bytes from Previous Transaction Hash.
    removed_stake_addresses    set<blob>,    -- A set of stake addresses that were removed by other chain.
                                             -- The set is empty for all registrations of this chain.

    PRIMARY KEY (catalyst_id, slot_no, txn_index)
)
WITH CLUSTERING ORDER BY (slot_no DESC, txn_index DESC);
