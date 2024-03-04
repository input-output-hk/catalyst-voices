//! Proposal Queries
use async_trait::async_trait;

use crate::event_db::{
    error::Error,
    legacy::types::{
        event::EventId,
        objective::ObjectiveId,
        proposal::{Proposal, ProposalDetails, ProposalId, ProposalSummary, ProposerDetails},
    },
    EventDB,
};

#[async_trait]
#[allow(clippy::module_name_repetitions)]
/// Proposal Queries Trait
pub(crate) trait ProposalQueries: Sync + Send + 'static {
    async fn get_proposal(
        &self, event: EventId, objective: ObjectiveId, proposal: ProposalId,
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
    /// Proposals query template
    const PROPOSALS_QUERY: &'static str =
        "SELECT proposal.id, proposal.title, proposal.summary, proposal.deleted
        FROM proposal
        INNER JOIN objective on proposal.objective = objective.row_id
        WHERE objective.event = $1 AND objective.id = $2
        LIMIT $3 OFFSET $4;";
    /// Proposal details query template
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
        &self, event: EventId, objective: ObjectiveId, proposal: ProposalId,
    ) -> Result<Proposal, Error> {
        let conn: bb8::PooledConnection<
            bb8_postgres::PostgresConnectionManager<tokio_postgres::NoTls>,
        > = self.pool.get().await?;

        let rows = conn
            .query(Self::PROPOSAL_QUERY, &[&event.0, &objective.0, &proposal.0])
            .await?;
        let row = rows
            .first()
            .ok_or_else(|| Error::NotFound("Cannot find proposal value".to_string()))?;

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

        Ok(Proposal { summary, details })
    }

    async fn get_proposals(
        &self, event: EventId, objective: ObjectiveId, limit: Option<i64>, offset: Option<i64>,
    ) -> Result<Vec<ProposalSummary>, Error> {
        let conn = self.pool.get().await?;

        let rows = conn
            .query(Self::PROPOSALS_QUERY, &[
                &event.0,
                &objective.0,
                &limit,
                &offset.unwrap_or(0),
            ])
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
