-- Catalyst Event Database

-- Proposals Table

CREATE TABLE proposal
(
    row_id SERIAL PRIMARY KEY,
    id INTEGER NOT NULL,
    objective INTEGER NOT NULL,
    title TEXT NOT NULL,
    summary TEXT NOT NULL,
    category TEXT NOT NULL,
    public_key TEXT NOT NULL,
    funds BIGINT NOT NULL,
    url TEXT NOT NULL,
    files_url TEXT NOT NULL,
    impact_score BIGINT NOT NULL,

    deleted BOOLEAN NOT NULL DEFAULT FALSE,

    extra JSONB,

    proposer_name TEXT NOT NULL,
    proposer_contact TEXT NOT NULL,
    proposer_url TEXT NOT NULL,
    proposer_relevant_experience TEXT NOT NULL,
    bb_proposal_id BYTEA,

    bb_vote_options TEXT[],

    FOREIGN KEY(objective) REFERENCES objective(row_id) ON DELETE CASCADE,
    FOREIGN KEY(bb_vote_options) REFERENCES vote_options(objective) ON DELETE CASCADE
);

CREATE UNIQUE INDEX proposal_index ON proposal(id, objective);


COMMENT ON TABLE proposal IS 'All Proposals for the current fund.';
COMMENT ON COLUMN proposal.row_id IS 'Synthetic Unique Key';
COMMENT ON COLUMN proposal.id IS 'Actual Proposal Unique ID';
COMMENT ON COLUMN proposal.objective IS 'The Objective this proposal falls under.';
COMMENT ON COLUMN proposal.title IS 'Brief title of the proposal.';
COMMENT ON COLUMN proposal.summary IS 'A Summary of the proposal to be implemented.';
COMMENT ON COLUMN proposal.category IS 'Objective Category Repeated. DEPRECATED: Only used for Vit-SS compatibility.';
COMMENT ON COLUMN proposal.public_key IS 'Proposals Reward Address (CIP-19 Payment Key)';
COMMENT ON COLUMN proposal.funds IS 'How much funds (in the currency of the fund)';
COMMENT ON COLUMN proposal.url IS 'A URL with supporting information for the proposal.';
COMMENT ON COLUMN proposal.files_url IS 'A URL link to relevant files supporting the proposal.';
COMMENT ON COLUMN proposal.impact_score IS 'The Impact score assigned to this proposal by the Assessors.';
COMMENT ON COLUMN proposal.deleted IS 'Flag which defines was this proposal deleted from ideascale or not. DEPRECATED: only used for ideascale compatibility.';
COMMENT ON COLUMN proposal.proposer_name IS 'The proposers name.';
COMMENT ON COLUMN proposal.proposer_contact IS 'Contact details for the proposer.';
COMMENT ON COLUMN proposal.proposer_url IS 'A URL with details of the proposer.';
COMMENT ON COLUMN proposal.proposer_relevant_experience IS 'A freeform  string describing the proposers experience relating to their capability to implement the proposal.';
COMMENT ON COLUMN proposal.bb_proposal_id IS 'The ID used by the voting ledger (bulletin board) to refer to this proposal.';
COMMENT ON COLUMN proposal.bb_vote_options IS 'The selectable options by the voter. DEPRECATED: Only used for Vit-SS compatibility.';
COMMENT ON COLUMN proposal.extra IS
'Extra data about the proposal.
 The types of extra data are defined by the proposal type and are not enforced.
 Extra Fields for `native` challenges:
    NONE.

 Extra Fields for `simple` challenges:
    "problem"  : <text> - Statement of the problem the proposal tries to address.
    "solution" : <text> - The Solution to the challenge.

 Extra Fields for `community choice` challenge:
    "brief"      : <text> - Brief explanation of a proposal.
    "importance" : <text> - The importance of the proposal.
    "goal"       : <text> - The goal of the proposal is addressed to meet.
    "metrics"    : <text> - The metrics of the proposal or how success will be determined.';

-- Reviewer's levels table

