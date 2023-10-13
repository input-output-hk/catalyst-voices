use super::{serialize_option_datetime_as_rfc3339, SerdeType};
use chrono::{DateTime, Utc};
use event_db::types::event::{
    Event, EventDetails, EventGoal, EventId, EventRegistration, EventSchedule, EventSummary,
    VotingPowerAlgorithm, VotingPowerSettings,
};
use rust_decimal::prelude::ToPrimitive;
use serde::{
    de::Deserializer,
    ser::{Error as _, Serializer},
    Deserialize, Serialize,
};

impl Serialize for SerdeType<&EventId> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        self.0 .0.serialize(serializer)
    }
}

impl Serialize for SerdeType<EventId> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl<'de> Deserialize<'de> for SerdeType<EventId> {
    fn deserialize<D>(deserializer: D) -> Result<SerdeType<EventId>, D::Error>
    where
        D: Deserializer<'de>,
    {
        Ok(EventId(i32::deserialize(deserializer)?).into())
    }
}

impl Serialize for SerdeType<&EventSummary> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct EventSummarySerde<'a> {
            id: SerdeType<&'a EventId>,
            name: &'a String,
            #[serde(
                skip_serializing_if = "Option::is_none",
                serialize_with = "serialize_option_datetime_as_rfc3339"
            )]
            starts: &'a Option<DateTime<Utc>>,
            #[serde(
                skip_serializing_if = "Option::is_none",
                serialize_with = "serialize_option_datetime_as_rfc3339"
            )]
            ends: &'a Option<DateTime<Utc>>,
            #[serde(
                skip_serializing_if = "Option::is_none",
                serialize_with = "serialize_option_datetime_as_rfc3339"
            )]
            reg_checked: &'a Option<DateTime<Utc>>,
            #[serde(rename = "final")]
            is_final: bool,
        }
        EventSummarySerde {
            id: SerdeType(&self.id),
            name: &self.name,
            starts: &self.starts,
            ends: &self.ends,
            reg_checked: &self.reg_checked,
            is_final: self.is_final,
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<EventSummary> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&VotingPowerAlgorithm> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        match self.0 {
            VotingPowerAlgorithm::ThresholdStakedADA => {
                "threshold_staked_ADA".serialize(serializer)
            }
        }
    }
}

