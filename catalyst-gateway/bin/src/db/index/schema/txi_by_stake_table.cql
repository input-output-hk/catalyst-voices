-- This table IS NOT used for persistent data.
-- IF data is immutably spent, the required fields are added to the TXO table.
-- This could be ADA or a native asset being spent.
-- This can represent a spend on either immutable data or volatile data,
-- and represents a spend which is potentially subject to rollback.
CREATE TABLE IF NOT EXISTS txi_by_stake (
    stake_address   ascii,    -- stake address (CIP19 Formatted Text)
    slot_no         bigint,   -- slot number the txi was spent in.
    txn             smallint, -- transaction number the txi is in.
    ofs             smallint, -- offset in the transaction the txi is in.

    txo_slot_no     bigint,   -- slot number the TXO was spent from.
    txo_txn         bigint,   -- Transaction in the slot the txo was spent from.
    txo_ofs         smallint, -- TXO index in the transaction being spent.

    chain           ascii,    -- chain the txo was created in (stake_address should be unique, this is for disambiguation only).
                
    PRIMARY KEY (stake_address, slot_no, txn, ofs)
);
