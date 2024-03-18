//! Voting Status
use super::objective::ObjectiveId;

/// A voting status
#[allow(dead_code)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct VotingStatus {
    /// The objective ID
    pub(crate) objective_id: ObjectiveId,
    /// The voting status
    pub(crate) open: bool,
    /// The settings
    pub(crate) settings: Option<String>,
}
