use crate::event_db::types::registration::VoterGroupId;
use serde_json::Value;

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub(crate) struct ObjectiveId(pub(crate) i32);

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct ObjectiveType {
    pub(crate) id: String,
    pub(crate) description: String,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct ObjectiveSummary {
    pub(crate) id: ObjectiveId,
    pub(crate) objective_type: ObjectiveType,
    pub(crate) title: String,
    pub(crate) description: String,
    pub(crate) deleted: bool,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct RewardDefinition {
    pub(crate) currency: String,
    pub(crate) value: i64,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct VoterGroup {
    pub(crate) group: Option<VoterGroupId>,
    pub(crate) voting_token: Option<String>,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct ObjectiveDetails {
    pub(crate) groups: Vec<VoterGroup>,
    pub(crate) reward: Option<RewardDefinition>,
    pub(crate) supplemental: Option<Value>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct Objective {
    pub(crate) summary: ObjectiveSummary,
    pub(crate) details: ObjectiveDetails,
}
