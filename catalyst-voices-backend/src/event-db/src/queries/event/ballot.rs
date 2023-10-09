use crate::{
    error::Error,
    types::{
        registration::VoterGroupId,
        {
            ballot::{
                Ballot, BallotType, GroupVotePlans, ObjectiveBallots, ObjectiveChoices,
                ProposalBallot, VotePlan,
            },
            event::EventId,
            objective::ObjectiveId,
            proposal::ProposalId,
        },
    },
    EventDB,
};
use async_trait::async_trait;
use std::collections::HashMap;

#[async_trait]
pub trait BallotQueries: Sync + Send + 'static {
    async fn get_ballot(
        &self,
        event: EventId,
        objective: ObjectiveId,
        proposal: ProposalId,
    ) -> Result<Ballot, Error>;
    async fn get_objective_ballots(
        &self,
        event: EventId,
        objective: ObjectiveId,
    ) -> Result<Vec<ProposalBallot>, Error>;
    async fn get_event_ballots(&self, event: EventId) -> Result<Vec<ObjectiveBallots>, Error>;
}

impl EventDB {
    const BALLOT_VOTE_OPTIONS_QUERY: &'static str = "SELECT vote_options.objective
        FROM proposal
        INNER JOIN objective ON proposal.objective = objective.row_id
        INNER JOIN vote_options ON objective.vote_options = vote_options.id
        WHERE objective.event = $1 AND objective.id = $2 AND proposal.id = $3;";

    const BALLOT_VOTE_PLANS_QUERY: &'static str = "SELECT proposal_voteplan.bb_proposal_index,
        voteplan.id, voteplan.category, voteplan.encryption_key, voteplan.group_id
        FROM proposal_voteplan
        INNER JOIN proposal ON proposal_voteplan.proposal_id = proposal.row_id
        INNER JOIN voteplan ON proposal_voteplan.voteplan_id = voteplan.row_id
        INNER JOIN objective ON proposal.objective = objective.row_id
        WHERE objective.event = $1 AND objective.id = $2 AND proposal.id = $3;";

    const BALLOTS_VOTE_OPTIONS_PER_OBJECTIVE_QUERY: &'static str =
        "SELECT vote_options.objective, proposal.id as proposal_id
        FROM proposal
        INNER JOIN objective ON proposal.objective = objective.row_id
        INNER JOIN vote_options ON objective.vote_options = vote_options.id
        WHERE objective.event = $1 AND objective.id = $2;";

    const BALLOTS_VOTE_OPTIONS_PER_EVENT_QUERY: &'static str =
        "SELECT vote_options.objective, proposal.id as proposal_id, objective.id as objective_id
        FROM proposal
        INNER JOIN objective ON proposal.objective = objective.row_id
        INNER JOIN vote_options ON objective.vote_options = vote_options.id
        WHERE objective.event = $1;";
}

#[async_trait]
impl BallotQueries for EventDB {
    async fn get_ballot(
        &self,
        event: EventId,
        objective: ObjectiveId,
        proposal: ProposalId,
    ) -> Result<Ballot, Error> {
        let conn = self.pool.get().await?;

        let rows = conn
            .query(
                Self::BALLOT_VOTE_OPTIONS_QUERY,
                &[&event.0, &objective.0, &proposal.0],
            )
            .await?;
        let row = rows
            .get(0)
            .ok_or_else(|| Error::NotFound("cat not find ballot value".to_string()))?;
        let choices = row.try_get("objective")?;

        let rows = conn
            .query(
                Self::BALLOT_VOTE_PLANS_QUERY,
                &[&event.0, &objective.0, &proposal.0],
            )
            .await?;
        let mut voteplans = Vec::new();
        for row in rows {
            voteplans.push(VotePlan {
                chain_proposal_index: row.try_get("bb_proposal_index")?,
                group: row
                    .try_get::<_, Option<String>>("group_id")?
                    .map(VoterGroupId),
                ballot_type: BallotType(row.try_get("category")?),
                chain_voteplan_id: row.try_get("id")?,
                encryption_key: row.try_get("encryption_key")?,
            })
        }

        Ok(Ballot {
            choices: ObjectiveChoices(choices),
            voteplans: GroupVotePlans(voteplans),
        })
    }

