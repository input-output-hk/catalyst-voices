use super::SerdeType;
use event_db::types::proposal::{
    Proposal, ProposalDetails, ProposalId, ProposalSummary, ProposerDetails,
};
use serde::{de::Deserializer, ser::Serializer, Deserialize, Serialize};
use serde_json::Value;

impl Serialize for SerdeType<&ProposalId> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        self.0 .0.serialize(serializer)
    }
}

impl Serialize for SerdeType<ProposalId> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl<'de> Deserialize<'de> for SerdeType<ProposalId> {
    fn deserialize<D>(deserializer: D) -> Result<SerdeType<ProposalId>, D::Error>
    where
        D: Deserializer<'de>,
    {
        Ok(ProposalId(i32::deserialize(deserializer)?).into())
    }
}

impl Serialize for SerdeType<&ProposalSummary> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct ProposalSummarySerde<'a> {
            id: SerdeType<&'a ProposalId>,
            title: &'a String,
            summary: &'a String,
            deleted: bool,
        }
        ProposalSummarySerde {
            id: SerdeType(&self.id),
            title: &self.title,
            summary: &self.summary,
            deleted: self.deleted,
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<ProposalSummary> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&ProposerDetails> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct ProposerDetailsSerde<'a> {
            name: &'a String,
            email: &'a String,
            url: &'a String,
            payment_key: &'a String,
        }
        ProposerDetailsSerde {
            name: &self.name,
            email: &self.email,
            url: &self.url,
            payment_key: &self.payment_key,
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<ProposerDetails> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&ProposalDetails> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct ProposalDetailsSerde<'a> {
            funds: i64,
            url: &'a String,
            files: &'a String,
            proposer: Vec<SerdeType<&'a ProposerDetails>>,
            #[serde(skip_serializing_if = "Option::is_none")]
            supplemental: &'a Option<Value>,
        }
        ProposalDetailsSerde {
            funds: self.funds,
            url: &self.url,
            files: &self.files,
            proposer: self.proposer.iter().map(SerdeType).collect(),
            supplemental: &self.supplemental,
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<ProposalDetails> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&Proposal> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        pub struct ProposalSerde<'a> {
            #[serde(flatten)]
            summary: SerdeType<&'a ProposalSummary>,
            #[serde(flatten)]
            details: SerdeType<&'a ProposalDetails>,
        }

        let val = ProposalSerde {
            summary: SerdeType(&self.summary),
            details: SerdeType(&self.details),
        };
        val.serialize(serializer)
    }
}

impl Serialize for SerdeType<Proposal> {
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
    fn proposal_id_json_test() {
        let proposal_id = SerdeType(ProposalId(1));

        let json = serde_json::to_value(&proposal_id).unwrap();
        assert_eq!(json, json!(1));

        let expected: SerdeType<ProposalId> = serde_json::from_value(json).unwrap();
        assert_eq!(expected, proposal_id);
    }

    #[test]
    fn proposal_summary_json_test() {
        let proposal_summary = SerdeType(ProposalSummary {
            id: ProposalId(1),
            title: "title".to_string(),
            summary: "summary".to_string(),
            deleted: false,
        });

        let json = serde_json::to_value(proposal_summary).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "id": 1,
                    "title": "title",
                    "summary": "summary",
                    "deleted": false,
                }
            )
        )
    }

    #[test]
    fn proposer_details_json_test() {
        let proposer_details = SerdeType(ProposerDetails {
            name: "proposer name".to_string(),
            email: "proposer email".to_string(),
            url: "proposer url".to_string(),
            payment_key: "proposer payment key".to_string(),
        });

        let json = serde_json::to_value(proposer_details).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "name": "proposer name",
                    "email": "proposer email",
                    "url": "proposer url",
                    "payment_key": "proposer payment key",
                }
            )
        );
    }

    #[test]
    fn proposal_details_json_test() {
        let proposal_details = SerdeType(ProposalDetails {
            funds: 1,
            url: "url".to_string(),
            files: "files".to_string(),
            proposer: vec![],
            supplemental: Some(json!({})),
        });

        let json = serde_json::to_value(proposal_details).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "funds": 1,
                    "url": "url",
                    "files": "files",
                    "proposer": [],
                    "supplemental": {}
                }
            )
        );

        let proposal_details = SerdeType(ProposalDetails {
            funds: 1,
            url: "url".to_string(),
            files: "files".to_string(),
            proposer: vec![],
            supplemental: None,
        });

        let json = serde_json::to_value(proposal_details).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "funds": 1,
                    "url": "url",
                    "files": "files",
                    "proposer": [],
                }
            )
        )
    }

    #[test]
    fn proposal_json_test() {
        let proposal = SerdeType(Proposal {
            summary: ProposalSummary {
                id: ProposalId(1),
                title: "title".to_string(),
                summary: "summary".to_string(),
                deleted: false,
            },
            details: ProposalDetails {
                funds: 1,
                url: "url".to_string(),
                files: "files".to_string(),
                proposer: vec![],
                supplemental: None,
            },
        });

        let json = serde_json::to_value(proposal).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "id": 1,
                    "title": "title",
                    "summary": "summary",
                    "deleted": false,
                    "funds": 1,
                    "url": "url",
                    "files": "files",
                    "proposer": [],
                }
            )
        )
    }
}
