use super::{objective::ObjectiveId, proposal::ProposalId};
use crate::event_db::types::registration::VoterGroupId;

#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct ObjectiveChoices(pub(crate) Vec<String>);

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct BallotType(pub(crate) String);

#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct VotePlan {
    pub(crate) chain_proposal_index: i64,
    pub(crate) group: Option<VoterGroupId>,
    pub(crate) ballot_type: BallotType,
    pub(crate) chain_voteplan_id: String,
    pub(crate) encryption_key: Option<String>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct GroupVotePlans(pub(crate) Vec<VotePlan>);

#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct Ballot {
    pub(crate) choices: ObjectiveChoices,
    pub(crate) voteplans: GroupVotePlans,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct ProposalBallot {
    pub(crate) proposal_id: ProposalId,
    pub(crate) ballot: Ballot,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct ObjectiveBallots {
    pub(crate) objective_id: ObjectiveId,
    pub(crate) ballots: Vec<ProposalBallot>,
}