    async fn get_objective_ballots(
        &self,
        event: EventId,
        objective: ObjectiveId,
    ) -> Result<Vec<ProposalBallot>, Error> {
        let conn = self.pool.get().await?;

        let rows = conn
            .query(
                Self::BALLOTS_VOTE_OPTIONS_PER_OBJECTIVE_QUERY,
                &[&event.0, &objective.0],
            )
            .await?;

        let mut ballots = Vec::new();
        for row in rows {
            let choices = row.try_get("objective")?;
            let proposal_id = ProposalId(row.try_get("proposal_id")?);

            let rows = conn
                .query(
                    Self::BALLOT_VOTE_PLANS_QUERY,
                    &[&event.0, &objective.0, &proposal_id.0],
                )
                .await?;
            let mut voteplans = Vec::new();
            for row in rows {
                voteplans.push(VotePlan {
                    chain_proposal_index: row.try_get("bb_proposal_index")?,
                    group: row
                        .try_get::<_, Option<String>>("group_id")?
                        .map(VoterGroupId),
                    ballot_type: BallotType(row.try_get("category")?),
                    chain_voteplan_id: row.try_get("id")?,
                    encryption_key: row.try_get("encryption_key")?,
                })
            }

            ballots.push(ProposalBallot {
                proposal_id,
                ballot: Ballot {
                    choices: ObjectiveChoices(choices),
                    voteplans: GroupVotePlans(voteplans),
                },
            })
        }
        Ok(ballots)
    }

    async fn get_event_ballots(&self, event: EventId) -> Result<Vec<ObjectiveBallots>, Error> {
        let conn = self.pool.get().await?;

        let rows = conn
            .query(Self::BALLOTS_VOTE_OPTIONS_PER_EVENT_QUERY, &[&event.0])
            .await?;
        let mut ballots = HashMap::<ObjectiveId, Vec<ProposalBallot>>::new();
        for row in rows {
            let choices = row.try_get("objective")?;
            let proposal_id = ProposalId(row.try_get("proposal_id")?);
            let objective_id = ObjectiveId(row.try_get("objective_id")?);

            let rows = conn
                .query(
                    Self::BALLOT_VOTE_PLANS_QUERY,
                    &[&event.0, &objective_id.0, &proposal_id.0],
                )
                .await?;
            let mut voteplans = Vec::new();
            for row in rows {
                voteplans.push(VotePlan {
                    chain_proposal_index: row.try_get("bb_proposal_index")?,
                    group: row
                        .try_get::<_, Option<String>>("group_id")?
                        .map(VoterGroupId),
                    ballot_type: BallotType(row.try_get("category")?),
                    chain_voteplan_id: row.try_get("id")?,
                    encryption_key: row.try_get("encryption_key")?,
                })
            }
            let ballot = ProposalBallot {
                proposal_id,
                ballot: Ballot {
                    choices: ObjectiveChoices(choices),
                    voteplans: GroupVotePlans(voteplans),
                },
            };
            ballots
                .entry(objective_id)
                .and_modify(|ballots| ballots.push(ballot.clone()))
                .or_insert_with(|| vec![ballot]);
        }

        Ok(ballots
            .into_iter()
            .map(|(objective_id, ballots)| ObjectiveBallots {
                objective_id,
                ballots,
            })
            .collect())
    }
}

/// Need to setup and run a test event db instance
/// To do it you can use the following commands:
/// Prepare docker images
/// ```
/// earthly ./containers/event-db-migrations+docker --data=test
/// ```
/// Run event-db container
/// ```
/// docker-compose -f src/event-db/docker-compose.yml up migrations
/// ```
/// Also need establish `EVENT_DB_URL` env variable with the following value
/// ```
/// EVENT_DB_URL="postgres://catalyst-event-dev:CHANGE_ME@localhost/CatalystEventDev"
/// ```
/// https://github.com/input-output-hk/catalyst-core/tree/main/src/event-db/Readme.md
#[cfg(test)]
mod tests {
    use super::*;
    use crate::establish_connection;

    #[tokio::test]
    async fn get_ballot_test() {
        let event_db = establish_connection(None).await.unwrap();

        let ballot = event_db
            .get_ballot(EventId(1), ObjectiveId(1), ProposalId(10))
            .await
            .unwrap();

        assert_eq!(
            Ballot {
                choices: ObjectiveChoices(vec!["yes".to_string(), "no".to_string()]),
                voteplans: GroupVotePlans(vec![
                    VotePlan {
                        chain_proposal_index: 10,
                        group: Some(VoterGroupId("direct".to_string())),
                        ballot_type: BallotType("public".to_string()),
                        chain_voteplan_id: "1".to_string(),
                        encryption_key: None,
                    },
                    VotePlan {
                        chain_proposal_index: 12,
                        group: Some(VoterGroupId("rep".to_string())),
                        ballot_type: BallotType("public".to_string()),
                        chain_voteplan_id: "2".to_string(),
                        encryption_key: None,
                    }
                ]),
            },
            ballot,
        );
    }

