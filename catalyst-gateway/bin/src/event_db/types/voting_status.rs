use super::objective::ObjectiveId;

#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct VotingStatus {
    pub(crate) objective_id: ObjectiveId,
    pub(crate) open: bool,
    pub(crate) settings: Option<String>,
}
