use serde_json::Value;

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct ProposalId(pub(crate) i32);

#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct ProposerDetails {
    pub(crate) name: String,
    pub(crate) email: String,
    pub(crate) url: String,
    pub(crate) payment_key: String,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct ProposalDetails {
    pub(crate) funds: i64,
    pub(crate) url: String,
    pub(crate) files: String,
    pub(crate) proposer: Vec<ProposerDetails>,
    pub(crate) supplemental: Option<Value>,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct ProposalSummary {
    pub(crate) id: ProposalId,
    pub(crate) title: String,
    pub(crate) summary: String,
    pub(crate) deleted: bool,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct Proposal {
    pub(crate) summary: ProposalSummary,
    pub(crate) details: ProposalDetails,
}
