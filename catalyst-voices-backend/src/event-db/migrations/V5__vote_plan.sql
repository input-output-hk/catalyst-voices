-- Catalyst Event Database

-- Vote Plan Categories

CREATE TABLE voteplan_category
(
    name TEXT PRIMARY KEY,
    public_key BOOL
);


INSERT INTO voteplan_category (name, public_key)
VALUES
    ('public', false), -- Fully public votes only
    ('private', true), -- Fully private votes only.
    ('cast-private', true); -- Private until tally, then decrypted.

COMMENT ON TABLE voteplan_category IS 'The category of vote plan currently supported.';
COMMENT ON COLUMN voteplan_category.name IS 'The UNIQUE name of this voteplan category.';
COMMENT ON COLUMN voteplan_category.public_key IS 'Does this vote plan category require a public key.';


-- groups

CREATE TABLE voting_group (
    name TEXT PRIMARY KEY
);

INSERT INTO voting_group (name)
VALUES
    ('direct'), -- Direct Voters
    ('rep'); -- Delegated Voter (Check what is the real name for this group we already use in snapshot)

COMMENT ON TABLE voting_group IS 'All Groups.';
COMMENT ON COLUMN voting_group.name IS 'The ID of this voting group.';

-- Vote Plans

CREATE TABLE voteplan
(
    row_id SERIAL PRIMARY KEY,
    objective_id INTEGER NOT NULL,

    id VARCHAR NOT NULL,
    category TEXT NOT NULL,
    encryption_key VARCHAR,
    group_id TEXT,
    token_id TEXT,

    FOREIGN KEY(objective_id) REFERENCES objective(row_id)  ON DELETE CASCADE,
    FOREIGN KEY(category) REFERENCES voteplan_category(name)  ON DELETE CASCADE,
    FOREIGN KEY(group_id) REFERENCES voting_group(name)  ON DELETE CASCADE
);

COMMENT ON TABLE voteplan IS 'All Vote plans.';

COMMENT ON COLUMN voteplan.row_id IS 'Synthetic Unique Key';
COMMENT ON COLUMN voteplan.id IS
'The ID of the Vote plan in the voting ledger/bulletin board.
A Binary value encoded as hex.';
COMMENT ON COLUMN voteplan.category IS 'The kind of vote which can be cast on this vote plan.';
COMMENT ON COLUMN voteplan.encryption_key IS
'The public encryption key used.
ONLY if required by the voteplan category.';
COMMENT ON COLUMN voteplan.group_id IS 'The identifier of voting power token used withing this plan.';

-- Table to link Proposals to Vote plans in a many-many relationship.
-- This Many-Many relationship arises because:
--  in the vote ledger/bulletin board,
--      one proposal may be within multiple different vote plans,
--      and each voteplan can contain multiple proposals.
CREATE TABLE proposal_voteplan
(
    row_id SERIAL PRIMARY KEY,
    proposal_id INTEGER,
    voteplan_id INTEGER,
    bb_proposal_index BIGINT,

    FOREIGN KEY(proposal_id) REFERENCES proposal(row_id) ON DELETE CASCADE,
    FOREIGN KEY(voteplan_id) REFERENCES voteplan(row_id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX proposal_voteplan_idx ON proposal_voteplan(proposal_id,voteplan_id,bb_proposal_index);

COMMENT ON TABLE proposal_voteplan IS 'Table to link Proposals to Vote plans in a Many to Many relationship.';
COMMENT ON COLUMN proposal_voteplan.row_id IS 'Synthetic ID of this Voteplan/Proposal M-M relationship.';
COMMENT ON COLUMN proposal_voteplan.proposal_id IS 'The link to the Proposal primary key that links to this voteplan.';
COMMENT ON COLUMN proposal_voteplan.voteplan_id IS 'The link to the Voteplan primary key that links to this proposal.';
COMMENT ON COLUMN proposal_voteplan.bb_proposal_index IS 'The Index with the voteplan used by the voting ledger/bulletin board that references this proposal.';
