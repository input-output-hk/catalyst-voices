-- cardano_blocks indexes
CREATE INDEX IF NOT EXISTS cardano_blocks_block_no ON cardano_blocks USING BTREE (block_no) INCLUDE (slot_no);
CREATE INDEX IF NOT EXISTS cardano_blocks_slot_no ON cardano_blocks USING BTREE(slot_no);
CREATE INDEX IF NOT EXISTS cardano_blocks_block_time ON cardano_blocks USING BTREE(block_time);

-- cardano_transactions indexes
CREATE INDEX IF NOT EXISTS cardano_transactions_hash ON cardano_transactions USING BTREE(hash);
CREATE INDEX IF NOT EXISTS cardano_transactions_block_no ON cardano_transactions USING BTREE(block_no);

-- cardano_txo indexes
CREATE INDEX IF NOT EXISTS cardano_txo_output_ref ON cardano_txo USING BTREE(transaction_hash, index);
CREATE INDEX IF NOT EXISTS cardano_txo_stake_credential ON cardano_txo USING BTREE(stake_credential);

-- cardano_spent_txo indexes
CREATE INDEX IF NOT EXISTS cardano_spent_txo_output_ref ON cardano_spent_txo USING BTREE(from_transaction_hash, index);
CREATE INDEX IF NOT EXISTS cardano_spent_txo_to_transaction_hash ON cardano_spent_txo USING BTREE(to_transaction_hash);
