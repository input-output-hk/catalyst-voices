use super::SerdeType;
use event_db::types::{
    ballot::{
        Ballot, BallotType, GroupVotePlans, ObjectiveBallots, ObjectiveChoices, ProposalBallot,
        VotePlan,
    },
    objective::ObjectiveId,
    proposal::ProposalId,
    registration::VoterGroupId,
};
use serde::{ser::Serializer, Serialize};

impl Serialize for SerdeType<&ObjectiveChoices> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        self.0 .0.serialize(serializer)
    }
}

impl Serialize for SerdeType<ObjectiveChoices> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&BallotType> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        self.0 .0.serialize(serializer)
    }
}

impl Serialize for SerdeType<BallotType> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&VotePlan> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct VotePlanSerde<'a> {
            chain_proposal_index: i64,
            #[serde(skip_serializing_if = "Option::is_none")]
            group: Option<SerdeType<&'a VoterGroupId>>,
            ballot_type: SerdeType<&'a BallotType>,
            chain_voteplan_id: &'a String,
            #[serde(skip_serializing_if = "Option::is_none")]
            encryption_key: &'a Option<String>,
        }
        VotePlanSerde {
            chain_proposal_index: self.chain_proposal_index,
            group: self.group.as_ref().map(SerdeType),
            ballot_type: SerdeType(&self.ballot_type),
            chain_voteplan_id: &self.chain_voteplan_id,
            encryption_key: &self.encryption_key,
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<VotePlan> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&GroupVotePlans> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        self.0
             .0
            .iter()
            .map(SerdeType)
            .collect::<Vec<_>>()
            .serialize(serializer)
    }
}

impl Serialize for SerdeType<GroupVotePlans> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&Ballot> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct BallotSerde<'a> {
            choices: SerdeType<&'a ObjectiveChoices>,
            voteplans: SerdeType<&'a GroupVotePlans>,
        }
        BallotSerde {
            choices: SerdeType(&self.choices),
            voteplans: SerdeType(&self.voteplans),
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<Ballot> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&ProposalBallot> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct ProposalBallotSerde<'a> {
            proposal_id: SerdeType<&'a ProposalId>,
            ballot: SerdeType<&'a Ballot>,
        }
        ProposalBallotSerde {
            proposal_id: SerdeType(&self.proposal_id),
            ballot: SerdeType(&self.ballot),
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<ProposalBallot> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&ObjectiveBallots> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct ObjectiveBallotsSerde<'a> {
            objective_id: SerdeType<&'a ObjectiveId>,
            ballots: Vec<SerdeType<&'a ProposalBallot>>,
        }
        ObjectiveBallotsSerde {
            objective_id: SerdeType(&self.objective_id),
            ballots: self.ballots.iter().map(SerdeType).collect(),
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<ObjectiveBallots> {
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
    use event_db::types::{
        registration::VoterGroupId,
        {
            ballot::{BallotType, GroupVotePlans, ObjectiveChoices},
            objective::ObjectiveId,
            proposal::ProposalId,
        },
    };
    use serde_json::json;

    #[test]
    fn vote_plan_json_test() {
        let vote_plan = SerdeType(VotePlan {
            chain_proposal_index: 1,
            group: Some(VoterGroupId("rep".to_string())),
            ballot_type: BallotType("public".to_string()),
            chain_voteplan_id: "chain_voteplan_id 1".to_string(),
            encryption_key: Some("encryption_key 1".to_string()),
        });

        let json = serde_json::to_value(vote_plan).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "chain_proposal_index": 1,
                    "group": "rep",
                    "ballot_type": "public",
                    "chain_voteplan_id": "chain_voteplan_id 1",
                    "encryption_key": "encryption_key 1"
                }
            )
        );

        let vote_plan = SerdeType(VotePlan {
            chain_proposal_index: 1,
            group: None,
            ballot_type: BallotType("public".to_string()),
            chain_voteplan_id: "chain_voteplan_id 1".to_string(),
            encryption_key: None,
        });

        let json = serde_json::to_value(vote_plan).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "chain_proposal_index": 1,
                    "ballot_type": "public",
                    "chain_voteplan_id": "chain_voteplan_id 1",
                }
            )
        );
    }

    #[test]
    fn ballot_json_test() {
        let ballot = SerdeType(Ballot {
            choices: ObjectiveChoices(vec![]),
            voteplans: GroupVotePlans(vec![]),
        });

        let json = serde_json::to_value(ballot).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "choices": [],
                    "voteplans": []
                }
            )
        );
    }

    #[test]
    fn proposal_ballot_json_test() {
        let ballot = SerdeType(ProposalBallot {
            proposal_id: ProposalId(1),
            ballot: Ballot {
                choices: ObjectiveChoices(vec![]),
                voteplans: GroupVotePlans(vec![]),
            },
        });

        let json = serde_json::to_value(ballot).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "proposal_id": 1,
                    "ballot": {
                        "choices": [],
                        "voteplans": []
                    }
                }
            )
        );
    }

    #[test]
    fn objective_ballots_json_test() {
        let ballot = SerdeType(ObjectiveBallots {
            objective_id: ObjectiveId(1),
            ballots: vec![],
        });

        let json = serde_json::to_value(ballot).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "objective_id": 1,
                    "ballots": []
                }
            )
        );
    }
}
