use chrono::{DateTime, Utc};
use rust_decimal::Decimal;

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct EventId(pub(crate) i32);

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct EventSummary {
    pub(crate) id: EventId,
    pub(crate) name: String,
    pub(crate) starts: Option<DateTime<Utc>>,
    pub(crate) ends: Option<DateTime<Utc>>,
    pub(crate) reg_checked: Option<DateTime<Utc>>,
    pub(crate) is_final: bool,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) enum VotingPowerAlgorithm {
    ThresholdStakedADA,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct VotingPowerSettings {
    pub(crate) alg: VotingPowerAlgorithm,
    pub(crate) min_ada: Option<i64>,
    pub(crate) max_pct: Option<Decimal>,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct EventRegistration {
    pub(crate) purpose: Option<i64>,
    pub(crate) deadline: Option<DateTime<Utc>>,
    pub(crate) taken: Option<DateTime<Utc>>,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct EventGoal {
    pub(crate) idx: i32,
    pub(crate) name: String,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct EventSchedule {
    pub(crate) insight_sharing: Option<DateTime<Utc>>,
    pub(crate) proposal_submission: Option<DateTime<Utc>>,
    pub(crate) refine_proposals: Option<DateTime<Utc>>,
    pub(crate) finalize_proposals: Option<DateTime<Utc>>,
    pub(crate) proposal_assessment: Option<DateTime<Utc>>,
    pub(crate) assessment_qa_start: Option<DateTime<Utc>>,
    pub(crate) voting: Option<DateTime<Utc>>,
    pub(crate) tallying: Option<DateTime<Utc>>,
    pub(crate) tallying_end: Option<DateTime<Utc>>,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct EventDetails {
    pub(crate) voting_power: VotingPowerSettings,
    pub(crate) registration: EventRegistration,
    pub(crate) schedule: EventSchedule,
    pub(crate) goals: Vec<EventGoal>,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct Event {
    pub(crate) summary: EventSummary,
    pub(crate) details: EventDetails,
}
