-- Catalyst Event Database - VIT-SS Compatibility

-- vote storage (replicates on-chain data for easy querying)

CREATE TABLE ballot (
    row_id SERIAL8 PRIMARY KEY,
    objective      INTEGER NOT NULL,
    proposal       INTEGER NULL,

    voter          INTEGER NOT NULL,
    fragment_id    TEXT NOT NULL,
    cast_at        TIMESTAMP NOT NULL,
    choice         SMALLINT NULL,
    raw_fragment   BYTEA    NOT NULL,

    FOREIGN KEY(voter)               REFERENCES voter(row_id)  ON DELETE CASCADE,
    FOREIGN KEY(objective)           REFERENCES objective(row_id)  ON DELETE CASCADE,
    FOREIGN KEY(proposal)            REFERENCES proposal(row_id)  ON DELETE CASCADE
);

CREATE UNIQUE INDEX ballot_proposal_idx  ON ballot(proposal,fragment_id);
CREATE UNIQUE INDEX ballot_objective_idx ON ballot(objective,fragment_id);

COMMENT ON TABLE ballot IS 'All Ballots cast on an event.';
COMMENT ON COLUMN ballot.fragment_id is 'Unique ID of this Ballot';
COMMENT ON COLUMN ballot.voter is 'Reference to the Voter who cast the ballot';
COMMENT ON COLUMN ballot.objective is 'Reference to the Objective the ballot was for.';
COMMENT ON COLUMN ballot.proposal is
'Reference to the Proposal the ballot was for.
May be NULL if this ballot covers ALL proposals in the challenge.';
COMMENT ON COLUMN ballot.cast_at is 'When this ballot was recorded as properly cast';
COMMENT ON COLUMN ballot.choice is 'If a public vote, the choice on the ballot, otherwise NULL.';
COMMENT ON COLUMN ballot.raw_fragment is 'The raw ballot record.';
