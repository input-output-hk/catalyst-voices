-- Index of RBAC 509 registrations. Valid. 
CREATE TABLE IF NOT EXISTS rbac_registration (
    -- Primary Key Data
    catalyst_id         text,           -- Short Catalyst id
    slot_no             varint,         -- slot number of the txn_id. (u64)
    txn_index           smallint,       -- Index of the TX which holds the registration data. (i16)

    -- Non-Key Data
    txn_id              blob,           -- 32 Bytes of Transaction Hash. (TransactionHash)
    prv_txn_id          blob,           -- 32 Bytes from Previous Transaction Hash.
    purpose             uuid,           -- 16 Bytes of UUIDv4 Purpose.
    stake_address       blob,       -- 29 Byte stake hash (CIP19) [only set when the registration has a stake address attached]

    PRIMARY KEY (catalyst_id, slot_no, txn_index)
)
WITH CLUSTERING ORDER BY (slot_no DESC, txn_index DESC);

CREATE INDEX cat_id_by_transaction_id ON rbac_registration (txn_id);
CREATE INDEX cat_id_by_stake_address ON rbac_registration(stake_address);
