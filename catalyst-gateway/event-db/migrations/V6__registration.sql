-- Catalyst Voices Database - Role Registration Data
-- sqlfluff:dialect:postgres

-- Title : Role Registration Data

-- cspell: words utxo stxo
-- Configuration Tables

-- -------------------------------------------------------------------------------------------------

-- cardano update state table.
-- Keeps a record of each update to the Role Registration state data.
-- Used internally to track the updates to the database.
CREATE TABLE cardano_update_state (

  id BIGSERIAL PRIMARY KEY,
  time TIMESTAMP NOT NULL,
  end_time TIMESTAMP NOT NULL,
  updater_id TEXT NOT NULL,

  network TEXT NOT NULL,

  old_max_slot_no BIGINT NOT NULL,
  new_max_slot_no BIGINT NOT NULL,
  rollback_slot_no BIGINT NOT NULL,

  stats JSONB NOT NULL
);

CREATE INDEX cardano_update_state_idx ON cardano_update_state (id, network);

COMMENT ON INDEX cardano_update_state_idx IS
'Index to allow us to efficiently get find an update state record by its id.
This index can be used to find the latest state record for a particular network.';

CREATE INDEX cardano_update_state_time_idx ON cardano_update_state (
  time, network
);

COMMENT ON INDEX cardano_update_state_time_idx IS
'Index to allow us to efficiently get find an update state record by time for a particular network.';


COMMENT ON TABLE cardano_update_state IS
'A record of the updates to the Cardano Registration data state.
Every time the state is updated, a new record is created.
This table also serves as a central lock source for updates to the registration state which must be atomic.
Should be accessed with a pattern like:

```sql
    BEGIN;
        LOCK TABLE cardano_update_state IN ACCESS EXCLUSIVE MODE;
        -- Read state, update any other tables as needed
        INSERT INTO cardano_update_state SET ...;  -- Set latest state
    COMMIT;
```
';

COMMENT ON COLUMN cardano_update_state.id IS
'Sequential ID of successive updates to the registration state data.';
COMMENT ON COLUMN cardano_update_state.time IS
'The time the update started for this network.';
COMMENT ON COLUMN cardano_update_state.end_time IS
'The time the update was complete for this network.';
COMMENT ON COLUMN cardano_update_state.updater_id IS
'The ID of the node which performed the update.  
This helps us track which instance of the backend did which updates.';
COMMENT ON COLUMN cardano_update_state.network IS
'The Cardano network that was updated.  
Updates occur together, so all active networks will get an individual record when an update runs.  
This occurs in a single transaction.';
COMMENT ON COLUMN cardano_update_state.old_max_slot_no IS
'The previous TIP slot_no when this update was run.';
COMMENT ON COLUMN cardano_update_state.new_max_slot_no IS
'The current TIP slot_no when this update was run.';
COMMENT ON COLUMN cardano_update_state.rollback_slot_no IS
'The slot_no at which the oldest change occurred between updates.
This signifies a rollback has been detected and tracks how far back the rollback went.';
COMMENT ON COLUMN cardano_update_state.stats IS
'A JSON stats record containing extra data about this update.
Must conform to Schema: `catalyst_schema://0f917b13-afac-40d2-8263-b17ca8219914/registration/update_stats`.';

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
COMMENT ON INDEX slot_index_time_idx IS
'Index to allow us to efficiently lookup a slot by time for a particular network.';

CREATE INDEX slot_index_epoch_idx ON slot_index (epoch_no, network);
COMMENT ON INDEX slot_index_epoch_idx IS
'Index to allow us to efficiently lookup a slot by epoch for a particular network.';

COMMENT ON TABLE slot_index IS
'This is an index of cardano blockchain slots.
It allows us to quickly find data about every block in the cardano network.';

COMMENT ON COLUMN slot_index.slot_no IS
'The slot number of the block. 
This is the first half of the Primary key.';
COMMENT ON COLUMN slot_index.network IS
'The Cardano network for this slot. 
This is the second half of the primary key, as each network could use th same slot numbers.';
COMMENT ON COLUMN slot_index.epoch_no IS
'The epoch number the slot appeared in.';
COMMENT ON COLUMN slot_index.time IS
'The time of the slot.';
COMMENT ON COLUMN slot_index.block_hash IS
'The hash of the block.';

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

  spent_slot_no BIGINT NULL,
  spent_tx_id BIGINT NULL,

  PRIMARY KEY (tx_id, index, network),
  FOREIGN KEY (slot_no, network) REFERENCES slot_index (slot_no, network),
  FOREIGN KEY (spent_slot_no, network) REFERENCES slot_index (slot_no, network)

);

CREATE INDEX cardano_utxo_stake_credential_idx ON cardano_utxo (
  stake_credential, slot_no
);
COMMENT ON INDEX cardano_utxo_stake_credential_idx IS
'Index to allow us to efficiently lookup a set of UTXOs by stake credential relative to a slot_no.';

CREATE INDEX cardano_stxo_slot_idx ON cardano_utxo (spent_slot_no, network);

COMMENT ON INDEX cardano_stxo_slot_idx IS
'Index to allow us to efficiently lookup a set of Spent TX Outputs by slot_no.';


COMMENT ON TABLE cardano_utxo IS
'This table holds all UTXOs for any transaction which is tied to a stake address.
This data allows us to calculate staked ADA at any particular instant in time.';

