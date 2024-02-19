//! Objective Queries
use async_trait::async_trait;

use crate::event_db::{
    error::Error,
    legacy::types::{
        event::EventId,
        objective::{
            Objective, ObjectiveDetails, ObjectiveId, ObjectiveSummary, ObjectiveType,
            RewardDefinition, VoterGroup,
        },
        registration::VoterGroupId,
    },
    EventDB,
};

#[async_trait]
#[allow(clippy::module_name_repetitions)]
/// Objective Queries Trait
pub(crate) trait ObjectiveQueries: Sync + Send + 'static {
    async fn get_objectives(
        &self, event: EventId, limit: Option<i64>, offset: Option<i64>,
    ) -> Result<Vec<Objective>, Error>;
}

impl EventDB {
    /// Objectives query template
    const OBJECTIVES_QUERY: &'static str =
        "SELECT objective.row_id, objective.id, objective.title, objective.description, objective.deleted, objective.rewards_currency, objective.rewards_total, objective.extra,
        objective_category.name, objective_category.description as objective_category_description
        FROM objective
        INNER JOIN objective_category on objective.category = objective_category.name
        WHERE objective.event = $1
        LIMIT $2 OFFSET $3;";
    /// Voting Groups query template
    const VOTING_GROUPS_QUERY: &'static str =
        "SELECT voteplan.group_id as group, voteplan.token_id as voting_token
        FROM voteplan 
        WHERE objective_id = $1;";
}

#[async_trait]
impl ObjectiveQueries for EventDB {
    async fn get_objectives(
        &self, event: EventId, limit: Option<i64>, offset: Option<i64>,
    ) -> Result<Vec<Objective>, Error> {
        let conn = self.pool.get().await?;

        let rows = conn
            .query(Self::OBJECTIVES_QUERY, &[
                &event.0,
                &limit,
                &offset.unwrap_or(0),
            ])
            .await?;

        let mut objectives = Vec::new();
        for row in rows {
            let row_id: i32 = row.try_get("row_id")?;
            let summary = ObjectiveSummary {
                id: ObjectiveId(row.try_get("id")?),
                objective_type: ObjectiveType {
                    id: row.try_get("name")?,
                    description: row.try_get("objective_category_description")?,
                },
                title: row.try_get("title")?,
                description: row.try_get("description")?,
                deleted: row.try_get("deleted")?,
            };
            let currency: Option<_> = row.try_get("rewards_currency")?;
            let value: Option<_> = row.try_get("rewards_total")?;
            let reward = match (currency, value) {
                (Some(currency), Some(value)) => Some(RewardDefinition { currency, value }),
                _ => None,
            };

            let mut groups = Vec::new();
            let rows = conn.query(Self::VOTING_GROUPS_QUERY, &[&row_id]).await?;
            for row in rows {
                let group = row.try_get::<_, Option<String>>("group")?.map(VoterGroupId);
                let voting_token: Option<_> = row.try_get("voting_token")?;
                match (group, voting_token) {
                    (None, None) => {},
                    (group, voting_token) => {
                        groups.push(VoterGroup {
                            group,
                            voting_token,
                        });
                    },
                }
            }

            let details = ObjectiveDetails {
                groups,
                reward,
                supplemental: row.try_get::<_, Option<serde_json::Value>>("extra")?,
            };
            objectives.push(Objective { summary, details });
        }

        Ok(objectives)
    }
}
