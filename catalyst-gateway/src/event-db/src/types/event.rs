use chrono::{DateTime, Utc};
use rust_decimal::Decimal;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct EventId(pub i32);

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct EventSummary {
    pub id: EventId,
    pub name: String,
    pub starts: Option<DateTime<Utc>>,
    pub ends: Option<DateTime<Utc>>,
    pub reg_checked: Option<DateTime<Utc>>,
    pub is_final: bool,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum VotingPowerAlgorithm {
    ThresholdStakedADA,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct VotingPowerSettings {
    pub alg: VotingPowerAlgorithm,
    pub min_ada: Option<i64>,
    pub max_pct: Option<Decimal>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct EventRegistration {
    pub purpose: Option<i64>,
    pub deadline: Option<DateTime<Utc>>,
    pub taken: Option<DateTime<Utc>>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct EventGoal {
    pub idx: i32,
    pub name: String,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct EventSchedule {
    pub insight_sharing: Option<DateTime<Utc>>,
    pub proposal_submission: Option<DateTime<Utc>>,
    pub refine_proposals: Option<DateTime<Utc>>,
    pub finalize_proposals: Option<DateTime<Utc>>,
    pub proposal_assessment: Option<DateTime<Utc>>,
    pub assessment_qa_start: Option<DateTime<Utc>>,
    pub voting: Option<DateTime<Utc>>,
    pub tallying: Option<DateTime<Utc>>,
    pub tallying_end: Option<DateTime<Utc>>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct EventDetails {
    pub voting_power: VotingPowerSettings,
    pub registration: EventRegistration,
    pub schedule: EventSchedule,
    pub goals: Vec<EventGoal>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Event {
    pub summary: EventSummary,
    pub details: EventDetails,
}
