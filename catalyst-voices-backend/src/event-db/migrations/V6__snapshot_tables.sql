-- Catalyst Event Database

-- Voting Power Snapshot Table

CREATE TABLE snapshot (
    row_id SERIAL PRIMARY KEY,
    event INTEGER NOT NULL UNIQUE,
    as_at TIMESTAMP NOT NULL,
    as_at_slotno INTEGER NOT NULL,
    last_updated TIMESTAMP NOT NULL,
    last_updated_slotno INTEGER NOT NULL,

    final BOOLEAN NOT NULL,

    dbsync_snapshot_cmd          TEXT NULL,
    dbsync_snapshot_params       JSONB NULL,
    dbsync_snapshot_data         BYTEA NULL,
    dbsync_snapshot_error        BYTEA NULL,
    dbsync_snapshot_unregistered BYTEA NULL,

    drep_data                    BYTEA NULL,

    catalyst_snapshot_cmd        TEXT NULL,
    catalyst_snapshot_params     JSONB NULL,
    catalyst_snapshot_data       BYTEA NULL,

    FOREIGN KEY(event) REFERENCES event(row_id)  ON DELETE CASCADE
);

COMMENT ON TABLE snapshot IS
'Raw snapshot data for an event.
Only the latests snapshot per event is stored.';
COMMENT ON COLUMN snapshot.event is 'The event id this snapshot was for.';
COMMENT ON COLUMN snapshot.as_at is
'The time the snapshot was collected from dbsync.
This is the snapshot *DEADLINE*, i.e the time when registrations are final.
(Should be the slot time the dbsync_snapshot_cmd was run against.)';
COMMENT ON COLUMN snapshot.last_updated is
'The last time the snapshot was run
(Should be the latest block time taken from dbsync just before the snapshot was run.)';
COMMENT ON COLUMN snapshot.final is
'Is the snapshot Final?
No more updates will occur to this record once set.';

COMMENT ON COLUMN snapshot.dbsync_snapshot_cmd is     'The name of the command run to collect the snapshot from dbsync.';
COMMENT ON COLUMN snapshot.dbsync_snapshot_params is  'The parameters passed to the command, each parameter is a key and its value is the value of the parameter.';
COMMENT ON COLUMN snapshot.dbsync_snapshot_data is
'The BROTLI COMPRESSED raw json result stored as BINARY from the dbsync snapshot.
(This is JSON data but we store as raw text to prevent any processing of it, and BROTLI compress to save space).';
COMMENT ON COLUMN snapshot.dbsync_snapshot_error is
'The BROTLI COMPRESSED raw json errors stored as BINARY from the dbsync snapshot.
(This is JSON data but we store as raw text to prevent any processing of it, and BROTLI compress to save space).';
COMMENT ON COLUMN snapshot.dbsync_snapshot_unregistered is
'The BROTLI COMPRESSED unregistered voting power stored as BINARY from the dbsync snapshot.
(This is JSON data but we store as raw text to prevent any processing of it, and BROTLI compress to save space).';

COMMENT ON COLUMN snapshot.drep_data is
'The latest drep data obtained from GVC, and used in this snapshot calculation.
Should be in a form directly usable by the `catalyst_snapshot_cmd`
However, in order to save space this data is stored as BROTLI COMPRESSED BINARY.';

COMMENT ON COLUMN snapshot.catalyst_snapshot_cmd is  'The actual name of the command run to produce the catalyst voting power snapshot.';
COMMENT ON COLUMN snapshot.dbsync_snapshot_params is 'The parameters passed to the command, each parameter is a key and its value is the value of the parameter.';
COMMENT ON COLUMN snapshot.catalyst_snapshot_data is
'The BROTLI COMPRESSED raw yaml result stored as BINARY from the catalyst snapshot calculation.
(This is YAML data but we store as raw text to prevent any processing of it, and BROTLI compress to save space).';

-- voters

CREATE TABLE voter (
    row_id SERIAL8 PRIMARY KEY,

    voting_key TEXT NOT NULL,
    snapshot_id INTEGER NOT NULL,
    voting_group TEXT NOT NULL,

    voting_power BIGINT NOT NULL,

    FOREIGN KEY(snapshot_id) REFERENCES snapshot(row_id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX unique_voter_id on voter (voting_key, voting_group, snapshot_id);

COMMENT ON TABLE voter IS 'Voting Power for every voting key.';
COMMENT ON COLUMN voter.voting_key is 'Either the voting key.';
COMMENT ON COLUMN voter.snapshot_id is 'The ID of the snapshot this record belongs to.';
COMMENT ON COLUMN voter.voting_group is 'The voter group the voter belongs to.';
COMMENT ON COLUMN voter.voting_power is 'Calculated Voting Power associated with this key.';

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

    FOREIGN KEY(snapshot_id) REFERENCES snapshot(row_id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX unique_contribution_id ON contribution (stake_public_key, voting_key, voting_group, snapshot_id);

COMMENT ON TABLE contribution IS 'Individual Contributions from stake public keys to voting keys.';
COMMENT ON COLUMN contribution.row_id is 'Synthetic Unique Row Key';
COMMENT ON COLUMN contribution.stake_public_key IS 'The voters Stake Public Key';
COMMENT ON COLUMN contribution.snapshot_id IS 'The snapshot this contribution was recorded from.';

COMMENT ON COLUMN contribution.voting_key IS 'The voting key.  If this is NULL it is the raw staked ADA.';
COMMENT ON COLUMN contribution.voting_weight IS 'The weight this voting key gets of the total.';
COMMENT ON COLUMN contribution.voting_key_idx IS 'The index from 0 of the keys in the delegation array.';
COMMENT ON COLUMN contribution.value IS 'The amount of ADA contributed to this voting key from the stake address';

COMMENT ON COLUMN contribution.voting_group IS 'The group this contribution goes to.';

COMMENT ON COLUMN contribution.reward_address IS 'Currently Unused.  Should be the Stake Rewards address of the voter (currently unknown.)';
