use super::{objective::ObjectiveId, proposal::ProposalId};
use crate::types::registration::VoterGroupId;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ObjectiveChoices(pub Vec<String>);

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct BallotType(pub String);

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct VotePlan {
    pub chain_proposal_index: i64,
    pub group: Option<VoterGroupId>,
    pub ballot_type: BallotType,
    pub chain_voteplan_id: String,
    pub encryption_key: Option<String>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct GroupVotePlans(pub Vec<VotePlan>);

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Ballot {
    pub choices: ObjectiveChoices,
    pub voteplans: GroupVotePlans,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ProposalBallot {
    pub proposal_id: ProposalId,
    pub ballot: Ballot,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ObjectiveBallots {
    pub objective_id: ObjectiveId,
    pub ballots: Vec<ProposalBallot>,
}
