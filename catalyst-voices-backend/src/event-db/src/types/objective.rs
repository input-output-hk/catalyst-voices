use crate::types::registration::VoterGroupId;
use serde_json::Value;

#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct ObjectiveId(pub i32);

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ObjectiveType {
    pub id: String,
    pub description: String,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ObjectiveSummary {
    pub id: ObjectiveId,
    pub objective_type: ObjectiveType,
    pub title: String,
    pub description: String,
    pub deleted: bool,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct RewardDefintion {
    pub currency: String,
    pub value: i64,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct VoterGroup {
    pub group: Option<VoterGroupId>,
    pub voting_token: Option<String>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ObjectiveDetails {
    pub groups: Vec<VoterGroup>,
    pub reward: Option<RewardDefintion>,
    pub supplemental: Option<Value>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Objective {
    pub summary: ObjectiveSummary,
    pub details: ObjectiveDetails,
}
