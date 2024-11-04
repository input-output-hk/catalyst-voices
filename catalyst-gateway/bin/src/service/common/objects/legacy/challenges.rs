//! Challenges objects for the legacy service.

use poem_openapi::{types::Example, Object};

/// Challenges query object.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct Challenge {
    /// Challenge ID.
    id: i32,
    /// Challenge type.
    challenge_type: ChallengeType,
    /// Challenge title.
    title: String,
    /// Challenge description.
    description: String,
    /// Total rewards.
    rewards_total: i64,
    /// Fund ID.
    fund_id: i64,
    /// Challenge URL.
    challenge_url: String,
    /// Challenge highlights.
    highlights: ChallengeHighlights,
}

impl Example for Challenge {
    fn example() -> Self {
        Self {
            id: 1,
            challenge_type: ChallengeType::Simple,
            title: "title example".to_string(),
            description: "description example".to_string(),
            rewards_total: 100,
            fund_id: 1,
            challenge_url: "https://example.com".to_string(),
            highlights: ChallengeHighlights::example(),
        }
    }
}

#[derive(poem_openapi::Enum)]
pub(crate) enum ChallengeType {
    /// Simple challenge type.
    Simple,
    /// Community choice challenge type.
    CommunityChoice,
}

/// Search query object.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct ChallengeHighlights {
    /// Sponsor of the challenge.
    sponsor: String,
}

impl Example for ChallengeHighlights {
    fn example() -> Self {
        Self {
            sponsor: "sponsor example".to_string(),
        }
    }
}

#[derive(Object)]
#[oai(example = true)]
pub(crate) struct BadRequest {
    error: String,
}

impl Example for BadRequest {
    fn example() -> Self {
        Self {
            error: "The requested challenge was not found".to_string(),
        }
    }
}