//! Event Types
use chrono::{DateTime, Utc};
use rust_decimal::Decimal;

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
/// Event ID
pub(crate) struct EventId(pub(crate) i32);

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
/// Event Summary
pub(crate) struct EventSummary {
    /// Event ID
    pub(crate) id: EventId,
    /// Event name
    pub(crate) name: String,
    /// Starts
    pub(crate) starts: Option<DateTime<Utc>>,
    /// Ends
    pub(crate) ends: Option<DateTime<Utc>>,
    /// `reg_checked`
    pub(crate) reg_checked: Option<DateTime<Utc>>,
    /// `is_final`
    pub(crate) is_final: bool,
}

#[derive(Debug, Clone, PartialEq, Eq)]
/// Voting Power Algorithm
pub(crate) enum VotingPowerAlgorithm {
    /// Threshold Staked ADA
    ThresholdStakedADA,
}

#[derive(Debug, Clone, PartialEq, Eq)]
/// Voting Power Settings
pub(crate) struct VotingPowerSettings {
    /// Voting Power Algorithm
    pub(crate) alg: VotingPowerAlgorithm,
    /// Minimum ADA
    pub(crate) min_ada: Option<i64>,
    /// Maximum PCT
    pub(crate) max_pct: Option<Decimal>,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
/// Event Registration
pub(crate) struct EventRegistration {
    /// Purpose
    pub(crate) purpose: Option<i64>,
    /// Registration Deadline
    pub(crate) deadline: Option<DateTime<Utc>>,
    /// Registration Taken
    pub(crate) taken: Option<DateTime<Utc>>,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
/// Event Goal
pub(crate) struct EventGoal {
    /// Goal Index
    pub(crate) idx: i32,
    /// Goal Name
    pub(crate) name: String,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
/// Event Schedule
pub(crate) struct EventSchedule {
    /// `insight_sharing`
    pub(crate) insight_sharing: Option<DateTime<Utc>>,
    /// `proposal_submission`
    pub(crate) proposal_submission: Option<DateTime<Utc>>,
    /// `refine_proposals`
    pub(crate) refine_proposals: Option<DateTime<Utc>>,
    /// `finalize_proposals`
    pub(crate) finalize_proposals: Option<DateTime<Utc>>,
    /// `proposal_assessment`
    pub(crate) proposal_assessment: Option<DateTime<Utc>>,
    /// `proposal_assessment_qa_start`
    pub(crate) assessment_qa_start: Option<DateTime<Utc>>,
    /// voting start
    pub(crate) voting: Option<DateTime<Utc>>,
    /// tallying start
    pub(crate) tallying: Option<DateTime<Utc>>,
    /// tallying end
    pub(crate) tallying_end: Option<DateTime<Utc>>,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
/// Event Details
pub(crate) struct EventDetails {
    /// Voting Power
    pub(crate) voting_power: VotingPowerSettings,
    /// Registration
    pub(crate) registration: EventRegistration,
    /// Schedule
    pub(crate) schedule: EventSchedule,
    /// Goals
    pub(crate) goals: Vec<EventGoal>,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
/// Event
pub(crate) struct Event {
    /// Event summary
    pub(crate) summary: EventSummary,
    /// Event details
    pub(crate) details: EventDetails,
}
