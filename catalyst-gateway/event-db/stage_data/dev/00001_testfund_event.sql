-- F10
INSERT INTO event (
    row_id,
    name,
    description,
    registration_snapshot_time,
    snapshot_start,
    voting_power_threshold,
    max_voting_power_pct,
    review_rewards,
    start_time,
    end_time,
    insight_sharing_start,
    proposal_submission_start,
    refine_proposals_start,
    finalize_proposals_start,
    proposal_assessment_start,
    assessment_qa_start,
    voting_start,
    voting_end,
    tallying_end,
    block0,
    block0_hash,
    committee_size,
    committee_threshold,
    extra,
    cast_to
) VALUES (
    0,
    'Test Fund',
    'Catalyst Dev Environment - Test Fund',
    '1970-01-01 00:00:00',  -- Registration Snapshot Time
    '1970-01-01 00:00:00',  -- Snapshot Start.
    450000000,              -- Voting Power Threshold
    1,                      -- Max Voting Power PCT
    NULL,                   -- Review Rewards
    '1970-01-01 00:00:00',  -- Start Time
    '1970-01-01 00:00:00',  -- End Time
    '1970-01-01 00:00:00',  -- Insight Sharing Start
    '1970-01-01 00:00:00',  -- Proposal Submission Start
    '1970-01-01 00:00:00',  -- Refine Proposals Start
    '1970-01-01 00:00:00',  -- Finalize Proposals Start
    '1970-01-01 00:00:00',  -- Proposal Assessment Start
    '1970-01-01 00:00:00',  -- Assessment QA Start
    '1970-01-01 00:00:00',  -- Voting Starts
    '1970-01-01 00:00:00',  -- Voting Ends
    '1970-01-01 00:00:00',  -- Tallying Ends
    NULL,                   -- Block 0 Data
    NULL,                   -- Block 0 Hash
    1,                      -- Committee Size
    1,                      -- Committee Threshold
    NULL,                   -- Extra
    NULL                    -- Cast to
);