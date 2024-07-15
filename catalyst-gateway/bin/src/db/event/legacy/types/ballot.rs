//! Ballot types
use super::{objective::ObjectiveId, proposal::ProposalId};
use crate::db::event::legacy::types::registration::VoterGroupId;

#[derive(Debug, Clone, PartialEq, Eq)]
/// Objective Choices
pub(crate) struct ObjectiveChoices(pub(crate) Vec<String>);

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
/// Ballot Type
pub(crate) struct BallotType(pub(crate) String);

#[derive(Debug, Clone, PartialEq, Eq)]
/// Voting Plan
pub(crate) struct VotePlan {
    /// Chain proposal index
    pub(crate) chain_proposal_index: i64,
    /// Group
    pub(crate) group: Option<VoterGroupId>,
    /// Ballot
    pub(crate) ballot_type: BallotType,
    /// Chain voteplan id
    pub(crate) chain_voteplan_id: String,
    /// Encryption key
    pub(crate) encryption_key: Option<String>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
/// Group Vote Plans
pub(crate) struct GroupVotePlans(pub(crate) Vec<VotePlan>);

#[derive(Debug, Clone, PartialEq, Eq)]
/// Ballot
pub(crate) struct Ballot {
    /// Choice
    pub(crate) choices: ObjectiveChoices,
    /// Vote plans
    pub(crate) voteplans: GroupVotePlans,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
/// Proposal Ballot
pub(crate) struct ProposalBallot {
    /// Proposal ID
    pub(crate) proposal_id: ProposalId,
    /// Ballot
    pub(crate) ballot: Ballot,
}

#[derive(Debug, Clone, PartialEq, Eq)]
/// Objective Ballots
pub(crate) struct ObjectiveBallots {
    /// Objective ID
    pub(crate) objective_id: ObjectiveId,
    /// Ballots
    pub(crate) ballots: Vec<ProposalBallot>,
}
