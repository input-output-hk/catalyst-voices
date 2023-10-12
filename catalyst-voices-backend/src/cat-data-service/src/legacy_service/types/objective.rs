use super::SerdeType;
use event_db::types::{
    objective::{
        Objective, ObjectiveDetails, ObjectiveId, ObjectiveSummary, ObjectiveType, RewardDefintion,
        VoterGroup,
    },
    registration::VoterGroupId,
};
use serde::{de::Deserializer, ser::Serializer, Deserialize, Serialize};
use serde_json::Value;

impl Serialize for SerdeType<&ObjectiveId> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        self.0 .0.serialize(serializer)
    }
}

impl Serialize for SerdeType<ObjectiveId> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl<'de> Deserialize<'de> for SerdeType<ObjectiveId> {
    fn deserialize<D>(deserializer: D) -> Result<SerdeType<ObjectiveId>, D::Error>
    where
        D: Deserializer<'de>,
    {
        Ok(ObjectiveId(i32::deserialize(deserializer)?).into())
    }
}

impl Serialize for SerdeType<&ObjectiveType> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct ObjectiveTypeSerde<'a> {
            id: &'a String,
            description: &'a String,
        }
        ObjectiveTypeSerde {
            id: &self.id,
            description: &self.description,
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<ObjectiveType> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&ObjectiveSummary> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct ObjectiveSummarySerde<'a> {
            id: SerdeType<&'a ObjectiveId>,
            #[serde(rename = "type")]
            objective_type: SerdeType<&'a ObjectiveType>,
            title: &'a String,
            description: &'a String,
            deleted: bool,
        }
        ObjectiveSummarySerde {
            id: SerdeType(&self.id),
            objective_type: SerdeType(&self.objective_type),
            title: &self.title,
            description: &self.description,
            deleted: self.deleted,
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<ObjectiveSummary> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&RewardDefintion> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct RewardDefintionSerde<'a> {
            currency: &'a String,
            value: i64,
        }
        RewardDefintionSerde {
            currency: &self.currency,
            value: self.value,
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<RewardDefintion> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&VoterGroup> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct VoterGroupSerde<'a> {
            #[serde(skip_serializing_if = "Option::is_none")]
            group: Option<SerdeType<&'a VoterGroupId>>,
            #[serde(skip_serializing_if = "Option::is_none")]
            voting_token: &'a Option<String>,
        }
        VoterGroupSerde {
            group: self.group.as_ref().map(SerdeType),
            voting_token: &self.voting_token,
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<VoterGroup> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&ObjectiveDetails> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct ObjectiveDetailsSerde<'a> {
            groups: Vec<SerdeType<&'a VoterGroup>>,
            #[serde(skip_serializing_if = "Option::is_none")]
            reward: Option<SerdeType<&'a RewardDefintion>>,
            #[serde(skip_serializing_if = "Option::is_none")]
            supplemental: &'a Option<Value>,
        }
        ObjectiveDetailsSerde {
            groups: self.groups.iter().map(SerdeType).collect(),
            reward: self.reward.as_ref().map(SerdeType),
            supplemental: &self.supplemental,
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<ObjectiveDetails> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&Objective> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        pub struct ObjectiveSerde<'a> {
            #[serde(flatten)]
            summary: SerdeType<&'a ObjectiveSummary>,
            #[serde(flatten)]
            details: SerdeType<&'a ObjectiveDetails>,
        }

        let val = ObjectiveSerde {
            summary: SerdeType(&self.summary),
            details: SerdeType(&self.details),
        };
        val.serialize(serializer)
    }
}

impl Serialize for SerdeType<Objective> {
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
    use event_db::types::registration::VoterGroupId;
    use serde_json::json;

    #[test]
    fn objective_id_json_test() {
        let objective_id = SerdeType(ObjectiveId(1));

        let json = serde_json::to_value(&objective_id).unwrap();
        assert_eq!(json, json!(1));

        let expected: SerdeType<ObjectiveId> = serde_json::from_value(json).unwrap();
        assert_eq!(expected, objective_id);
    }

    #[test]
    fn objective_type_json_test() {
        let objective_type = SerdeType(ObjectiveType {
            id: "catalyst-native".to_string(),
            description: "catalyst native type".to_string(),
        });

        let json = serde_json::to_value(objective_type).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "id": "catalyst-native",
                    "description": "catalyst native type",
                }
            )
        );
    }

    #[test]
    fn objective_summary_json_test() {
        let objective_summary = SerdeType(ObjectiveSummary {
            id: ObjectiveId(1),

            objective_type: ObjectiveType {
                id: "catalyst-native".to_string(),
                description: "catalyst native type".to_string(),
            },
            title: "objective 1".to_string(),
            description: "description 1".to_string(),
            deleted: false,
        });

        let json = serde_json::to_value(objective_summary).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "id": 1,
                    "type": {
                        "id": "catalyst-native",
                        "description": "catalyst native type",
                    },
                    "title": "objective 1",
                    "description": "description 1",
                    "deleted": false,
                }
            )
        );
    }

    #[test]
    fn reward_definition_json_test() {
        let reward_definition = SerdeType(RewardDefintion {
            currency: "ADA".to_string(),
            value: 100,
        });

        let json = serde_json::to_value(reward_definition).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "currency": "ADA",
                    "value": 100
                }
            )
        )
    }

    #[test]
    fn voter_group_json_test() {
        let voter_group = SerdeType(VoterGroup {
            group: Some(VoterGroupId("group".to_string())),
            voting_token: Some("token".to_string()),
        });

        let json = serde_json::to_value(voter_group).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "group": "group",
                    "voting_token": "token"
                }
            )
        );
    }

    #[test]
    fn objective_details_json_test() {
        let objective_details = SerdeType(ObjectiveDetails {
            groups: vec![VoterGroup {
                group: Some(VoterGroupId("group".to_string())),
                voting_token: Some("token".to_string()),
            }],
            reward: Some(RewardDefintion {
                currency: "ADA".to_string(),
                value: 100,
            }),
            supplemental: None,
        });

        let json = serde_json::to_value(objective_details).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "groups": [
                        {
                            "group": "group",
                            "voting_token": "token"
                        }
                    ],
                    "reward": {
                        "currency": "ADA",
                        "value": 100
                    }
                }
            )
        )
    }

    #[test]
    fn objective_json_test() {
        let objective = SerdeType(Objective {
            summary: ObjectiveSummary {
                id: ObjectiveId(1),

                objective_type: ObjectiveType {
                    id: "catalyst-native".to_string(),
                    description: "catalyst native type".to_string(),
                },
                title: "objective 1".to_string(),
                description: "description 1".to_string(),
                deleted: false,
            },
            details: ObjectiveDetails {
                groups: vec![VoterGroup {
                    group: Some(VoterGroupId("group".to_string())),
                    voting_token: Some("token".to_string()),
                }],
                reward: Some(RewardDefintion {
                    currency: "ADA".to_string(),
                    value: 100,
                }),
                supplemental: None,
            },
        });

        let json = serde_json::to_value(objective).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "id": 1,
                    "type": {
                        "id": "catalyst-native",
                        "description": "catalyst native type",
                    },
                    "title": "objective 1",
                    "description": "description 1",
                    "deleted": false,
                    "groups": [
                        {
                            "group": "group",
                            "voting_token": "token"
                        }
                    ],
                    "reward": {
                        "currency": "ADA",
                        "value": 100
                    }
                }
            )
        )
    }
}
