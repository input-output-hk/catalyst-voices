use super::{serialize_datetime_as_rfc3339, SerdeType};
use chrono::{DateTime, Utc};
use event_db::types::registration::{
    Delegation, Delegator, RewardAddress, Voter, VoterGroupId, VoterInfo,
};
use serde::{de::Deserializer, ser::Serializer, Deserialize, Serialize};

impl Serialize for SerdeType<&VoterGroupId> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        self.0 .0.serialize(serializer)
    }
}

impl Serialize for SerdeType<VoterGroupId> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl<'de> Deserialize<'de> for SerdeType<VoterGroupId> {
    fn deserialize<D>(deserializer: D) -> Result<SerdeType<VoterGroupId>, D::Error>
    where
        D: Deserializer<'de>,
    {
        Ok(VoterGroupId(String::deserialize(deserializer)?).into())
    }
}

impl Serialize for SerdeType<&VoterInfo> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct VoterInfoSerde<'a> {
            voting_power: i64,
            voting_group: SerdeType<&'a VoterGroupId>,
            delegations_power: i64,
            delegations_count: i64,
            voting_power_saturation: f64,
            #[serde(skip_serializing_if = "Option::is_none")]
            delegator_addresses: &'a Option<Vec<String>>,
        }
        VoterInfoSerde {
            voting_power: self.voting_power,
            voting_group: SerdeType(&self.voting_group),
            delegations_power: self.delegations_power,
            delegations_count: self.delegations_count,
            voting_power_saturation: self.voting_power_saturation,
            delegator_addresses: &self.delegator_addresses,
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<VoterInfo> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&Voter> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct VoterSerde<'a> {
            voter_info: SerdeType<&'a VoterInfo>,
            #[serde(serialize_with = "serialize_datetime_as_rfc3339")]
            as_at: &'a DateTime<Utc>,
            #[serde(serialize_with = "serialize_datetime_as_rfc3339")]
            last_updated: &'a DateTime<Utc>,
            #[serde(rename = "final")]
            is_final: bool,
        }
        VoterSerde {
            voter_info: SerdeType(&self.voter_info),
            as_at: &self.as_at,
            last_updated: &self.last_updated,
            is_final: self.is_final,
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<Voter> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&Delegation> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct DelegationSerde<'a> {
            voting_key: &'a String,
            group: SerdeType<&'a VoterGroupId>,
            weight: i32,
            value: i64,
        }
        DelegationSerde {
            voting_key: &self.voting_key,
            group: SerdeType(&self.group),
            weight: self.weight,
            value: self.value,
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<Delegation> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&RewardAddress> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct RewardAddressSerde<'a> {
            reward_address: &'a str,
            reward_payable: bool,
        }
        RewardAddressSerde {
            reward_address: self.reward_address(),
            reward_payable: self.reward_payable(),
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<RewardAddress> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&Delegator> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct DelegatorSerde<'a> {
            delegations: Vec<SerdeType<&'a Delegation>>,
            #[serde(flatten)]
            reward_address: SerdeType<&'a RewardAddress>,
            raw_power: i64,
            total_power: i64,
            #[serde(serialize_with = "serialize_datetime_as_rfc3339")]
            as_at: &'a DateTime<Utc>,
            #[serde(serialize_with = "serialize_datetime_as_rfc3339")]
            last_updated: &'a DateTime<Utc>,
            #[serde(rename = "final")]
            is_final: bool,
        }
        DelegatorSerde {
            delegations: self.delegations.iter().map(SerdeType).collect(),
            reward_address: SerdeType(&self.reward_address),
            raw_power: self.raw_power,
            total_power: self.total_power,
            as_at: &self.as_at,
            last_updated: &self.last_updated,
            is_final: self.is_final,
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<Delegator> {
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
    use chrono::{DateTime, NaiveDateTime, Utc};
    use event_db::types::registration::RewardAddress;
    use serde_json::json;

    #[test]
    fn voter_group_id_json_test() {
        let voter_group_id = SerdeType(VoterGroupId("rep".to_string()));

        let json = serde_json::to_value(&voter_group_id).unwrap();
        assert_eq!(json, json!("rep"));

        let expected: SerdeType<VoterGroupId> = serde_json::from_value(json).unwrap();
        assert_eq!(expected, voter_group_id);
    }

    #[test]
    fn voter_info_json_test() {
        let voter_info = SerdeType(VoterInfo {
            voting_power: 100,
            voting_group: VoterGroupId("group".to_string()),
            delegations_power: 100,
            delegations_count: 1,
            voting_power_saturation: 1.0,
            delegator_addresses: Some(vec!["stake_public_key_1".to_string()]),
        });

        let json = serde_json::to_value(voter_info).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "voting_power": 100,
                    "voting_group": "group",
                    "delegations_power": 100,
                    "delegations_count": 1,
                    "voting_power_saturation": 1.0,
                    "delegator_addresses": ["stake_public_key_1"]
                }
            )
        );

        let voter_info = SerdeType(VoterInfo {
            voting_power: 100,
            voting_group: VoterGroupId("group".to_string()),
            delegations_power: 100,
            delegations_count: 1,
            voting_power_saturation: 1.0,
            delegator_addresses: None,
        });

        let json = serde_json::to_value(voter_info).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "voting_power": 100,
                    "voting_group": "group",
                    "delegations_power": 100,
                    "delegations_count": 1,
                    "voting_power_saturation": 1.0,
                }
            )
        );
    }

    #[test]
    fn voter_json_test() {
        let voter = SerdeType(Voter {
            voter_info: VoterInfo {
                voting_power: 100,
                voting_group: VoterGroupId("group".to_string()),
                delegations_power: 100,
                delegations_count: 1,
                voting_power_saturation: 1.0,
                delegator_addresses: None,
            },
            as_at: DateTime::from_utc(NaiveDateTime::default(), Utc),
            last_updated: DateTime::from_utc(NaiveDateTime::default(), Utc),
            is_final: true,
        });

        let json = serde_json::to_value(voter).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "voter_info": {
                        "voting_power": 100,
                        "voting_group": "group",
                        "delegations_power": 100,
                        "delegations_count": 1,
                        "voting_power_saturation": 1.0,
                    },
                    "as_at": "1970-01-01T00:00:00+00:00",
                    "last_updated": "1970-01-01T00:00:00+00:00",
                    "final": true
                }
            )
        )
    }

    #[test]
    fn delegation_json_test() {
        let delegation = SerdeType(Delegation {
            voting_key: "stake_public_key_1".to_string(),
            group: VoterGroupId("group".to_string()),
            weight: 100,
            value: 100,
        });

        let json = serde_json::to_value(delegation).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "voting_key": "stake_public_key_1",
                    "group": "group",
                    "weight": 100,
                    "value": 100,
                }
            )
        );
    }

    #[test]
    fn delegator_json_test() {
        let delegator = SerdeType(Delegator {
            delegations: vec![],
            reward_address: RewardAddress::new("stake_public_key_1".to_string()),
            raw_power: 100,
            total_power: 100,
            as_at: DateTime::from_utc(NaiveDateTime::default(), Utc),
            last_updated: DateTime::from_utc(NaiveDateTime::default(), Utc),
            is_final: true,
        });

        let json = serde_json::to_value(delegator).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "delegations": [],
                    "reward_address": "stake_public_key_1",
                    "reward_payable": false,
                    "raw_power": 100,
                    "total_power": 100,
                    "as_at": "1970-01-01T00:00:00+00:00",
                    "last_updated": "1970-01-01T00:00:00+00:00",
                    "final": true
                }
            )
        );
    }
}
