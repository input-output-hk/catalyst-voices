CREATE TABLE IF NOT EXISTS cardano_networks (
    id   SMALLINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS cardano_networks_name ON cardano_networks USING BTREE(name);

INSERT INTO cardano_networks (name) VALUES ('mainnet') ON CONFLICT (name) DO NOTHING;
INSERT INTO cardano_networks (name) VALUES ('preprod') ON CONFLICT (name) DO NOTHING;

CREATE TABLE IF NOT EXISTS cardano_blocks (
    block_no      BIGINT NOT NULL,
    slot_no       BIGINT NOT NULL,
    epoch_no      BIGINT NOT NULL,
    network_id    SMALLINT NOT NULL,
    block_time    TIMESTAMP WITH TIME ZONE NOT NULL,
    block_hash    BYTEA NOT NULL,
    previous_hash BYTEA
);

CREATE TABLE IF NOT EXISTS cardano_transactions (
    hash       BYTEA NOT NULL,
    block_no   BIGINT NOT NULL,
    network_id SMALLINT NOT NULL
);

CREATE TABLE IF NOT EXISTS cardano_txo (
    transaction_hash BYTEA NOT NULL,
    index            INTEGER NOT NULL,
    value            BIGINT NOT NULL,
    assets           JSONB,
    stake_credential BYTEA
);

CREATE TABLE IF NOT EXISTS cardano_spent_txo (
    from_transaction_hash BYTEA NOT NULL,
    index                 INTEGER NOT NULL,
    to_transaction_hash   BYTEA NOT NULL
);
