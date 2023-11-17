-- Catalyst Event Database
CREATE TABLE
event_type (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" TEXT NOT NULL,
    description_schema JSONB NOT NULL,
    extra_data_schema JSONB NOT NULL
);

CREATE UNIQUE INDEX event_type_name_idx ON event_type (name);

COMMENT ON TABLE event_type IS 'The types of event which have been defined.';

COMMENT ON COLUMN event_type.id IS 'Synthetic Unique ID for each event_type (UUIDv4).';

COMMENT ON COLUMN event_type.name IS 'The name of the event type.
eg. "Catalyst V1"';

COMMENT ON COLUMN event_type.description_schema IS 'The JSON Schema which defines the structure of the data in the `description` field in the event record.';

COMMENT ON COLUMN event_type.extra_data_schema IS 'The JSON Schema which defines the structure of the data in the `extra_data` field in the event record.';

-- Event Table - Defines each voting or decision event
CREATE TABLE
"event" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "type" UUID REFERENCES event_type (id),
    "name" TEXT NOT NULL,
    description JSONB NOT NULL,
    start_time TIMESTAMP,
    backing_start TIMESTAMP,
    backing_end TIMESTAMP,
    end_time TIMESTAMP,
    extra_data JSONB NOT NULL
);

CREATE UNIQUE INDEX event_name_idx ON event (name);

COMMENT ON TABLE event IS 'The basic parameters of a related set of funding campaigns.';

COMMENT ON COLUMN event.id IS 'Synthetic Unique ID for each event (UUIDv4).';

COMMENT ON COLUMN event.name IS 'The name of the event.
eg. "Fund9" or "SVE1"';

COMMENT ON COLUMN event.type IS 'The type of the event.';

COMMENT ON COLUMN event.description IS 'A detailed description of the purpose of the event.
Must conform to the JSON Schema defined by `event_type.description_schema.`';

COMMENT ON COLUMN event.start_time IS 'The time (UTC) the event starts.
NULL = Not yet defined.';

COMMENT ON COLUMN event.backing_start IS 'The time (UTC) when backers may start backing the campaigns in the event. This must >= event.start_time.
NULL = Not yet defined.';

COMMENT ON COLUMN event.backing_end IS 'The time (UTC) when backers may no longer back the campaigns in the event. This must > event.backing_start and <= event.end_time.
NULL = Not yet defined.';

COMMENT ON COLUMN event.end_time IS 'The time (UTC) the event ends. Must be >= event.backing_end.
NULL = Not yet defined.';

COMMENT ON COLUMN event.extra_data IS 'Extra event type specific data defined about the event.
Must conform to the JSON Schema defined by `event_type.extra_data_schema.`';

