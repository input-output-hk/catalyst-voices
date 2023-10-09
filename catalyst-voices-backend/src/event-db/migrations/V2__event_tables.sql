-- Catalyst Event Database


-- Event Table - Defines each voting or decision event

CREATE TABLE event
(
    row_id SERIAL PRIMARY KEY,

    name TEXT NOT NULL,
    description TEXT NOT NULL,

    registration_snapshot_time TIMESTAMP,
    snapshot_start TIMESTAMP,
    voting_power_threshold BIGINT,
    max_voting_power_pct NUMERIC(6,3) CONSTRAINT percentage CHECK (max_voting_power_pct <= 100 AND max_voting_power_pct >= 0),

    review_rewards BIGINT,

    start_time TIMESTAMP,
    end_time TIMESTAMP,

    insight_sharing_start TIMESTAMP,
    proposal_submission_start TIMESTAMP,
    refine_proposals_start TIMESTAMP,
    finalize_proposals_start TIMESTAMP,
    proposal_assessment_start TIMESTAMP,
    assessment_qa_start TIMESTAMP,
    voting_start TIMESTAMP,
    voting_end TIMESTAMP,
    tallying_end TIMESTAMP,

    block0 BYTEA NULL,
    block0_hash TEXT NULL,

    committee_size INTEGER NOT NULL,
    committee_threshold INTEGER NOT NULL,

    extra JSONB,
    cast_to JSONB
);

CREATE UNIQUE INDEX event_name_idx ON event(name);

COMMENT ON TABLE event IS 'The basic parameters of each voting/decision event.';
COMMENT ON COLUMN event.row_id IS 'Synthetic Unique ID for each event.';
COMMENT ON COLUMN event.name IS
'The name of the event.
eg. "Fund9" or "SVE1"';
COMMENT ON COLUMN event.description IS
'A detailed description of the purpose of the event.
eg. the events "Goal".';
COMMENT ON COLUMN event.registration_snapshot_time IS
'The Time (UTC) Registrations are taken from Cardano main net.
Registrations after this date are not valid for voting on the event.
NULL = Not yet defined or Not Applicable.';
COMMENT ON COLUMN event.snapshot_start IS
'The Time (UTC) Registrations taken from Cardano main net are considered stable.
This is not the Time of the Registration Snapshot,
This is the time after which the registration snapshot will be stable.
NULL = Not yet defined or Not Applicable.';
COMMENT ON COLUMN event.voting_power_threshold IS
'The Minimum number of Lovelace staked at the time of snapshot, to be eligible to vote.
NULL = Not yet defined.';
COMMENT ON COLUMN event.review_rewards IS 'The total reward pool to pay for community reviewers for their valid reviews of the proposals assigned to this event.';
COMMENT ON COLUMN event.start_time IS
'The time (UTC) the event starts.
NULL = Not yet defined.';
COMMENT ON COLUMN event.end_time IS
'The time (UTC) the event ends.
NULL = Not yet defined.';
COMMENT ON COLUMN event.insight_sharing_start IS
'TODO.
NULL = Not yet defined.';
COMMENT ON COLUMN event.proposal_submission_start IS
'The Time (UTC) proposals can start to be submitted for the event.
NULL = Not yet defined, or Not applicable.';
COMMENT ON COLUMN event.refine_proposals_start IS
'TODO.
NULL = Not yet defined.';
COMMENT ON COLUMN event.finalize_proposals_start IS
'The Time (UTC) when all proposals must be finalized by.
NULL = Not yet defined, or Not applicable.';
COMMENT ON COLUMN event.proposal_assessment_start IS
'The Time (UTC) when PA Assessors can start assessing proposals.
NULL = Not yet defined, or Not applicable.';
COMMENT ON COLUMN event.assessment_qa_start IS
'The Time (UTC) when vPA Assessors can start assessing assessments.
NULL = Not yet defined, or Not applicable.';
COMMENT ON COLUMN event.voting_start IS
'The earliest time that registered wallets with sufficient voting power can place votes in the event.
NULL = Not yet defined.';
COMMENT ON COLUMN event.voting_end IS
'The latest time that registered wallets with sufficient voting power can place votes in the event.
NULL = Not yet defined.';
COMMENT ON COLUMN event.tallying_end IS
'The latest time that tallying the event can complete by.
NULL = Not yet defined.';

COMMENT ON COLUMN event.block0      IS
'The copy of Block 0 used to start the Blockchain.
NULL = Blockchain not started yet.';

COMMENT ON COLUMN event.block0_hash IS
'The hash of block 0.
NULL = Blockchain not started yet.';

COMMENT ON COLUMN event.committee_size  IS
'The size of the tally committee.
0 = No Committee, and all votes are therefore public.';

COMMENT ON COLUMN event.committee_threshold  IS
'The minimum size of the tally committee to perform the tally.
Must be <= `comittee_size`';

COMMENT ON COLUMN event.extra IS
'Json Map defining event specific extra data.
NULL = Not yet defined.
"url"."results" = a results URL,
"url"."survey" = a survey URL,
others can be defined as required.';

COMMENT ON COLUMN event.cast_to IS
'Json Map defining parameters which control where the vote is to be cast.
Multiple destinations can be defined simultaneously.
In this case the vote gets cast to all defined destinations.
`NULL` = Default Jormungandr Blockchain.
```jsonc
"jorm" : { // Voting on Jormungandr Blockchain
    chain_id: <int>, // Jormungandr chain id. Defaults to 0.
    // Other parameters TBD.
},
"cardano" : { // Voting on Cardano Directly
    chain_id: <int>, // 0 = pre-prod, 1 = mainnet.
    // Other parameters TBD.
},
"postgres" : { // Store votes in Web 2 postgres backed DB only.
    url: "<postgres URL. Defaults to system default>"
    // Other parameters TBD.
    // Note: Votes that arrive in the Cat1 system are always stored in the DB.
    // This Option only allows the vote storage DB to be tuned.
},
"cat2" : { // Store votes to the Catalyst 2.0 P2P Network.
    gateway: "<URL of the gateway to use"
    // Other parameters TBD.
}
```
';
