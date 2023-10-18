#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ChallengeHighlights {
    pub sponsor: String,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Challenge {
    // this is used only to retain the original insert order
    pub internal_id: i32,
    pub id: i32,
    pub challenge_type: String,
    pub title: String,
    pub description: String,
    pub rewards_total: i64,
    pub proposers_rewards: i64,
    pub fund_id: i32,
    pub challenge_url: String,
    pub highlights: Option<ChallengeHighlights>,
}