impl Serialize for SerdeType<VotingPowerAlgorithm> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&VotingPowerSettings> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct VotingPowerSettingsSerde<'a> {
            alg: SerdeType<&'a VotingPowerAlgorithm>,
            #[serde(skip_serializing_if = "Option::is_none")]
            min_ada: Option<i64>,
            #[serde(skip_serializing_if = "Option::is_none")]
            max_pct: Option<f64>,
        }
        VotingPowerSettingsSerde {
            alg: SerdeType(&self.alg),
            min_ada: self.min_ada,
            max_pct: if let Some(max_pct) = &self.max_pct {
                Some(
                    max_pct
                        .to_f64()
                        .ok_or_else(|| S::Error::custom("cannot decimal convert to f64"))?,
                )
            } else {
                None
            },
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<VotingPowerSettings> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&EventRegistration> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct EventRegistrationSerde<'a> {
            #[serde(skip_serializing_if = "Option::is_none")]
            purpose: Option<i64>,
            #[serde(
                skip_serializing_if = "Option::is_none",
                serialize_with = "serialize_option_datetime_as_rfc3339"
            )]
            deadline: &'a Option<DateTime<Utc>>,
            #[serde(
                skip_serializing_if = "Option::is_none",
                serialize_with = "serialize_option_datetime_as_rfc3339"
            )]
            taken: &'a Option<DateTime<Utc>>,
        }
        EventRegistrationSerde {
            purpose: self.purpose,
            deadline: &self.deadline,
            taken: &self.taken,
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<EventRegistration> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&EventGoal> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct EventGoalSerde<'a> {
            idx: i32,
            name: &'a String,
        }
        EventGoalSerde {
            idx: self.idx,
            name: &self.name,
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<EventGoal> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&EventSchedule> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct EventScheduleSerde<'a> {
            #[serde(
                skip_serializing_if = "Option::is_none",
                serialize_with = "serialize_option_datetime_as_rfc3339"
            )]
            insight_sharing: &'a Option<DateTime<Utc>>,
            #[serde(
                skip_serializing_if = "Option::is_none",
                serialize_with = "serialize_option_datetime_as_rfc3339"
            )]
            proposal_submission: &'a Option<DateTime<Utc>>,
            #[serde(
                skip_serializing_if = "Option::is_none",
                serialize_with = "serialize_option_datetime_as_rfc3339"
            )]
            refine_proposals: &'a Option<DateTime<Utc>>,
            #[serde(
                skip_serializing_if = "Option::is_none",
                serialize_with = "serialize_option_datetime_as_rfc3339"
            )]
            finalize_proposals: &'a Option<DateTime<Utc>>,
            #[serde(
                skip_serializing_if = "Option::is_none",
                serialize_with = "serialize_option_datetime_as_rfc3339"
            )]
            proposal_assessment: &'a Option<DateTime<Utc>>,
            #[serde(
                skip_serializing_if = "Option::is_none",
                serialize_with = "serialize_option_datetime_as_rfc3339"
            )]
            assessment_qa_start: &'a Option<DateTime<Utc>>,
            #[serde(
                skip_serializing_if = "Option::is_none",
                serialize_with = "serialize_option_datetime_as_rfc3339"
            )]
            voting: &'a Option<DateTime<Utc>>,
            #[serde(
                skip_serializing_if = "Option::is_none",
                serialize_with = "serialize_option_datetime_as_rfc3339"
            )]
            tallying: &'a Option<DateTime<Utc>>,
            #[serde(
                skip_serializing_if = "Option::is_none",
                serialize_with = "serialize_option_datetime_as_rfc3339"
            )]
            tallying_end: &'a Option<DateTime<Utc>>,
        }
        EventScheduleSerde {
            insight_sharing: &self.insight_sharing,
            proposal_submission: &self.proposal_submission,
            refine_proposals: &self.refine_proposals,
            finalize_proposals: &self.finalize_proposals,
            proposal_assessment: &self.proposal_assessment,
            assessment_qa_start: &self.assessment_qa_start,
            voting: &self.voting,
            tallying: &self.tallying,
            tallying_end: &self.tallying_end,
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<EventSchedule> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&EventDetails> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct EventDetailsSerde<'a> {
            voting_power: SerdeType<&'a VotingPowerSettings>,
            registration: SerdeType<&'a EventRegistration>,
            schedule: SerdeType<&'a EventSchedule>,
            goals: Vec<SerdeType<&'a EventGoal>>,
        }
        EventDetailsSerde {
            voting_power: SerdeType(&self.voting_power),
            registration: SerdeType(&self.registration),
            schedule: SerdeType(&self.schedule),
            goals: self.goals.iter().map(SerdeType).collect(),
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<EventDetails> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&Event> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        pub struct EventSerde<'a> {
            #[serde(flatten)]
            summary: SerdeType<&'a EventSummary>,
            #[serde(flatten)]
            details: SerdeType<&'a EventDetails>,
        }

        let val = EventSerde {
            summary: SerdeType(&self.summary),
            details: SerdeType(&self.details),
        };
        val.serialize(serializer)
    }
}

impl Serialize for SerdeType<Event> {
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
    use rust_decimal::Decimal;
    use serde_json::json;

    #[test]
    fn event_id_json_test() {
        let event_id = SerdeType(EventId(1));

        let json = serde_json::to_value(&event_id).unwrap();
        assert_eq!(json, json!(1));

        let expected: SerdeType<EventId> = serde_json::from_value(json).unwrap();
        assert_eq!(expected, event_id);
    }

