//! Review Queries
use crate::db::event::{
    legacy::types::{
        event::EventId,
        objective::ObjectiveId,
        proposal::ProposalId,
        review::{AdvisorReview, Rating, ReviewType},
    },
    EventDB,
};

impl EventDB {
    /// Rating per review query template
    const RATINGS_PER_REVIEW_QUERY: &'static str =
        "SELECT review_rating.metric, review_rating.rating, review_rating.note
        FROM review_rating
        WHERE review_rating.review_id = $1;";
    /// Review query template
    const REVIEWS_QUERY: &'static str = "SELECT proposal_review.row_id, proposal_review.assessor
        FROM proposal_review
        INNER JOIN proposal on proposal.row_id = proposal_review.proposal_id
        INNER JOIN objective on proposal.objective = objective.row_id
        WHERE objective.event = $1 AND objective.id = $2 AND proposal.id = $3
        LIMIT $4 OFFSET $5;";
    /// Review types query template
    const REVIEW_TYPES_QUERY: &'static str =
        "SELECT review_metric.row_id, review_metric.name, review_metric.description,
        review_metric.min, review_metric.max, review_metric.map,
        objective_review_metric.note, objective_review_metric.review_group
        FROM review_metric
        INNER JOIN objective_review_metric on review_metric.row_id = objective_review_metric.metric
        INNER JOIN objective on objective_review_metric.objective = objective.row_id
        WHERE objective.event = $1 AND objective.id = $2
        LIMIT $3 OFFSET $4;";
}

impl EventDB {
    /// Get reviews query
    #[allow(dead_code)]
    pub(crate) async fn get_reviews(
        event: EventId, objective: ObjectiveId, proposal: ProposalId, limit: Option<i64>,
        offset: Option<i64>,
    ) -> anyhow::Result<Vec<AdvisorReview>> {
        let rows = Self::query(Self::REVIEWS_QUERY, &[
            &event.0,
            &objective.0,
            &proposal.0,
            &limit,
            &offset.unwrap_or(0),
        ])
        .await?;

        let mut reviews = Vec::new();
        for row in rows {
            let assessor = row.try_get("assessor")?;
            let review_id: i32 = row.try_get("row_id")?;

            let mut ratings = Vec::new();
            let rows = Self::query(Self::RATINGS_PER_REVIEW_QUERY, &[&review_id]).await?;
            for row in rows {
                ratings.push(Rating {
                    review_type: row.try_get("metric")?,
                    score: row.try_get("rating")?,
                    note: row.try_get("note")?,
                });
            }

            reviews.push(AdvisorReview { assessor, ratings });
        }

        Ok(reviews)
    }

    /// Get review types query
    #[allow(dead_code)]
    pub(crate) async fn get_review_types(
        &self, event: EventId, objective: ObjectiveId, limit: Option<i64>, offset: Option<i64>,
    ) -> anyhow::Result<Vec<ReviewType>> {
        let rows = Self::query(Self::REVIEW_TYPES_QUERY, &[
            &event.0,
            &objective.0,
            &limit,
            &offset.unwrap_or(0),
        ])
        .await?;
        let mut review_types = Vec::new();
        for row in rows {
            let map = row
                .try_get::<_, Option<Vec<serde_json::Value>>>("map")?
                .unwrap_or_default();

            review_types.push(ReviewType {
                map,
                id: row.try_get("row_id")?,
                name: row.try_get("name")?,
                description: row.try_get("description")?,
                min: row.try_get("min")?,
                max: row.try_get("max")?,
                note: row.try_get("note")?,
                group: row.try_get("review_group")?,
            });
        }

        Ok(review_types)
    }
}
