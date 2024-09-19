//! Objective Types
use serde_json::Value;

use crate::db::event::legacy::types::registration::VoterGroupId;

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
/// Objective ID
pub(crate) struct ObjectiveId(pub(crate) i32);

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
/// Objective Type
pub(crate) struct ObjectiveType {
    /// id
    pub(crate) id: String,
    /// description
    pub(crate) description: String,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
/// Objective Summary
pub(crate) struct ObjectiveSummary {
    /// Objective ID
    pub(crate) id: ObjectiveId,
    /// Objective Type
    pub(crate) objective_type: ObjectiveType,
    /// Title
    pub(crate) title: String,
    /// Description
    pub(crate) description: String,
    /// Deleted
    pub(crate) deleted: bool,
}

#[derive(Debug, Clone, PartialEq, Eq)]
/// Reward Definition
pub(crate) struct RewardDefinition {
    /// Currency
    pub(crate) currency: String,
    /// Value
    pub(crate) value: i64,
}

#[derive(Debug, Clone, PartialEq, Eq)]
/// Voter Group
pub(crate) struct VoterGroup {
    /// Voter Group
    pub(crate) group: Option<VoterGroupId>,
    /// Voting Token
    pub(crate) voting_token: Option<String>,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
/// Objective Details
pub(crate) struct ObjectiveDetails {
    /// Objective Groups
    pub(crate) groups: Vec<VoterGroup>,
    /// Reward
    pub(crate) reward: Option<RewardDefinition>,
    /// Supplemental data
    pub(crate) supplemental: Option<Value>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
/// Objective
pub(crate) struct Objective {
    /// Objective summary
    pub(crate) summary: ObjectiveSummary,
    /// Objective details
    pub(crate) details: ObjectiveDetails,
}
