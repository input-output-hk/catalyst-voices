#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct ChallengeHighlights {
    pub(crate) sponsor: String,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct Challenge {
    // this is used only to retain the original insert order
    pub(crate) internal_id: i32,
    pub(crate) id: i32,
    pub(crate) c_type: String,
    pub(crate) title: String,
    pub(crate) description: String,
    pub(crate) rewards_total: i64,
    pub(crate) proposers_rewards: i64,
    pub(crate) fund_id: i32,
    pub(crate) url: String,
    pub(crate) highlights: Option<ChallengeHighlights>,
}