CREATE TABLE reviewer_level (
    row_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    total_reward_pct NUMERIC(6,3) CONSTRAINT percentage CHECK (total_reward_pct <= 100 AND total_reward_pct >= 0),

    event_id INTEGER NOT NULL,

    FOREIGN KEY (event_id) REFERENCES event(row_id) ON DELETE CASCADE
);

COMMENT ON TABLE reviewer_level IS 
'All levels of reviewers.
This table represents all different types of reviewer`s levels, which is taken into account during rewarding process.';
COMMENT ON COLUMN reviewer_level.row_id IS 'Synthetic Unique Key';
COMMENT ON COLUMN reviewer_level.name IS 'Name of the reviewer level';
COMMENT ON COLUMN reviewer_level.total_reward_pct IS 
'Total reviewer`s reward assigned to the specific level, which is defined as a percentage from the total pot of Community Review rewards (See `event.review_rewards` column).';
COMMENT ON COLUMN reviewer_level.event_id IS 'The specific Event ID this review level is part of.';

-- community advisor reviews

-- I feel like these ratings and notes should be in a  general json field to
-- suit adaptability without needing schema changes.

CREATE TABLE proposal_review (
  row_id SERIAL PRIMARY KEY,
  proposal_id INTEGER NOT NULL,
  assessor VARCHAR NOT NULL,
  assessor_level INTEGER,
  reward_address TEXT,

  -- These fields are deprecated and WILL BE removed in a future migration.
  -- They MUST only be used for Vit-SS compatibility.
  impact_alignment_rating_given INTEGER,
  impact_alignment_note VARCHAR,
  feasibility_rating_given INTEGER,
  feasibility_note VARCHAR,
  auditability_rating_given INTEGER,
  auditability_note VARCHAR,
  ranking INTEGER,
  flags JSONB NULL,

  FOREIGN KEY (proposal_id) REFERENCES proposal(row_id) ON DELETE CASCADE,
  FOREIGN KEY (assessor_level) REFERENCES reviewer_level(row_id) ON DELETE CASCADE
);

COMMENT ON TABLE proposal_review IS 'All Reviews.';
COMMENT ON COLUMN proposal_review.row_id IS 'Synthetic Unique Key.';
COMMENT ON COLUMN proposal_review.proposal_id IS 'The Proposal this review is for.';
COMMENT ON COLUMN proposal_review.assessor IS 'Assessors Anonymized ID';
COMMENT ON COLUMN proposal_review.assessor_level IS 'Assessors level ID';
COMMENT ON COLUMN proposal_review.reward_address IS 'Assessors reward address';

COMMENT ON COLUMN proposal_review.impact_alignment_rating_given IS
'The  numeric rating assigned to the proposal by the assessor.
DEPRECATED: Only used for Vit-SS compatibility.';
COMMENT ON COLUMN proposal_review.impact_alignment_note IS
'A note about why the impact rating was given.
DEPRECATED: Only used for Vit-SS compatibility.';

COMMENT ON COLUMN proposal_review.feasibility_rating_given IS
'The numeric feasibility rating given.
DEPRECATED: Only used for Vit-SS compatibility.';
COMMENT ON COLUMN proposal_review.feasibility_note IS
'A note about why the feasibility rating was given.
DEPRECATED: Only used for Vit-SS compatibility.';

COMMENT ON COLUMN proposal_review.auditability_rating_given IS
'The numeric auditability rating given.
DEPRECATED: Only used for Vit-SS compatibility.';
COMMENT ON COLUMN proposal_review.auditability_note IS
'A note about the auditability rating given.
DEPRECATED: Only used for Vit-SS compatibility.';

COMMENT ON COLUMN proposal_review.ranking IS
'Numeric  Measure of quality of this review according to veteran community advisors.
DEPRECATED: Only used for Vit-SS compatibility.
';

COMMENT ON COLUMN proposal_review.flags IS
'OPTIONAL: JSON Array which defines the flags raised for this review.
Flags can be raised for different reasons and have different metadata.
Each entry =
```jsonc
{
   "flag_type": "<flag_type>", // Enum of the flag type (0: Profanity, 1: Similarity 2: AI generated).
   "score": <score>, // Profanity score, similarity score, or AI generated score. 0-1.
   "related_reviews": [<review_id>] // Array of review IDs that this flag is related to (valid for similarity).
}
```
';

