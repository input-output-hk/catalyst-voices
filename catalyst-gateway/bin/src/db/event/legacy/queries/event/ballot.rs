//! Ballot Queries
use std::collections::HashMap;

use crate::db::event::{
    error::NotFoundError,
    legacy::types::{
        ballot::{
            Ballot, BallotType, GroupVotePlans, ObjectiveBallots, ObjectiveChoices, ProposalBallot,
            VotePlan,
        },
        event::EventId,
        objective::ObjectiveId,
        proposal::ProposalId,
        registration::VoterGroupId,
    },
    EventDB,
};

impl EventDB {
    /// Ballot vote options per event query template
    const BALLOTS_VOTE_OPTIONS_PER_EVENT_QUERY: &'static str =
        "SELECT vote_options.objective, proposal.id as proposal_id, objective.id as objective_id
        FROM proposal
        INNER JOIN objective ON proposal.objective = objective.row_id
        INNER JOIN vote_options ON objective.vote_options = vote_options.id
        WHERE objective.event = $1;";
    /// Ballot vote options per objective query template
    const BALLOTS_VOTE_OPTIONS_PER_OBJECTIVE_QUERY: &'static str =
        "SELECT vote_options.objective, proposal.id as proposal_id
        FROM proposal
        INNER JOIN objective ON proposal.objective = objective.row_id
        INNER JOIN vote_options ON objective.vote_options = vote_options.id
        WHERE objective.event = $1 AND objective.id = $2;";
    /// Ballot vote options query template
    const BALLOT_VOTE_OPTIONS_QUERY: &'static str = "SELECT vote_options.objective
        FROM proposal
        INNER JOIN objective ON proposal.objective = objective.row_id
        INNER JOIN vote_options ON objective.vote_options = vote_options.id
        WHERE objective.event = $1 AND objective.id = $2 AND proposal.id = $3;";
    /// Ballot vote plans query template
    const BALLOT_VOTE_PLANS_QUERY: &'static str = "SELECT proposal_voteplan.bb_proposal_index,
        voteplan.id, voteplan.category, voteplan.encryption_key, voteplan.group_id
        FROM proposal_voteplan
        INNER JOIN proposal ON proposal_voteplan.proposal_id = proposal.row_id
        INNER JOIN voteplan ON proposal_voteplan.voteplan_id = voteplan.row_id
        INNER JOIN objective ON proposal.objective = objective.row_id
        WHERE objective.event = $1 AND objective.id = $2 AND proposal.id = $3;";
}

impl EventDB {
    /// Get ballot query
    #[allow(dead_code)]
    pub(crate) async fn get_ballot(
        event: EventId, objective: ObjectiveId, proposal: ProposalId,
    ) -> anyhow::Result<Ballot> {
        let rows = Self::query(Self::BALLOT_VOTE_OPTIONS_QUERY, &[
            &event.0,
            &objective.0,
            &proposal.0,
        ])
        .await?;
        let row = rows.first().ok_or(NotFoundError)?;
        let choices = row.try_get("objective")?;

        let rows = Self::query(Self::BALLOT_VOTE_PLANS_QUERY, &[
            &event.0,
            &objective.0,
            &proposal.0,
        ])
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
            });
        }

        Ok(Ballot {
            choices: ObjectiveChoices(choices),
            voteplans: GroupVotePlans(voteplans),
        })
    }

    /// Get objective's ballots query
    #[allow(dead_code)]
    pub(crate) async fn get_objective_ballots(
        &self, event: EventId, objective: ObjectiveId,
    ) -> anyhow::Result<Vec<ProposalBallot>> {
        let rows = Self::query(Self::BALLOTS_VOTE_OPTIONS_PER_OBJECTIVE_QUERY, &[
            &event.0,
            &objective.0,
        ])
        .await?;

        let mut ballots = Vec::new();
        for row in rows {
            let choices = row.try_get("objective")?;
            let proposal_id = ProposalId(row.try_get("proposal_id")?);

            let rows = Self::query(Self::BALLOT_VOTE_PLANS_QUERY, &[
                &event.0,
                &objective.0,
                &proposal_id.0,
            ])
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
                });
            }

            ballots.push(ProposalBallot {
                proposal_id,
                ballot: Ballot {
                    choices: ObjectiveChoices(choices),
                    voteplans: GroupVotePlans(voteplans),
                },
            });
        }
        Ok(ballots)
    }

    /// Get event's ballots query
    #[allow(dead_code)]
    pub(crate) async fn get_event_ballots(
        &self, event: EventId,
    ) -> anyhow::Result<Vec<ObjectiveBallots>> {
        let rows = Self::query(Self::BALLOTS_VOTE_OPTIONS_PER_EVENT_QUERY, &[&event.0]).await?;
        let mut ballots = HashMap::<ObjectiveId, Vec<ProposalBallot>>::new();
        for row in rows {
            let choices = row.try_get("objective")?;
            let proposal_id = ProposalId(row.try_get("proposal_id")?);
            let objective_id = ObjectiveId(row.try_get("objective_id")?);

            let rows = Self::query(Self::BALLOT_VOTE_PLANS_QUERY, &[
                &event.0,
                &objective_id.0,
                &proposal_id.0,
            ])
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
                });
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
            .map(|(objective_id, ballots)| {
                ObjectiveBallots {
                    objective_id,
                    ballots,
                }
            })
            .collect())
    }
}