COMMENT ON COLUMN cardano_utxo.tx_id IS
'The ID of the transaction containing the UTXO.';
COMMENT ON COLUMN cardano_utxo.index IS
'The index of the UTXO within the transaction.';
COMMENT ON COLUMN cardano_utxo.network IS
'The Cardano network for this UTXO. 
This is the second half of the primary key, as each network could use th same UTXOs.';
COMMENT ON COLUMN cardano_utxo.value IS
'The value of the UTXO, in Lovelace';
COMMENT ON COLUMN cardano_utxo.slot_no IS
'The slot number the UTXO appeared in.';
COMMENT ON COLUMN cardano_utxo.stake_credential IS
'The stake credential of the address which owns the UTXO.';
COMMENT ON COLUMN cardano_utxo.spent_tx_id IS
'The ID of the transaction which Spent the TX Output.';
COMMENT ON COLUMN cardano_utxo.spent_slot_no IS
'The slot number the TX Output was spent in.
This lets us determine when the TX Output was spent, so we can calculate staked ada at a particular slot.';



-- -------------------------------------------------------------------------------------------------

-- Rewards Table -- Earned Rewards
-- Populated with this query from db-sync
--    SELECT stake_address.hash_raw as stake_credential, reward.earned_epoch as earned_epoch_no, 
--           reward.amount as value FROM reward
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

CREATE INDEX cardano_rewards_stake_credential_idx ON cardano_reward (
  stake_credential, slot_no
);

COMMENT ON INDEX cardano_rewards_stake_credential_idx IS
'Index to allow us to efficiently lookup a set of Rewards by stake credential relative to a slot_no.';

COMMENT ON TABLE cardano_reward IS
'This table holds all earned rewards per stake address.
It is possible for a Stake Address to earn multiple rewards in the same epoch.
This record contains the Total of all rewards earned in the relevant epoch.';

COMMENT ON COLUMN cardano_reward.slot_no IS
'The slot number the rewards were earned for.
This is the first slot of the epoch following the epoch the rewards were earned for.';
COMMENT ON COLUMN cardano_reward.network IS
'The Cardano network for this rewards.';
COMMENT ON COLUMN cardano_reward.stake_credential IS
'The stake credential of the address who earned the rewards.';
COMMENT ON COLUMN cardano_reward.earned_epoch_no IS
'The epoch number the rewards were earned for.';
COMMENT ON COLUMN cardano_reward.value IS
'The value of the reward earned, in Lovelace';

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

COMMENT ON TABLE cardano_withdrawn_reward IS
'This table holds all withdrawn rewards data.
This makes it possible to accurately calculate the rewards which are still available for a specific Stake Address .';

COMMENT ON COLUMN cardano_withdrawn_reward.slot_no IS
'The slot number the rewards were withdrawn for.';
COMMENT ON COLUMN cardano_withdrawn_reward.network IS
'The Cardano network this withdrawal occurred on.';
COMMENT ON COLUMN cardano_withdrawn_reward.stake_credential IS
'The stake credential of the address who earned the rewards.';
COMMENT ON COLUMN cardano_withdrawn_reward.value IS
'The value of the reward withdrawn, in Lovelace';

-- -------------------------------------------------------------------------------------------------

-- Cardano Voter Registrations Table -- Voter Registrations
-- Populated with this query from db-sync
--      SELECT tx.hash as txn_hash, block.slot_no, tx.id as tx_id, tx_61284.bytes as metadata_61284, 
--             tx_61285.bytes as metadata_61285 from tx
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

CREATE INDEX cardano_voter_registration_voting_key_idx ON cardano_voter_registration (
  public_voting_key, nonce, valid
);
COMMENT ON INDEX cardano_voter_registration_voting_key_idx IS
'Optimize lookups for "public_voting_key" or "public_voting_key"+"nonce" or "public_voting_key"+"nonce"+"valid".';

COMMENT ON TABLE cardano_voter_registration IS
'All CIP15/36 Voter Registrations that are on-chain.
This tables stores all found registrations, even if they are invalid, or have been rolled back.';

COMMENT ON COLUMN cardano_voter_registration.txn_hash IS
'The Transaction hash of the Transaction holding the registration metadata.
This is used as the Primary Key because it is immutable in the face of potential rollbacks.';
COMMENT ON COLUMN cardano_voter_registration.slot_no IS
'The slot number the registration was published in.';
COMMENT ON COLUMN cardano_voter_registration.tx_id IS
'The id of the Transaction holding the registration metadata is held in.';
COMMENT ON COLUMN cardano_voter_registration.network IS
'The Cardano network this registration occurred on.';
COMMENT ON COLUMN cardano_voter_registration.stake_credential IS
'The stake credential of the address who registered.';
COMMENT ON COLUMN cardano_voter_registration.public_voting_key IS
'The public voting key of the address who registered.';
COMMENT ON COLUMN cardano_voter_registration.payment_address IS
'The payment address where any voter rewards associated with this registration will be sent.';
COMMENT ON COLUMN cardano_voter_registration.nonce IS
'The nonce of the registration.  Registrations for the same stake address with higher nonces have priority.';
COMMENT ON COLUMN cardano_voter_registration.metadata_61284 IS
'The raw metadata for the CIP-15/36 registration.
This data is optional, a parameter in config specifies how long raw registration metadata should be kept.
Outside this time, the Registration record will be kept, but the raw metadata will be purged.';
COMMENT ON COLUMN cardano_voter_registration.metadata_61285 IS
'The metadata for the CIP-15/36 registration signature.
This data is optional, a parameter in config specifies how long signature metadata should be kept.
Outside this time, the Registration record will be kept, but the signature metadata will be purged.';
COMMENT ON COLUMN cardano_voter_registration.valid IS
'True if the registration is valid, false if the registration is invalid.
`stats` can be checked to determine WHY the registration is considered invalid.';
COMMENT ON COLUMN cardano_voter_registration.stats IS
'Statistical information about the registration.
Must conform to Schema: `catalyst_schema://fd5a2f8f-afb4-4cf7-ae6b-b7a370c85c82/registration/cip36_stats';
