//! Proposal Queries
use crate::db::event::{
    error::NotFoundError,
    legacy::types::{
        event::EventId,
        objective::ObjectiveId,
        proposal::{Proposal, ProposalDetails, ProposalId, ProposalSummary, ProposerDetails},
    },
    EventDB,
};

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

impl EventDB {
    /// Get proposal query
    #[allow(dead_code)]
    pub(crate) async fn get_proposal(
        event: EventId, objective: ObjectiveId, proposal: ProposalId,
    ) -> anyhow::Result<Proposal> {
        let rows =
            Self::query(Self::PROPOSAL_QUERY, &[&event.0, &objective.0, &proposal.0]).await?;
        let row = rows.first().ok_or(NotFoundError)?;

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

    /// Get proposals query
    #[allow(dead_code)]
    pub(crate) async fn get_proposals(
        &self, event: EventId, objective: ObjectiveId, limit: Option<i64>, offset: Option<i64>,
    ) -> anyhow::Result<Vec<ProposalSummary>> {
        let rows = Self::query(Self::PROPOSALS_QUERY, &[
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
