use super::{challenge::Challenge, goal::Goal, group::Group, vote_plan::Voteplan};
use chrono::{DateTime, Utc};

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct FundStageDates {
    pub insight_sharing_start: DateTime<Utc>,
    pub proposal_submission_start: DateTime<Utc>,
    pub refine_proposals_start: DateTime<Utc>,
    pub finalize_proposals_start: DateTime<Utc>,
    pub proposal_assessment_start: DateTime<Utc>,
    pub assessment_qa_start: DateTime<Utc>,
    pub snapshot_start: DateTime<Utc>,
    pub voting_start: DateTime<Utc>,
    pub voting_end: DateTime<Utc>,
    pub tallying_end: DateTime<Utc>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Fund {
    pub id: i32,
    pub fund_name: String,
    pub fund_goal: String,
    pub voting_power_threshold: i64,
    pub fund_start_time: DateTime<Utc>,
    pub fund_end_time: DateTime<Utc>,
    pub next_fund_start_time: DateTime<Utc>,
    pub registration_snapshot_time: DateTime<Utc>,
    pub next_registration_snapshot_time: DateTime<Utc>,
    pub chain_vote_plans: Vec<Voteplan>,
    pub challenges: Vec<Challenge>,
    pub stage_dates: FundStageDates,
    pub goals: Vec<Goal>,
    pub results_url: String,
    pub survey_url: String,
    pub groups: Vec<Group>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct FundNextInfo {
    pub id: i32,
    pub fund_name: String,
    pub stage_dates: FundStageDates,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct FundWithNext {
    pub fund: Fund,
    pub next: Option<FundNextInfo>,
}
