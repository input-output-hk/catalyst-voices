use serde_json::Value;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ProposalId(pub i32);

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ProposerDetails {
    pub name: String,
    pub email: String,
    pub url: String,
    pub payment_key: String,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ProposalDetails {
    pub funds: i64,
    pub url: String,
    pub files: String,
    pub proposer: Vec<ProposerDetails>,
    pub supplemental: Option<Value>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ProposalSummary {
    pub id: ProposalId,
    pub title: String,
    pub summary: String,
    pub deleted: bool,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Proposal {
    pub summary: ProposalSummary,
    pub details: ProposalDetails,
}
