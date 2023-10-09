use crate::{
    error::Error,
    types::{
        event::EventId,
        objective::ObjectiveId,
        proposal::{Proposal, ProposalDetails, ProposalId, ProposalSummary, ProposerDetails},
    },
    EventDB,
};
use async_trait::async_trait;

#[async_trait]
pub trait ProposalQueries: Sync + Send + 'static {
    async fn get_proposal(
        &self,
        event: EventId,
        objective: ObjectiveId,
        proposal: ProposalId,
    ) -> Result<Proposal, Error>;

    async fn get_proposals(
        &self,
        // TODO: Voter Group: future state may require dreps
        event: EventId,
        obj_id: ObjectiveId,
        limit: Option<i64>,
        offset: Option<i64>,
    ) -> Result<Vec<ProposalSummary>, Error>;
}

impl EventDB {
    const PROPOSALS_QUERY: &'static str =
        "SELECT proposal.id, proposal.title, proposal.summary, proposal.deleted
        FROM proposal
        INNER JOIN objective on proposal.objective = objective.row_id
        WHERE objective.event = $1 AND objective.id = $2
        LIMIT $3 OFFSET $4;";

    const PROPOSAL_QUERY: &'static str =
        "SELECT proposal.id, proposal.title, proposal.summary, proposal.deleted, proposal.extra,
    proposal.funds, proposal.url, proposal.files_url,
    proposal.proposer_name, proposal.proposer_contact, proposal.proposer_url, proposal.public_key
    FROM proposal
    INNER JOIN objective on proposal.objective = objective.row_id
    WHERE objective.event = $1 AND objective.id = $2 AND proposal.id = $3;";
}

#[async_trait]
impl ProposalQueries for EventDB {
    async fn get_proposal(
        &self,
        event: EventId,
        objective: ObjectiveId,
        proposal: ProposalId,
    ) -> Result<Proposal, Error> {
        let conn: bb8::PooledConnection<
            bb8_postgres::PostgresConnectionManager<tokio_postgres::NoTls>,
        > = self.pool.get().await?;

        let rows = conn
            .query(Self::PROPOSAL_QUERY, &[&event.0, &objective.0, &proposal.0])
            .await?;
        let row = rows
            .get(0)
            .ok_or_else(|| Error::NotFound("cat not find proposal value".to_string()))?;

        let proposer = vec![ProposerDetails {
            name: row.try_get("proposer_name")?,
            email: row.try_get("proposer_contact")?,
            url: row.try_get("proposer_url")?,
            payment_key: row.try_get("public_key")?,
        }];

        let summary = ProposalSummary {
            id: ProposalId(row.try_get("id")?),
            title: row.try_get("title")?,
            summary: row.try_get("summary")?,
            deleted: row.try_get("deleted")?,
        };

        let details = ProposalDetails {
            proposer,
            supplemental: row.try_get("extra")?,
            funds: row.try_get("funds")?,
            url: row.try_get("url")?,
            files: row.try_get("files_url")?,
        };

        Ok(Proposal { details, summary })
    }

    async fn get_proposals(
        &self,
        event: EventId,
        objective: ObjectiveId,
        limit: Option<i64>,
        offset: Option<i64>,
    ) -> Result<Vec<ProposalSummary>, Error> {
        let conn = self.pool.get().await?;

        let rows = conn
            .query(
                Self::PROPOSALS_QUERY,
                &[&event.0, &objective.0, &limit, &offset.unwrap_or(0)],
            )
            .await?;

        let mut proposals = Vec::new();
        for row in rows {
            let summary = ProposalSummary {
                id: ProposalId(row.try_get("id")?),
                title: row.try_get("title")?,
                summary: row.try_get("summary")?,
                deleted: row.try_get("deleted")?,
            };

            proposals.push(summary);
        }

        Ok(proposals)
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
    use serde_json::json;

    #[tokio::test]
    async fn get_proposal_test() {
        let event_db = establish_connection(None).await.unwrap();

        let proposal = event_db
            .get_proposal(EventId(1), ObjectiveId(1), ProposalId(10))
            .await
            .unwrap();

        assert_eq!(
            Proposal {
                summary: ProposalSummary {
                    id: ProposalId(10),
                    title: String::from("title 1"),
                    summary: String::from("summary 1"),
                    deleted: false,
                },
                details: ProposalDetails {
                    funds: 100,
                    url: "url.xyz".to_string(),
                    files: "files.xyz".to_string(),
                    proposer: vec![ProposerDetails {
                        name: "alice".to_string(),
                        email: "alice@io".to_string(),
                        url: "alice.prop.xyz".to_string(),
                        payment_key:
                            "b7a3c12dc0c8c748ab07525b701122b88bd78f600c76342d27f25e5f92444cde"
                                .to_string()
                    }],
                    supplemental: Some(json!(
                        {
                            "brief": "Brief explanation of a proposal",
                            "goal": "The goal of the proposal is addressed to meet",
                            "importance": "The importance of the proposal",
                        }
                    )),
                }
            },
            proposal
        );
    }

    #[tokio::test]
    async fn get_proposals_test() {
        let event_db = establish_connection(None).await.unwrap();

        let proposal_summary = event_db
            .get_proposals(EventId(1), ObjectiveId(1), None, None)
            .await
            .unwrap();

        assert_eq!(
            vec![
                ProposalSummary {
                    id: ProposalId(10),
                    title: String::from("title 1"),
                    summary: String::from("summary 1"),
                    deleted: false
                },
                ProposalSummary {
                    id: ProposalId(20),
                    title: String::from("title 2"),
                    summary: String::from("summary 2"),
                    deleted: false
                },
                ProposalSummary {
                    id: ProposalId(30),
                    title: String::from("title 3"),
                    summary: String::from("summary 3"),
                    deleted: false
                }
            ],
            proposal_summary
        );

        let proposal_summary = event_db
            .get_proposals(EventId(1), ObjectiveId(1), Some(2), None)
            .await
            .unwrap();

        assert_eq!(
            vec![
                ProposalSummary {
                    id: ProposalId(10),
                    title: String::from("title 1"),
                    summary: String::from("summary 1"),
                    deleted: false
                },
                ProposalSummary {
                    id: ProposalId(20),
                    title: String::from("title 2"),
                    summary: String::from("summary 2"),
                    deleted: false
                },
            ],
            proposal_summary
        );

        let proposal_summary = event_db
            .get_proposals(EventId(1), ObjectiveId(1), None, Some(1))
            .await
            .unwrap();

        assert_eq!(
            vec![
                ProposalSummary {
                    id: ProposalId(20),
                    title: String::from("title 2"),
                    summary: String::from("summary 2"),
                    deleted: false
                },
                ProposalSummary {
                    id: ProposalId(30),
                    title: String::from("title 3"),
                    summary: String::from("summary 3"),
                    deleted: false
                }
            ],
            proposal_summary
        );

        let proposal_summary = event_db
            .get_proposals(EventId(1), ObjectiveId(1), Some(1), Some(1))
            .await
            .unwrap();

        assert_eq!(
            vec![ProposalSummary {
                id: ProposalId(20),
                title: String::from("title 2"),
                summary: String::from("summary 2"),
                deleted: false
            },],
            proposal_summary
        );
    }
}