    #[test]
    fn event_summary_json_test() {
        let event_summary = SerdeType(EventSummary {
            id: EventId(1),
            name: "Fund 10".to_string(),
            starts: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
            ends: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
            reg_checked: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
            is_final: true,
        });

        let json = serde_json::to_value(event_summary).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "id": 1,
                    "name": "Fund 10",
                    "starts": "1970-01-01T00:00:00+00:00",
                    "ends": "1970-01-01T00:00:00+00:00",
                    "final": true,
                    "reg_checked": "1970-01-01T00:00:00+00:00",
                }
            )
        );

        let event_summary = SerdeType(EventSummary {
            id: EventId(1),
            name: "Fund 10".to_string(),
            starts: None,
            ends: None,
            reg_checked: None,
            is_final: true,
        });

        let json = serde_json::to_value(event_summary).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "id": 1,
                    "name": "Fund 10",
                    "final": true,
                }
            )
        );
    }

    #[test]
    fn voting_power_algorithm_json_test() {
        let voting_power_algorithm = SerdeType(VotingPowerAlgorithm::ThresholdStakedADA);

        let json = serde_json::to_value(voting_power_algorithm).unwrap();
        assert_eq!(json, json!("threshold_staked_ADA"))
    }

    #[test]
    fn voting_power_settings_json_test() {
        let voting_power_settings = SerdeType(VotingPowerSettings {
            alg: VotingPowerAlgorithm::ThresholdStakedADA,
            min_ada: Some(500),
            max_pct: Some(Decimal::new(123, 2)),
        });

        let json = serde_json::to_value(voting_power_settings).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "alg": "threshold_staked_ADA",
                    "min_ada": 500,
                    "max_pct": 1.23
                }
            )
        );

        let voting_power_settings = SerdeType(VotingPowerSettings {
            alg: VotingPowerAlgorithm::ThresholdStakedADA,
            min_ada: None,
            max_pct: None,
        });

        let json = serde_json::to_value(voting_power_settings).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "alg": "threshold_staked_ADA",
                }
            )
        );
    }

    #[test]
    fn event_registration_json_test() {
        let event_registration = SerdeType(EventRegistration {
            purpose: Some(1),
            deadline: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
            taken: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
        });

        let json = serde_json::to_value(event_registration).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "purpose": 1,
                    "deadline": "1970-01-01T00:00:00+00:00",
                    "taken": "1970-01-01T00:00:00+00:00",
                }
            )
        );

        let event_registration = SerdeType(EventRegistration {
            purpose: None,
            deadline: None,
            taken: None,
        });

        let json = serde_json::to_value(event_registration).unwrap();
        assert_eq!(json, json!({}));
    }

    #[test]
    fn event_goal_json_test() {
        let event_goal = SerdeType(EventGoal {
            idx: 1,
            name: "Fund 10".to_string(),
        });

        let json = serde_json::to_value(event_goal).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "idx": 1,
                    "name": "Fund 10",
                }
            )
        );
    }

    #[test]
    fn event_schedule_json_test() {
        let event_schedule = SerdeType(EventSchedule {
            insight_sharing: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
            proposal_submission: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
            refine_proposals: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
            finalize_proposals: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
            proposal_assessment: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
            assessment_qa_start: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
            voting: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
            tallying: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
            tallying_end: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
        });

        let json = serde_json::to_value(event_schedule).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "insight_sharing": "1970-01-01T00:00:00+00:00",
                    "proposal_submission": "1970-01-01T00:00:00+00:00",
                    "refine_proposals": "1970-01-01T00:00:00+00:00",
                    "finalize_proposals": "1970-01-01T00:00:00+00:00",
                    "proposal_assessment": "1970-01-01T00:00:00+00:00",
                    "assessment_qa_start": "1970-01-01T00:00:00+00:00",
                    "voting": "1970-01-01T00:00:00+00:00",
                    "tallying": "1970-01-01T00:00:00+00:00",
                    "tallying_end": "1970-01-01T00:00:00+00:00",
                }
            )
        );

        let event_schedule = SerdeType(EventSchedule {
            insight_sharing: None,
            proposal_submission: None,
            refine_proposals: None,
            finalize_proposals: None,
            proposal_assessment: None,
            assessment_qa_start: None,
            voting: None,
            tallying: None,
            tallying_end: None,
        });

        let json = serde_json::to_value(event_schedule).unwrap();
        assert_eq!(json, json!({}));
    }

    #[test]
    fn event_details_json_test() {
        let event_details = SerdeType(EventDetails {
            voting_power: VotingPowerSettings {
                alg: VotingPowerAlgorithm::ThresholdStakedADA,
                min_ada: Some(500),
                max_pct: Some(Decimal::new(123, 2)),
            },
            registration: EventRegistration {
                purpose: Some(1),
                deadline: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
                taken: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
            },
            schedule: EventSchedule {
                insight_sharing: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
                proposal_submission: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
                refine_proposals: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
                finalize_proposals: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
                proposal_assessment: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
                assessment_qa_start: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
                voting: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
                tallying: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
                tallying_end: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
            },
            goals: vec![],
        });

        let json = serde_json::to_value(event_details).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "voting_power": {
                        "alg": "threshold_staked_ADA",
                        "min_ada": 500,
                        "max_pct": 1.23
                    },
                    "registration": {
                        "purpose": 1,
                        "deadline": "1970-01-01T00:00:00+00:00",
                        "taken": "1970-01-01T00:00:00+00:00",
                    },
                    "schedule": {
                        "insight_sharing": "1970-01-01T00:00:00+00:00",
                        "proposal_submission": "1970-01-01T00:00:00+00:00",
                        "refine_proposals": "1970-01-01T00:00:00+00:00",
                        "finalize_proposals": "1970-01-01T00:00:00+00:00",
                        "proposal_assessment": "1970-01-01T00:00:00+00:00",
                        "assessment_qa_start": "1970-01-01T00:00:00+00:00",
                        "voting": "1970-01-01T00:00:00+00:00",
                        "tallying": "1970-01-01T00:00:00+00:00",
                        "tallying_end": "1970-01-01T00:00:00+00:00",
                    },
                    "goals": [],
                }
            )
        )
    }

    #[test]
    fn event_json_test() {
        let event = SerdeType(Event {
            summary: EventSummary {
                id: EventId(1),
                name: "Fund 10".to_string(),
                starts: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
                ends: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
                reg_checked: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
                is_final: true,
            },
            details: EventDetails {
                voting_power: VotingPowerSettings {
                    alg: VotingPowerAlgorithm::ThresholdStakedADA,
                    min_ada: Some(500),
                    max_pct: Some(Decimal::new(123, 2)),
                },
                registration: EventRegistration {
                    purpose: Some(1),
                    deadline: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
                    taken: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
                },
                schedule: EventSchedule {
                    insight_sharing: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
                    proposal_submission: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
                    refine_proposals: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
                    finalize_proposals: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
                    proposal_assessment: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
                    assessment_qa_start: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
                    voting: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
                    tallying: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
                    tallying_end: Some(DateTime::from_utc(NaiveDateTime::default(), Utc)),
                },
                goals: vec![],
            },
        });

        let json = serde_json::to_value(event).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "id": 1,
                    "name": "Fund 10",
                    "starts": "1970-01-01T00:00:00+00:00",
                    "ends": "1970-01-01T00:00:00+00:00",
                    "final": true,
                    "reg_checked": "1970-01-01T00:00:00+00:00",
                    "voting_power": {
                        "alg": "threshold_staked_ADA",
                        "min_ada": 500,
                        "max_pct": 1.23
                    },
                    "registration": {
                        "purpose": 1,
                        "deadline": "1970-01-01T00:00:00+00:00",
                        "taken": "1970-01-01T00:00:00+00:00",
                    },
                    "schedule": {
                        "insight_sharing": "1970-01-01T00:00:00+00:00",
                        "proposal_submission": "1970-01-01T00:00:00+00:00",
                        "refine_proposals": "1970-01-01T00:00:00+00:00",
                        "finalize_proposals": "1970-01-01T00:00:00+00:00",
                        "proposal_assessment": "1970-01-01T00:00:00+00:00",
                        "assessment_qa_start": "1970-01-01T00:00:00+00:00",
                        "voting": "1970-01-01T00:00:00+00:00",
                        "tallying": "1970-01-01T00:00:00+00:00",
                        "tallying_end": "1970-01-01T00:00:00+00:00",
                    },
                    "goals": [],
                }
            )
        )
    }
}
