-- Catalyst Voices Database - Role Registration Data
-- sqlfluff:dialect:postgres

-- Configuration Tables

-- -------------------------------------------------------------------------------------------------

-- cardano update state table.
-- Keeps a record of each update to the Role Registration state data.
-- Used internally to track the updates to the database.
CREATE TABLE cardano_update_state (

    id BIGSERIAL PRIMARY KEY,
    time TIMESTAMP NOT NULL,
    updater_id TEXT NOT NULL,

    network TEXT NOT NULL,

    old_max_slot_no BIGINT NOT NULL,
    new_max_slot_no BIGINT NOT NULL,
    rollback_slot_no BIGINT NOT NULL,

    stats JSONB NOT NULL
);

CREATE INDEX cardano_update_state_time_idx ON cardano_update_state (time);

-- -------------------------------------------------------------------------------------------------

-- Slot Index Table
CREATE TABLE slot_index (
    slot_no BIGINT NOT NULL,
    network TEXT NOT NULL,
    epoch_no BIGINT NOT NULL,
    time TIMESTAMP NOT NULL,
    block_hash BYTEA NOT NULL,

    PRIMARY KEY (slot_no, network)
);

CREATE INDEX slot_index_time_idx ON slot_index (time, network);
CREATE INDEX slot_index_epoch_idx ON slot_index (epoch_no, network);

-- -------------------------------------------------------------------------------------------------


-- UTXO Table -- Unspent TX Outputs
-- Populated with this query from db-sync
--     SELECT tx_out.tx_id, block.slot_no, block.time, stake_address.hash_raw AS stake_credential FROM tx_out
--         INNER JOIN tx ON tx_out.tx_id = tx.id
--         INNER JOIN block ON tx.block_id = block.id
--         INNER JOIN stake_address ON stake_address.id = tx_out.stake_address_id;
-- network needs to be supplied, as dbsync only has a single database per network.
CREATE TABLE cardano_utxo (
    tx_id BIGINT NOT NULL,
    index INTEGER NOT NULL,
    network TEXT NOT NULL,

    value BIGINT NOT NULL,

    slot_no BIGINT NOT NULL,

    stake_credential BYTEA NOT NULL,

    PRIMARY KEY (tx_id, index, network),
    FOREIGN KEY (slot_no, network) REFERENCES slot_index (slot_no, network)
);

CREATE INDEX cardano_utxo_stake_credential_idx ON utxo (stake_credential);
CREATE INDEX cardano_utxo_stake_credential_slot_idx ON utxo (stake_credential, slot_no);




-- -------------------------------------------------------------------------------------------------

-- STXO Table -- Spent TX Outputs.
-- Populated with this query from db-sync
--     SELECT tx_out_id as tx_id, tx_out_index as index, tx_in.id as spent_tx_id, slot_no, time  FROM tx_in
--        INNER JOIN tx ON tx_in.tx_in_id = tx.id
--        INNER JOIN block ON tx.block_id = block.id;
-- network needs to be supplied, as dbsync only has a single database per network.
CREATE TABLE cardano_stxo (
    tx_id BIGINT NOT NULL,
    index INTEGER NOT NULL,
    network TEXT NOT NULL,

    spent_tx_id BIGINT NOT NULL,
    spent_slot_no BIGINT NOT NULL,

    PRIMARY KEY (tx_id, index, network),
    FOREIGN KEY (tx_id, index, network) REFERENCES utxo (tx_id, index, network),
    FOREIGN KEY (spent_slot_no, network) REFERENCES slot_index (slot_no, network)
);

CREATE INDEX cardano_stxo_slot_idx ON stxo (spent_slot_no, network);

-- -------------------------------------------------------------------------------------------------

-- Rewards Table -- Earned Rewards
-- Populated with this query from db-sync
--    SELECT stake_address.hash_raw as stake_credential, reward.earned_epoch as earned_epoch_no, reward.amount as value FROM reward
--              INNER JOIN stake_address ON stake_address.id = reward.addr_id
--              INNER JOIN epoch ON epoch.id = reward.earned_epoch;
-- `slot_no` needs to be calculated from the current earned_epoch_no as the first slot in the next epoch.
-- 'network' needs to be supplied, as dbsync only has a single database per network.
CREATE TABLE cardano_reward (
    slot_no BIGINT NOT NULL, -- First slot of the epoch following the epoch the rewards were earned for.
    network TEXT NOT NULL,
    stake_credential BYTEA NOT NULL,

    earned_epoch_no BIGINT NOT NULL,

    value BIGINT NOT NULL,

    PRIMARY KEY (slot_no, network, stake_credential),
    FOREIGN KEY (slot_no, network) REFERENCES slot_index (slot_no, network)
);