    #[tokio::test]
    async fn get_objective_ballots_test() {
        let event_db = establish_connection(None).await.unwrap();

        let ballots = event_db
            .get_objective_ballots(EventId(1), ObjectiveId(1))
            .await
            .unwrap();

        assert_eq!(
            vec![
                ProposalBallot {
                    proposal_id: ProposalId(10),
                    ballot: Ballot {
                        choices: ObjectiveChoices(vec!["yes".to_string(), "no".to_string()]),
                        voteplans: GroupVotePlans(vec![
                            VotePlan {
                                chain_proposal_index: 10,
                                group: Some(VoterGroupId("direct".to_string())),
                                ballot_type: BallotType("public".to_string()),
                                chain_voteplan_id: "1".to_string(),
                                encryption_key: None,
                            },
                            VotePlan {
                                chain_proposal_index: 12,
                                group: Some(VoterGroupId("rep".to_string())),
                                ballot_type: BallotType("public".to_string()),
                                chain_voteplan_id: "2".to_string(),
                                encryption_key: None,
                            }
                        ]),
                    },
                },
                ProposalBallot {
                    proposal_id: ProposalId(20),
                    ballot: Ballot {
                        choices: ObjectiveChoices(vec!["yes".to_string(), "no".to_string()]),
                        voteplans: GroupVotePlans(vec![
                            VotePlan {
                                chain_proposal_index: 11,
                                group: Some(VoterGroupId("direct".to_string())),
                                ballot_type: BallotType("public".to_string()),
                                chain_voteplan_id: "1".to_string(),
                                encryption_key: None,
                            },
                            VotePlan {
                                chain_proposal_index: 13,
                                group: Some(VoterGroupId("rep".to_string())),
                                ballot_type: BallotType("public".to_string()),
                                chain_voteplan_id: "2".to_string(),
                                encryption_key: None,
                            }
                        ]),
                    },
                },
                ProposalBallot {
                    proposal_id: ProposalId(30),
                    ballot: Ballot {
                        choices: ObjectiveChoices(vec!["yes".to_string(), "no".to_string()]),
                        voteplans: GroupVotePlans(vec![]),
                    },
                }
            ],
            ballots,
        );
    }

    #[tokio::test]
    async fn get_event_ballots_test() {
        let event_db = establish_connection(None).await.unwrap();

        let ballots = event_db.get_event_ballots(EventId(1)).await.unwrap();

        assert_eq!(
            vec![ObjectiveBallots {
                objective_id: ObjectiveId(1),
                ballots: vec![
                    ProposalBallot {
                        proposal_id: ProposalId(10),
                        ballot: Ballot {
                            choices: ObjectiveChoices(vec!["yes".to_string(), "no".to_string()]),
                            voteplans: GroupVotePlans(vec![
                                VotePlan {
                                    chain_proposal_index: 10,
                                    group: Some(VoterGroupId("direct".to_string())),
                                    ballot_type: BallotType("public".to_string()),
                                    chain_voteplan_id: "1".to_string(),
                                    encryption_key: None,
                                },
                                VotePlan {
                                    chain_proposal_index: 12,
                                    group: Some(VoterGroupId("rep".to_string())),
                                    ballot_type: BallotType("public".to_string()),
                                    chain_voteplan_id: "2".to_string(),
                                    encryption_key: None,
                                }
                            ]),
                        },
                    },
                    ProposalBallot {
                        proposal_id: ProposalId(20),
                        ballot: Ballot {
                            choices: ObjectiveChoices(vec!["yes".to_string(), "no".to_string()]),
                            voteplans: GroupVotePlans(vec![
                                VotePlan {
                                    chain_proposal_index: 11,
                                    group: Some(VoterGroupId("direct".to_string())),
                                    ballot_type: BallotType("public".to_string()),
                                    chain_voteplan_id: "1".to_string(),
                                    encryption_key: None,
                                },
                                VotePlan {
                                    chain_proposal_index: 13,
                                    group: Some(VoterGroupId("rep".to_string())),
                                    ballot_type: BallotType("public".to_string()),
                                    chain_voteplan_id: "2".to_string(),
                                    encryption_key: None,
                                }
                            ]),
                        },
                    },
                    ProposalBallot {
                        proposal_id: ProposalId(30),
                        ballot: Ballot {
                            choices: ObjectiveChoices(vec!["yes".to_string(), "no".to_string()]),
                            voteplans: GroupVotePlans(vec![]),
                        },
                    }
                ]
            }],
            ballots
        );
    }
}
