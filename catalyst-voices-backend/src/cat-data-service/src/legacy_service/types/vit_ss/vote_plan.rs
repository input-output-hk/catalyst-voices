use super::super::{serialize_datetime_as_rfc3339, SerdeType};
use chrono::{DateTime, Utc};
use event_db::types::vit_ss::vote_plan::Voteplan;
use serde::{ser::Serializer, Serialize};

impl Serialize for SerdeType<&Voteplan> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct VoteplanSerde<'a> {
            id: i32,
            chain_voteplan_id: &'a String,
            #[serde(serialize_with = "serialize_datetime_as_rfc3339")]
            chain_vote_start_time: &'a DateTime<Utc>,
            #[serde(serialize_with = "serialize_datetime_as_rfc3339")]
            chain_vote_end_time: &'a DateTime<Utc>,
            #[serde(serialize_with = "serialize_datetime_as_rfc3339")]
            chain_committee_end_time: &'a DateTime<Utc>,
            chain_voteplan_payload: &'a String,
            chain_vote_encryption_key: &'a String,
            fund_id: i32,
            token_identifier: &'a String,
        }
        VoteplanSerde {
            id: self.id,
            chain_voteplan_id: &self.chain_voteplan_id,
            chain_vote_start_time: &self.chain_vote_start_time,
            chain_vote_end_time: &self.chain_vote_end_time,
            chain_committee_end_time: &self.chain_committee_end_time,
            chain_voteplan_payload: &self.chain_voteplan_payload,
            chain_vote_encryption_key: &self.chain_vote_encryption_key,
            fund_id: self.fund_id,
            token_identifier: &self.token_identifier,
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<Voteplan> {
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
    use chrono::NaiveDateTime;
    use serde_json::json;

    #[test]
    fn voteplan_json_test() {
        let voteplan = SerdeType(Voteplan {
            id: 1,
            chain_voteplan_id: "chain_voteplan_id 1".to_string(),
            chain_vote_start_time: DateTime::from_utc(NaiveDateTime::default(), Utc),
            chain_vote_end_time: DateTime::from_utc(NaiveDateTime::default(), Utc),
            chain_committee_end_time: DateTime::from_utc(NaiveDateTime::default(), Utc),
            chain_voteplan_payload: "chain_voteplan_payload 1".to_string(),
            chain_vote_encryption_key: "chain_vote_encryption_key 1".to_string(),
            fund_id: 1,
            token_identifier: "token_identifier 1".to_string(),
        });

        let json = serde_json::to_value(voteplan).unwrap();
        assert_eq!(
            json,
            json!(
                    {
                        "id": 1,
                        "chain_voteplan_id": "chain_voteplan_id 1",
                        "chain_vote_start_time": "1970-01-01T00:00:00+00:00",
                        "chain_vote_end_time": "1970-01-01T00:00:00+00:00",
                        "chain_committee_end_time": "1970-01-01T00:00:00+00:00",
                        "chain_voteplan_payload": "chain_voteplan_payload 1",
                        "chain_vote_encryption_key": "chain_vote_encryption_key 1",
                        "fund_id": 1,
                        "token_identifier": "token_identifier 1",
                    }
            )
        );
    }
}
