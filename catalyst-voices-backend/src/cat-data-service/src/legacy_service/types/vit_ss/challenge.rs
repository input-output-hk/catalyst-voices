use super::super::SerdeType;
use event_db::types::vit_ss::challenge::{Challenge, ChallengeHighlights};
use serde::{ser::Serializer, Serialize};

impl Serialize for SerdeType<&ChallengeHighlights> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct ChallengeHighlightsSerde<'a> {
            sponsor: &'a String,
        }
        ChallengeHighlightsSerde {
            sponsor: &self.sponsor,
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<ChallengeHighlights> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&Challenge> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct ChallengeSerde<'a> {
            internal_id: i32,
            id: i32,
            challenge_type: &'a String,
            title: &'a String,
            description: &'a String,
            rewards_total: i64,
            proposers_rewards: i64,
            fund_id: i32,
            challenge_url: &'a String,
            highlights: Option<SerdeType<&'a ChallengeHighlights>>,
        }
        ChallengeSerde {
            internal_id: self.internal_id,
            id: self.id,
            challenge_type: &self.challenge_type,
            title: &self.title,
            description: &self.description,
            rewards_total: self.rewards_total,
            proposers_rewards: self.proposers_rewards,
            fund_id: self.fund_id,
            challenge_url: &self.challenge_url,
            highlights: self.highlights.as_ref().map(SerdeType),
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<Challenge> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::json;

    #[test]
    fn challenge_highlights_json_test() {
        let highlights = SerdeType(ChallengeHighlights {
            sponsor: "sponsor 1".to_string(),
        });

        let json = serde_json::to_value(highlights).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "sponsor": "sponsor 1",
                }
            )
        );
    }

    #[test]
    fn challenge_json_test() {
        let challenge = SerdeType(Challenge {
            internal_id: 1,
            id: 1,
            challenge_type: "catalyst-simple".to_string(),
            title: "title 1".to_string(),
            description: "description 1".to_string(),
            rewards_total: 1,
            proposers_rewards: 1,
            fund_id: 1,
            challenge_url: "url 1".to_string(),
            highlights: None,
        });

        let json = serde_json::to_value(challenge).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "internal_id": 1,
                    "id": 1,
                    "challenge_type": "catalyst-simple",
                    "title": "title 1",
                    "description": "description 1",
                    "rewards_total": 1,
                    "proposers_rewards": 1,
                    "fund_id": 1,
                    "challenge_url": "url 1",
                    "highlights": null
                }
            )
        );
    }
}