CREATE INDEX cardano_rewards_stake_credential_idx ON cardano_rewards (stake_credential);
CREATE INDEX cardano_rewards_stake_credential_slot_idx ON cardano_rewards (stake_credential, slot_no);

-- -------------------------------------------------------------------------------------------------

-- Withdrawn Rewards Table -- Withdrawn Rewards
-- Populated with this query from db-sync
--      SELECT block.slot_no, stake_address.hash_raw as stake_credential, withdrawal.amount as value from withdrawal
--              INNER JOIN tx ON withdrawal.tx_id = tx.id
--              INNER JOIN block ON tx.block_id = block.id
--              INNER JOIN stake_address ON stake_address.id = withdrawal.addr_id;
-- 'network' needs to be supplied, as dbsync only has a single database per network.
CREATE TABLE cardano_withdrawn_reward (
    slot_no BIGINT NOT NULL,
    network TEXT NOT NULL,
    stake_credential BYTEA NOT NULL,
    value BIGINT NOT NULL,

    PRIMARY KEY (slot_no, network),
    FOREIGN KEY (slot_no, network) REFERENCES slot_index (slot_no, network)
);

-- -------------------------------------------------------------------------------------------------

-- Cardano Voter Registrations Table -- Voter Registrations
-- Populated with this query from db-sync
--      SELECT tx.hash as txn_hash, block.slot_no, tx.id as tx_id, tx_61284.bytes as metadata_61284, tx_61285.bytes as metadata_61285 from tx
--          INNER JOIN block ON tx.block_id = block.id
--          LEFT JOIN tx_metadata as tx_61284 ON tx.id = tx_61284.tx_id AND tx_61284.key = 61284
--          LEFT JOIN tx_metadata as tx_61285 ON tx.id = tx_61285.tx_id AND tx_61285.key = 61285
--          WHERE tx_61285.bytes is not null or tx_61284.bytes is not null;
--
-- 'network' needs to be supplied, as dbsync only has a single database per network.
CREATE TABLE cardano_voter_registration (
    txn_hash BYTEA PRIMARY KEY NOT NULL,

    slot_no BIGINT NULL,
    tx_id BIGINT NULL,
    network TEXT NOT NULL,

    stake_credential BYTEA NULL,
    public_voting_key BYTEA NULL,
    payment_address BYTEA NULL,
    nonce BIGINT NULL,

    metadata_61284 BYTEA NULL,  -- We can purge metadata for valid registrations that are old to save storage space. 
    metadata_61285 BYTEA NULL,  -- We can purge metadata for valid registrations that are old to save storage space.

    valid BOOLEAN NOT NULL DEFAULT false,
    stats JSONB NULL,
    -- record rolled back in stats if the registration was lost during a rollback, its also invalid at this point.
    -- Other stats we can record are is it a CIP-36 or CIP-15 registration format.
    -- does it have a valid reward address but not a payment address, so we can't pay to it.
    -- other flags about why the registration was invalid.
    -- other flags about statistical data (if any).

    FOREIGN KEY (slot_no, network) REFERENCES slot_index (slot_no, network)
);

CREATE INDEX cardano_voter_registration_stake_credential_idx ON cardano_voter_registration (
    stake_credential, nonce, valid
);
COMMENT ON INDEX cardano_voter_registration_stake_credential_idx IS
'Optimize lookups for "stake_credential" or "stake_credential"+"nonce" or "stake_credential"+"nonce"+"valid".';

CREATE INDEX cardano_voter_registration_voting_key_idx ON cardano_voter_registration (public_voting_key, nonce, valid);
COMMENT ON INDEX cardano_voter_registration_voting_key_idx IS
'Optimize lookups for "public_voting_key" or "public_voting_key"+"nonce" or "public_voting_key"+"nonce"+"valid".';

COMMENT ON TABLE cardano_voter_registrations IS
'All CIP15/36 Voter Registrations that are on-chain.
This tables tores all found registrations, even if they are invalid, or have been rolled back.';

COMMENT ON COLUMN cardano_voter_registration.txn_hash IS
'The Transaction hash of the Transaction holding the registration metadata.';

COMMENT ON COLUMN snapshot.as_at IS
'The time the snapshot was collected from dbsync.
This is the snapshot *DEADLINE*, i.e the time when registrations are final.
(Should be the slot time the dbsync_snapshot_cmd was run against.)';
COMMENT ON COLUMN snapshot.last_updated IS
'The last time the snapshot was run
(Should be the latest block time taken from dbsync just before the snapshot was run.)';
COMMENT ON COLUMN snapshot.final IS
'Is the snapshot Final?
No more updates will occur to this record once set.';