CREATE TABLE review_metric (
  row_id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  description VARCHAR NULL,
  min INTEGER NOT NULL,
  max INTEGER NOT NULL,
  map JSONB ARRAY NULL
);
COMMENT ON TABLE review_metric IS 'Definition of all possible review metrics.';
COMMENT ON COLUMN review_metric.row_id IS 'The synthetic ID of this metric.';
COMMENT ON COLUMN review_metric.name IS 'The short name for this review metric.';
COMMENT ON COLUMN review_metric.description IS 'Long form description of what the review metric means.';
COMMENT ON COLUMN review_metric.min IS 'The minimum value of the metric (inclusive).';
COMMENT ON COLUMN review_metric.max IS 'The maximum value of the metric (inclusive).';
COMMENT ON COLUMN review_metric.map IS
'OPTIONAL: JSON Array which defines extra details for each metric score.
There MUST be one entry per possible score in the range.
Entries are IN ORDER, from the lowest numeric score to the highest.
Each entry =
```jsonc
{
   "name" : "<name>", // Symbolic Name for the metric score.
   "description" : "<desc>", // Description of what the named metric score means.
}
```
';

-- Define known review metrics
INSERT INTO review_metric (name, description, min, max, map)
VALUES
    ('impact', 'Impact Rating', 0, 5, NULL),
    ('feasibility','Feasibility Rating', 0, 5, NULL),
    ('auditability','Auditability Rating', 0, 5, NULL),
    ('value','Value Proposition Rating', 0, 5, NULL),
    ('vpa_ranking','VPA Ranking of the review',0,3, ARRAY [
            '{"name":"Excellent","desc":"Excellent Review"}',
            '{"name":"Good","desc":"Could be improved."}',
            '{"name":"FilteredOut","desc":"Exclude this review"}',
            '{"name":"NA", "desc":"Not Applicable"}']::JSON[]);

CREATE TABLE objective_review_metric (
  row_id SERIAL PRIMARY KEY,
  objective INTEGER NOT NULL,
  metric INTEGER NOT NULL,
  note BOOLEAN,
  review_group VARCHAR,

  UNIQUE(objective, metric, review_group),

  FOREIGN KEY (objective) REFERENCES objective(row_id) ON DELETE CASCADE,
  FOREIGN KEY (metric) REFERENCES review_metric(row_id) ON DELETE CASCADE
);


COMMENT ON TABLE objective_review_metric IS 'All valid metrics for reviews on an objective.';
COMMENT ON COLUMN objective_review_metric.objective IS 'The objective that can use this review metric.';
COMMENT ON COLUMN objective_review_metric.metric IS 'The review metric that the objective can use.';
COMMENT ON COLUMN objective_review_metric.note IS
'Does the metric require a Note?
NULL = Optional.
True = MUST include Note.
False = MUST NOT include Note.';
COMMENT ON COLUMN objective_review_metric.review_group IS 'The review group that can give this metric. Details TBD.';



CREATE TABLE review_rating (
  row_id SERIAL PRIMARY KEY,
  review_id INTEGER NOT NULL,
  metric INTEGER NOT NULL,
  rating INTEGER NOT NULL,
  note   VARCHAR,

  UNIQUE ( review_id, metric ),

  FOREIGN KEY (review_id) REFERENCES proposal_review(row_id) ON DELETE CASCADE,
  FOREIGN KEY (metric) REFERENCES review_metric(row_id) ON DELETE CASCADE
);


COMMENT ON TABLE review_rating IS 'An Individual rating for a metric given on a review.';
COMMENT ON COLUMN review_rating.row_id IS 'Synthetic ID of this individual rating.';
COMMENT ON COLUMN review_rating.review_id IS 'The review the metric is being given for.';
COMMENT ON COLUMN review_rating.metric    IS 'Metric the rating is being given for.';
COMMENT ON COLUMN review_rating.rating    IS 'The rating being given to the metric.';
COMMENT ON COLUMN review_rating.note      IS 'OPTIONAL: Note about the rating given.';
