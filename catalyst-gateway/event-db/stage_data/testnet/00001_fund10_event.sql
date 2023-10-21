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
    10,
    'Fund 10',
    'Catalyst Testnet - Fund 10',
    '2023-08-18 21:00:00',  -- Registration Snapshot Time
    '2023-08-23 22:00:00',  -- Snapshot Start.
    450000000,              -- Voting Power Threshold
    1,                      -- Max Voting Power PCT
    NULL,                   -- Review Rewards
    '2023-06-16 19:56:00',  -- Start Time
    '2023-09-18 00:00:00',  -- End Time
    '2023-06-22 00:00:00',  -- Insight Sharing Start
    '2023-06-22 00:00:00',  -- Proposal Submission Start
    '2023-06-22 00:00:00',  -- Refine Proposals Start
    '2023-07-13 00:00:00',  -- Finalize Proposals Start
    '2023-07-20 00:00:00',  -- Proposal Assessment Start
    '2023-08-10 00:00:00',  -- Assessment QA Start
    '2023-08-31 11:00:00',  -- Voting Starts
    '2023-09-14 11:00:00',  -- Voting Ends
    '2023-09-18 11:00:00',  -- Tallying Ends
    NULL,                   -- Block 0 Data
    NULL,                   -- Block 0 Hash
    1,                      -- Committee Size
    1,                      -- Committee Threshold
    NULL,                   -- Extra
    NULL                    -- Cast to
);