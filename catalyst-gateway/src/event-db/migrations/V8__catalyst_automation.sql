-- Catalyst Event Database

-- Voting Nodes Table - Defines nodes in the network
-- This table is looked up by hostname and event
CREATE TABLE voting_node (
    hostname TEXT NOT NULL,
    event INTEGER NOT NULL,

    pubkey TEXT NOT NULL,
    seckey TEXT NOT NULL,
    netkey TEXT NOT NULL,

    PRIMARY KEY (hostname, event),
    FOREIGN KEY(event) REFERENCES event(row_id)  ON DELETE CASCADE
);

COMMENT ON TABLE voting_node IS
'This table holds information for all nodes in the event.
It is used by nodes to self-bootstrap the blockchain.';
COMMENT ON COLUMN voting_node.hostname IS 'Unique hostname for the voting node.';
COMMENT ON COLUMN voting_node.event IS 'Unique event this node was configured for.';
COMMENT ON COLUMN voting_node.seckey IS 'Encrypted secret key from Ed25519 pair for the node. Used as the node secret.';
COMMENT ON COLUMN voting_node.pubkey IS 'Public key from Ed25519 pair for the node. Used as consensus_leader_id when the node is a leader.';
COMMENT ON COLUMN voting_node.netkey IS 'Encrypted Ed25519 secret key for the node. Used as the node p2p topology key.';


-- Tally Committee Table - Stores data about the tally committee per voting event
-- This table is looked up by event
CREATE TABLE tally_committee (
    row_id SERIAL PRIMARY KEY,

    event INTEGER NOT NULL UNIQUE,

    committee_pk TEXT NOT NULL,
    committee_id TEXT NOT NULL,
    member_crs TEXT,
    election_key TEXT,

    FOREIGN KEY(event) REFERENCES event(row_id)  ON DELETE CASCADE
);

COMMENT ON TABLE tally_committee IS 'Table for storing data about the tally committee per voting event.';
COMMENT ON COLUMN tally_committee.row_id IS 'Unique ID for this committee member for this event.';
COMMENT ON COLUMN tally_committee.event  IS 'The event this committee member is for.';
COMMENT ON COLUMN tally_committee.committee_pk  IS 'Encrypted private key for the committee wallet. This key can be used to get the committee public address.';
COMMENT ON COLUMN tally_committee.committee_id  IS 'The hex-encoded public key for the committee wallet.';
COMMENT ON COLUMN tally_committee.member_crs  IS 'Encrypted Common Reference String shared in the creation of every set of committee member keys.';
COMMENT ON COLUMN tally_committee.election_key  IS 'Public key generated with all committee member public keys, and is used to encrypt votes. NULL if the event.committee_size is 0.';


-- Committee Member Table - Stores data about the tally committee members
-- This table is looked up by committee
CREATE TABLE committee_member (
    row_id SERIAL PRIMARY KEY,

    committee INTEGER NOT NULL,

    member_index INTEGER NOT NULL,
    threshold INTEGER NOT NULL,
    comm_pk TEXT NOT NULL,
    comm_sk TEXT NOT NULL,
    member_pk TEXT NOT NULL,
    member_sk TEXT NOT NULL,

    FOREIGN KEY(committee) REFERENCES tally_committee(row_id)
);

COMMENT ON TABLE committee_member IS 'Table for storing data about the tally committee members.';
COMMENT ON COLUMN committee_member.row_id IS 'Unique ID for this committee member for this event.';
COMMENT ON COLUMN committee_member.member_index IS 'the zero-based index of the member, ranging from 0 <= index < committee_size.';
COMMENT ON COLUMN committee_member.committee IS 'The committee this member belongs to.';
COMMENT ON COLUMN committee_member.comm_pk  IS 'Committee member communication public key.';
COMMENT ON COLUMN committee_member.comm_sk  IS 'Encrypted committee member communication secret key.';
COMMENT ON COLUMN committee_member.member_pk  IS 'Committee member public key';
COMMENT ON COLUMN committee_member.member_sk  IS 'Encrypted committee member secret key';
