use super::SerdeType;
use event_db::types::{objective::ObjectiveId, voting_status::VotingStatus};
use serde::{ser::Serializer, Serialize};

impl Serialize for SerdeType<VotingStatus> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct VotingStatusSerde<'a> {
            objective_id: SerdeType<&'a ObjectiveId>,
            open: bool,
            #[serde(skip_serializing_if = "Option::is_none")]
            settings: Option<&'a String>,
        }
        VotingStatusSerde {
            objective_id: SerdeType(&self.objective_id),
            open: self.open,
            settings: self.settings.as_ref(),
        }
        .serialize(serializer)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use event_db::types::objective::ObjectiveId;
    use serde_json::json;

    #[test]
    fn voting_status_json_test() {
        let voting_status = SerdeType(VotingStatus {
            objective_id: ObjectiveId(1),
            open: false,
            settings: None,
        });

        let json = serde_json::to_value(voting_status).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "objective_id": 1,
                    "open": false,
                }
            )
        );

        let voting_status = SerdeType(VotingStatus {
            objective_id: ObjectiveId(1),
            open: true,
            settings: Some("some settings".to_string()),
        });

        let json = serde_json::to_value(voting_status).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "objective_id": 1,
                    "open": true,
                    "settings": "some settings",
                }
            )
        );
    }
}
