use chrono::{DateTime, Utc};

use super::{challenge::Challenge, goal::Goal, group::Group, vote_plan::Voteplan};

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct FundStageDates {
    pub(crate) insight_sharing_start: DateTime<Utc>,
    pub(crate) proposal_submission_start: DateTime<Utc>,
    pub(crate) refine_proposals_start: DateTime<Utc>,
    pub(crate) finalize_proposals_start: DateTime<Utc>,
    pub(crate) proposal_assessment_start: DateTime<Utc>,
    pub(crate) assessment_qa_start: DateTime<Utc>,
    pub(crate) snapshot_start: DateTime<Utc>,
    pub(crate) voting_start: DateTime<Utc>,
    pub(crate) voting_end: DateTime<Utc>,
    pub(crate) tallying_end: DateTime<Utc>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct Fund {
    pub(crate) id: i32,
    pub(crate) name: String,
    pub(crate) goal: String,
    pub(crate) voting_power_threshold: i64,
    pub(crate) start_time: DateTime<Utc>,
    pub(crate) end_time: DateTime<Utc>,
    pub(crate) next_fund_start_time: DateTime<Utc>,
    pub(crate) registration_snapshot_time: DateTime<Utc>,
    pub(crate) next_registration_snapshot_time: DateTime<Utc>,
    pub(crate) chain_vote_plans: Vec<Voteplan>,
    pub(crate) challenges: Vec<Challenge>,
    pub(crate) stage_dates: FundStageDates,
    pub(crate) goals: Vec<Goal>,
    pub(crate) results_url: String,
    pub(crate) survey_url: String,
    pub(crate) groups: Vec<Group>,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct FundNextInfo {
    pub(crate) id: i32,
    pub(crate) fund_name: String,
    pub(crate) stage_dates: FundStageDates,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct FundWithNext {
    pub(crate) fund: Fund,
    pub(crate) next: Option<FundNextInfo>,
}
