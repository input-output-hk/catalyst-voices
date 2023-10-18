use super::objective::ObjectiveId;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct VotingStatus {
    pub objective_id: ObjectiveId,
    pub open: bool,
    pub settings: Option<String>,
}