COMMENT ON COLUMN snapshot.dbsync_snapshot_cmd IS 'The name of the command run to collect the snapshot from dbsync.';
COMMENT ON COLUMN snapshot.dbsync_snapshot_params IS 'The parameters passed to the command, each parameter is a key and its value is the value of the parameter.';
COMMENT ON COLUMN snapshot.dbsync_snapshot_data IS
'The BROTLI COMPRESSED raw json result stored as BINARY from the dbsync snapshot.
(This is JSON data but we store as raw text to prevent any processing of it, and BROTLI compress to save space).';
COMMENT ON COLUMN snapshot.dbsync_snapshot_error IS
'The BROTLI COMPRESSED raw json errors stored as BINARY from the dbsync snapshot.
(This is JSON data but we store as raw text to prevent any processing of it, and BROTLI compress to save space).';
COMMENT ON COLUMN snapshot.dbsync_snapshot_unregistered IS
'The BROTLI COMPRESSED unregistered voting power stored as BINARY from the dbsync snapshot.
(This is JSON data but we store as raw text to prevent any processing of it, and BROTLI compress to save space).';

COMMENT ON COLUMN snapshot.drep_data IS
'The latest drep data obtained from GVC, and used in this snapshot calculation.
Should be in a form directly usable by the `catalyst_snapshot_cmd`
However, in order to save space this data is stored as BROTLI COMPRESSED BINARY.';

COMMENT ON COLUMN snapshot.catalyst_snapshot_cmd IS 'The actual name of the command run to produce the catalyst voting power snapshot.';
COMMENT ON COLUMN snapshot.dbsync_snapshot_params IS 'The parameters passed to the command, each parameter is a key and its value is the value of the parameter.';
COMMENT ON COLUMN snapshot.catalyst_snapshot_data IS
'The BROTLI COMPRESSED raw yaml result stored as BINARY from the catalyst snapshot calculation.
(This is YAML data but we store as raw text to prevent any processing of it, and BROTLI compress to save space).';

-- voters

CREATE TABLE voter (
    row_id SERIAL8 PRIMARY KEY,

    voting_key TEXT NOT NULL,
    snapshot_id INTEGER NOT NULL,
    voting_group TEXT NOT NULL,

    voting_power BIGINT NOT NULL,

    FOREIGN KEY (snapshot_id) REFERENCES snapshot (row_id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX unique_voter_id ON voter (voting_key, voting_group, snapshot_id);

COMMENT ON TABLE voter IS 'Voting Power for every voting key.';
COMMENT ON COLUMN voter.voting_key IS 'Either the voting key.';
COMMENT ON COLUMN voter.snapshot_id IS 'The ID of the snapshot this record belongs to.';
COMMENT ON COLUMN voter.voting_group IS 'The voter group the voter belongs to.';
COMMENT ON COLUMN voter.voting_power IS 'Calculated Voting Power associated with this key.';

-- contributions

CREATE TABLE contribution (
    row_id SERIAL8 PRIMARY KEY,

    stake_public_key TEXT NOT NULL,
    snapshot_id INTEGER NOT NULL,

    voting_key TEXT NULL,
    voting_weight INTEGER NULL,
    voting_key_idx INTEGER NULL,
    value BIGINT NOT NULL,

    voting_group TEXT NOT NULL,

    -- each unique stake_public_key should have the same reward_address
    reward_address TEXT NULL,

    FOREIGN KEY (snapshot_id) REFERENCES snapshot (row_id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX unique_contribution_id ON contribution (stake_public_key, voting_key, voting_group, snapshot_id);

COMMENT ON TABLE contribution IS 'Individual Contributions from stake public keys to voting keys.';
COMMENT ON COLUMN contribution.row_id IS 'Synthetic Unique Row Key';
COMMENT ON COLUMN contribution.stake_public_key IS 'The voters Stake Public Key';
COMMENT ON COLUMN contribution.snapshot_id IS 'The snapshot this contribution was recorded from.';

COMMENT ON COLUMN contribution.voting_key IS 'The voting key.  If this is NULL it is the raw staked ADA.';
COMMENT ON COLUMN contribution.voting_weight IS 'The weight this voting key gets of the total.';
COMMENT ON COLUMN contribution.voting_key_idx IS 'The index from 0 of the keys in the delegation array.';
COMMENT ON COLUMN contribution.value IS 'The amount of ADA contributed to this voting key from the stake address';

COMMENT ON COLUMN contribution.voting_group IS 'The group this contribution goes to.';

COMMENT ON COLUMN contribution.reward_address IS 'Currently Unused.  Should be the Stake Rewards address of the voter (currently unknown.)';
