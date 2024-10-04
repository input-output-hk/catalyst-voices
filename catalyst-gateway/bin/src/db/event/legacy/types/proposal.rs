//! Proposal Types
use serde_json::Value;

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
/// Proposal ID
pub(crate) struct ProposalId(pub(crate) i32);

#[derive(Debug, Clone, PartialEq, Eq)]
/// Proposer Details
pub(crate) struct ProposerDetails {
    /// Proposer name
    pub(crate) name: String,
    /// Proposer email
    pub(crate) email: String,
    /// Proposer URL
    pub(crate) url: String,
    /// Proposer payment key
    pub(crate) payment_key: String,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
/// Proposal Details
pub(crate) struct ProposalDetails {
    /// Funds requested
    pub(crate) funds: i64,
    /// Proposal url
    pub(crate) url: String,
    /// Proposal files
    pub(crate) files: String,
    /// The proposer
    pub(crate) proposer: Vec<ProposerDetails>,
    /// Supplemental data
    pub(crate) supplemental: Option<Value>,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
/// Proposal Summary
pub(crate) struct ProposalSummary {
    /// Proposal ID
    pub(crate) id: ProposalId,
    /// Title
    pub(crate) title: String,
    /// Summary
    pub(crate) summary: String,
    /// Deleted
    pub(crate) deleted: bool,
}

#[derive(Debug, Clone, PartialEq, Eq)]
/// Proposal
pub(crate) struct Proposal {
    /// Proposal summary
    pub(crate) summary: ProposalSummary,
    /// Proposal details
    pub(crate) details: ProposalDetails,
}