--COMMENT ON COLUMN event.registration_snapshot_time IS
--'The Time (UTC) Registrations are taken from Cardano main net.
--Registrations after this date are not valid for voting on the event.
--NULL = Not yet defined or Not Applicable.';
--COMMENT ON COLUMN event.snapshot_start IS
--'The Time (UTC) Registrations taken from Cardano main net are considered stable.
--This is not the Time of the Registration Snapshot,
--This is the time after which the registration snapshot will be stable.
--NULL = Not yet defined or Not Applicable.';
--COMMENT ON COLUMN event.voting_power_threshold IS
--'The Minimum number of Lovelace staked at the time of snapshot, to be eligible to vote.
--NULL = Not yet defined.';
--COMMENT ON COLUMN event.review_rewards IS 'The total reward pool to pay for community reviewers for their valid reviews of the proposals assigned to this event.';
--COMMENT ON COLUMN event.start_time IS
--'The time (UTC) the event starts.
--NULL = Not yet defined.';
--COMMENT ON COLUMN event.end_time IS
--'The time (UTC) the event ends.
--NULL = Not yet defined.';
--COMMENT ON COLUMN event.insight_sharing_start IS
--'TODO.
--NULL = Not yet defined.';
--COMMENT ON COLUMN event.proposal_submission_start IS
--'The Time (UTC) proposals can start to be submitted for the event.
--NULL = Not yet defined, or Not applicable.';
--COMMENT ON COLUMN event.refine_proposals_start IS
--'TODO.
--NULL = Not yet defined.';
--COMMENT ON COLUMN event.finalize_proposals_start IS
--'The Time (UTC) when all proposals must be finalized by.
--NULL = Not yet defined, or Not applicable.';
--COMMENT ON COLUMN event.proposal_assessment_start IS
--'The Time (UTC) when PA Assessors can start assessing proposals.
--NULL = Not yet defined, or Not applicable.';
--COMMENT ON COLUMN event.assessment_qa_start IS
--'The Time (UTC) when vPA Assessors can start assessing assessments.
--NULL = Not yet defined, or Not applicable.';
--COMMENT ON COLUMN event.voting_start IS
--'The earliest time that registered wallets with sufficient voting power can place votes in the event.
--NULL = Not yet defined.';
--COMMENT ON COLUMN event.voting_end IS
--'The latest time that registered wallets with sufficient voting power can place votes in the event.
--NULL = Not yet defined.';
--COMMENT ON COLUMN event.tallying_end IS
--'The latest time that tallying the event can complete by.
--NULL = Not yet defined.';
--COMMENT ON COLUMN event.block0      IS
--'The copy of Block 0 used to start the Blockchain.
--NULL = Blockchain not started yet.';
--COMMENT ON COLUMN event.block0_hash IS
--'The hash of block 0.
--NULL = Blockchain not started yet.';
--COMMENT ON COLUMN event.committee_size  IS
--'The size of the tally committee.
--0 = No Committee, and all votes are therefore public.';
--COMMENT ON COLUMN event.committee_threshold  IS
--'The minimum size of the tally committee to perform the tally.
--Must be <= `committee_size`';
--COMMENT ON COLUMN event.cast_to IS
--'Json Map defining parameters which control where the vote is to be cast.
--Multiple destinations can be defined simultaneously.
--In this case the vote gets cast to all defined destinations.
--`NULL` = Default Jormungandr Blockchain.
--```jsonc
--"jorm" : { // Voting on Jormungandr Blockchain
--    chain_id: <int>, // Jormungandr chain id. Defaults to 0.
--    // Other parameters TBD.
--},
--"cardano" : { // Voting on Cardano Directly
--    chain_id: <int>, // 0 = pre-prod, 1 = mainnet.
--    // Other parameters TBD.
--},
--"postgres" : { // Store votes in Web 2 postgres backed DB only.
--    url: "<postgres URL. Defaults to system default>"
--    // Other parameters TBD.
--    // Note: Votes that arrive in the Cat1 system are always stored in the DB.
--    // This Option only allows the vote storage DB to be tuned.
--},
--"cat2" : { // Store votes to the Catalyst 2.0 P2P Network.
--    gateway: "<URL of the gateway to use"
--    // Other parameters TBD.
--}
--```
--';
-- The following needs to be encoded in a catalyst V1 type event.
--    review_rewards BIGINT,
--    registration_snapshot_time TIMESTAMP,
--    snapshot_start TIMESTAMP,
--    voting_power_threshold BIGINT,
--    max_voting_power_pct NUMERIC(6,3) CONSTRAINT percentage CHECK (max_voting_power_pct <= 100 AND max_voting_power_pct >= 0),
--    insight_sharing_start TIMESTAMP,
--    proposal_submission_start TIMESTAMP,
--    refine_proposals_start TIMESTAMP,
--    finalize_proposals_start TIMESTAMP,
--    proposal_assessment_start TIMESTAMP,
--    assessment_qa_start TIMESTAMP,
--    voting_start TIMESTAMP,
--    voting_end TIMESTAMP,
--    tallying_end TIMESTAMP,
--    block0 BYTEA NULL,
--    block0_hash TEXT NULL,
--    committee_size INTEGER NOT NULL,
--    committee_threshold INTEGER NOT NULL,
--    extra JSONB,
--    cast_to JSONB
