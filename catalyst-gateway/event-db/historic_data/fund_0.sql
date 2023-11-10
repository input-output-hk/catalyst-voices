-- Data from Catalyst Fund 0 - Internal Test Fund

-- Data Sources see:
-- https://input-output.atlassian.net/wiki/spaces/VIT/pages/2892759058/Catalyst+Fund+Cycle+Releases
-- https://input-output.atlassian.net/wiki/spaces/VIT/pages/1484587009/Fund-0
-- https://docs.google.com/document/d/1C7DiqPmFkGu1Quq9_Q1Zb9mwNBP-ynModmIZQM_ck0g/edit#heading=h.vu2jb8p24a6e
-- https://input-output.atlassian.net/wiki/spaces/VIT/pages/1484783625/Fund-0+Retrospective
-- https://input-output.atlassian.net/wiki/spaces/VIT/pages/1484750853/Fund-0+Release+note

-- Purge all Fund 0 data before re-inserting it.
DELETE FROM event WHERE row_id = 0;

-- Create the Event record for Fund 0

INSERT INTO event
(
  row_id, name, description,
  start_time,
  end_time,
  registration_snapshot_time,
  snapshot_start,
  voting_power_threshold,
  max_voting_power_pct,
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
  committee_threshold
)
VALUES

(
  0, 'Catalyst Fund 0', 'Catalyst Internal Test Fund - Voting by Focus Group',
  '2020-05-22 00:00:00', -- Start Time - Date accurate, time not known.
  '2020-06-24 00:00:00', -- End Time   - Date accurate, time not known.
  -- Registration Snapshot Time - Date accurate, time not known.
  '2020-06-08 00:00:00',
  '2020-06-08 00:00:00', -- Snapshot Start - Date Assumed, time not known.
  1,                     -- Voting Power Threshold - Unknown, assume 1
  -- Max Voting Power PCT - No max% threshold used in this fund.
  100,
  NULL,                  -- Insight Sharing Start - None
  -- Proposal Submission Start - Date accurate, time not known.
  '2020-05-22 00:00:00',
  -- Refine Proposals Start - Date accurate, time not known.
  NULL,
  -- Finalize Proposals Start - Date accurate, time not known.
  '2020-05-29 00:00:00',
  NULL,                  -- Proposal Assessment Start - None
  NULL,                  -- Assessment QA Start - None
  '2020-06-15 00:00:00', -- Voting Starts - Date Accurate, time not known.
  '2020-06-19 00:00:00', -- Voting Ends - Date Accurate, time not known.
  '2020-06-19 12:00:00', -- Tallying Ends - Date Accurate, time not known.
  NULL,                  -- Block 0 Data - Not Known
  NULL,                  -- Block 0 Hash - Not Known
  0,                     -- Committee Size - Not Known
  0                      -- Committee Threshold - Not Known
);
