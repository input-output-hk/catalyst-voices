-- Catalyst Event Database - Vote Storage

-- Title : Vote Storage

-- vote storage (replicates on-chain data for easy querying)

CREATE TABLE ballot (
  row_id SERIAL8 PRIMARY KEY,
  objective INTEGER NOT NULL,
  proposal INTEGER NULL,

  voter BYTEA NOT NULL,
  fragment_id TEXT NOT NULL,
  cast_at TIMESTAMP NOT NULL,
  choice SMALLINT NULL,
  raw_fragment BYTEA NOT NULL,

  FOREIGN KEY (objective) REFERENCES objective (row_id) ON DELETE CASCADE,
  FOREIGN KEY (proposal) REFERENCES proposal (row_id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX ballot_proposal_idx ON ballot (proposal, fragment_id);
CREATE UNIQUE INDEX ballot_objective_idx ON ballot (objective, fragment_id);

COMMENT ON TABLE ballot IS 'All Ballots cast on an event.';
COMMENT ON COLUMN ballot.fragment_id IS 'Unique ID of this Ballot';
COMMENT ON COLUMN ballot.voter IS 'Voters Voting Key who cast the ballot';
COMMENT ON COLUMN ballot.objective IS 'Reference to the Objective the ballot was for.';
COMMENT ON COLUMN ballot.proposal IS
'Reference to the Proposal the ballot was for.
May be NULL if this ballot covers ALL proposals in the challenge.';
COMMENT ON COLUMN ballot.cast_at IS 'When this ballot was recorded as properly cast';
COMMENT ON COLUMN ballot.choice IS 'If a public vote, the choice on the ballot, otherwise NULL.';
COMMENT ON COLUMN ballot.raw_fragment IS 'The raw ballot record.';
