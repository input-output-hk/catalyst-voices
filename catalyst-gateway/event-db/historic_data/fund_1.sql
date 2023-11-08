-- Data from Catalyst Fund 1 - Public Pilot Run

-- Data Sources see:
-- https://input-output.atlassian.net/wiki/spaces/VIT/pages/2892759058/Catalyst+Fund+Cycle+Releases
-- https://input-output.atlassian.net/wiki/spaces/VIT/pages/1550057521/Fund-1
-- https://docs.google.com/spreadsheets/d/10x7T2nbjFECkngmDY04cnpUPpdiu1X-QjoxAtqKYTMs/edit#gid=1302724491
-- https://drive.google.com/file/d/1UmAGBRxWbQtpWjrNnvGuybgLiWs2zFMS/view
-- https://github.com/input-output-hk/catalyst-resources/blob/master/snapshots/snapshots.json

-- Purge all Fund 1 data before re-inserting it.
DELETE FROM event WHERE row_id = 1;

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
  1, 'Catalyst Fund 1', 'Public Pilot Run',
  '2020-08-08 00:00:00', -- Start Time - Date accurate, time not known.
  '2020-09-22 00:00:00', -- End Time   - Date accurate, time not known.
  '2020-09-14 12:00:05', -- Registration Snapshot Time - Slot 8518514
  '2020-09-15 00:00:00', -- Snapshot Start - Date/time not known.
  1,                     -- Voting Power Threshold - Unknown, assume 1
  -- Max Voting Power PCT - No max% threshold used in this fund.
  100,
  NULL,                  -- Insight Sharing Start - None
  -- Proposal Submission Start - Date accurate, time not known.
  '2020-08-08 00:00:00',
  -- Refine Proposals Start - Date accurate, time not known.
  NULL,
  -- Finalize Proposals Start - Date accurate, time not known.
  '2020-09-11 00:00:00',
  NULL,                  -- Proposal Assessment Start - None
  NULL,                  -- Assessment QA Start - None
  '2020-09-17 00:00:00', -- Voting Starts - Date Accurate, time not known.
  '2020-09-21 00:00:00', -- Voting Ends - Date Accurate, time not known.
  '2020-09-22 23:59:00', -- Tallying Ends - Date Accurate, time not known.
  NULL,                  -- Block 0 Data - Not Known
  NULL,                  -- Block 0 Hash - Not Known
  0,                     -- Committee Size - Not Known
  0                      -- Committee Threshold - Not Known
);
