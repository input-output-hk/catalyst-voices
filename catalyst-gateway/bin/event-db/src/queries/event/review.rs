use crate::{
    error::Error,
    types::{
        event::EventId,
        objective::ObjectiveId,
        proposal::ProposalId,
        review::{AdvisorReview, Rating, ReviewType},
    },
    EventDB,
};
use async_trait::async_trait;

#[async_trait]
pub trait ReviewQueries: Sync + Send + 'static {
    async fn get_reviews(
        &self,
        event: EventId,
        objective: ObjectiveId,
        proposal: ProposalId,
        limit: Option<i64>,
        offset: Option<i64>,
    ) -> Result<Vec<AdvisorReview>, Error>;

    async fn get_review_types(
        &self,
        event: EventId,
        objective: ObjectiveId,
        limit: Option<i64>,
        offset: Option<i64>,
    ) -> Result<Vec<ReviewType>, Error>;
}

impl EventDB {
    const REVIEWS_QUERY: &'static str = "SELECT proposal_review.row_id, proposal_review.assessor
        FROM proposal_review
        INNER JOIN proposal on proposal.row_id = proposal_review.proposal_id
        INNER JOIN objective on proposal.objective = objective.row_id
        WHERE objective.event = $1 AND objective.id = $2 AND proposal.id = $3
        LIMIT $4 OFFSET $5;";

    const RATINGS_PER_REVIEW_QUERY: &'static str =
        "SELECT review_rating.metric, review_rating.rating, review_rating.note
        FROM review_rating
        WHERE review_rating.review_id = $1;";

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

#[async_trait]
impl ReviewQueries for EventDB {
    async fn get_reviews(
        &self,
        event: EventId,
        objective: ObjectiveId,
        proposal: ProposalId,
        limit: Option<i64>,
        offset: Option<i64>,
    ) -> Result<Vec<AdvisorReview>, Error> {
        let conn = self.pool.get().await?;

        let rows = conn
            .query(
                Self::REVIEWS_QUERY,
                &[
                    &event.0,
                    &objective.0,
                    &proposal.0,
                    &limit,
                    &offset.unwrap_or(0),
                ],
            )
            .await?;

        let mut reviews = Vec::new();
        for row in rows {
            let assessor = row.try_get("assessor")?;
            let review_id: i32 = row.try_get("row_id")?;

            let mut ratings = Vec::new();
            let rows = conn
                .query(Self::RATINGS_PER_REVIEW_QUERY, &[&review_id])
                .await?;
            for row in rows {
                ratings.push(Rating {
                    review_type: row.try_get("metric")?,
                    score: row.try_get("rating")?,
                    note: row.try_get("note")?,
                })
            }

            reviews.push(AdvisorReview { assessor, ratings })
        }

        Ok(reviews)
    }

    async fn get_review_types(
        &self,
        event: EventId,
        objective: ObjectiveId,
        limit: Option<i64>,
        offset: Option<i64>,
    ) -> Result<Vec<ReviewType>, Error> {
        let conn = self.pool.get().await?;

        let rows = conn
            .query(
                Self::REVIEW_TYPES_QUERY,
                &[&event.0, &objective.0, &limit, &offset.unwrap_or(0)],
            )
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
            })
        }

        Ok(review_types)
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
    use serde_json::json;

    use super::*;
    use crate::establish_connection;

    #[tokio::test]
    async fn get_reviews_test() {
        let event_db = establish_connection(None).await.unwrap();

        let reviews = event_db
            .get_reviews(EventId(1), ObjectiveId(1), ProposalId(10), None, None)
            .await
            .unwrap();

        assert_eq!(
            vec![
                AdvisorReview {
                    assessor: "assessor 1".to_string(),
                    ratings: vec![
                        Rating {
                            review_type: 1,
                            score: 10,
                            note: Some("note 1".to_string()),
                        },
                        Rating {
                            review_type: 2,
                            score: 15,
                            note: Some("note 2".to_string()),
                        },
                        Rating {
                            review_type: 5,
                            score: 20,
                            note: Some("note 3".to_string()),
                        }
                    ],
                },
                AdvisorReview {
                    assessor: "assessor 2".to_string(),
                    ratings: vec![],
                },
                AdvisorReview {
                    assessor: "assessor 3".to_string(),
                    ratings: vec![],
                },
            ],
            reviews
        );

        let reviews = event_db
            .get_reviews(EventId(1), ObjectiveId(1), ProposalId(10), Some(2), None)
            .await
            .unwrap();

        assert_eq!(
            vec![
                AdvisorReview {
                    assessor: "assessor 1".to_string(),
                    ratings: vec![
                        Rating {
                            review_type: 1,
                            score: 10,
                            note: Some("note 1".to_string()),
                        },
                        Rating {
                            review_type: 2,
                            score: 15,
                            note: Some("note 2".to_string()),
                        },
                        Rating {
                            review_type: 5,
                            score: 20,
                            note: Some("note 3".to_string()),
                        }
                    ],
                },
                AdvisorReview {
                    assessor: "assessor 2".to_string(),
                    ratings: vec![],
                },
            ],
            reviews
        );

        let reviews = event_db
            .get_reviews(EventId(1), ObjectiveId(1), ProposalId(10), None, Some(1))
            .await
            .unwrap();

        assert_eq!(
            vec![
                AdvisorReview {
                    assessor: "assessor 2".to_string(),
                    ratings: vec![],
                },
                AdvisorReview {
                    assessor: "assessor 3".to_string(),
                    ratings: vec![],
                },
            ],
            reviews
        );

        let reviews = event_db
            .get_reviews(EventId(1), ObjectiveId(1), ProposalId(10), Some(1), Some(1))
            .await
            .unwrap();

        assert_eq!(
            vec![AdvisorReview {
                assessor: "assessor 2".to_string(),
                ratings: vec![],
            },],
            reviews
        );
    }

    #[tokio::test]
    async fn get_review_types_test() {
        let event_db = establish_connection(None).await.unwrap();

        let review_types = event_db
            .get_review_types(EventId(1), ObjectiveId(1), None, None)
            .await
            .unwrap();

        assert_eq!(
            vec![
                ReviewType {
                    id: 1,
                    name: "impact".to_string(),
                    description: Some("Impact Rating".to_string()),
                    min: 0,
                    max: 5,
                    map: vec![],
                    note: None,
                    group: Some("review_group 1".to_string()),
                },
                ReviewType {
                    id: 2,
                    name: "feasibility".to_string(),
                    description: Some("Feasibility Rating".to_string()),
                    min: 0,
                    max: 5,
                    map: vec![],
                    note: Some(true),
                    group: Some("review_group 2".to_string()),
                },
                ReviewType {
                    id: 5,
                    name: "vpa_ranking".to_string(),
                    description: Some("VPA Ranking of the review".to_string()),
                    min: 0,
                    max: 3,
                    map: vec![
                        json!(
                            {"name":"Excellent","desc":"Excellent Review"}
                        ),
                        json!({"name":"Good","desc":"Could be improved."}),
                        json!({"name":"FilteredOut","desc":"Exclude this review"}),
                        json!({"name":"NA", "desc":"Not Applicable"})
                    ],
                    note: Some(false),
                    group: None,
                }
            ],
            review_types
        );

        let review_types = event_db
            .get_review_types(EventId(1), ObjectiveId(1), Some(2), None)
            .await
            .unwrap();

        assert_eq!(
            vec![
                ReviewType {
                    id: 1,
                    name: "impact".to_string(),
                    description: Some("Impact Rating".to_string()),
                    min: 0,
                    max: 5,
                    map: vec![],
                    note: None,
                    group: Some("review_group 1".to_string()),
                },
                ReviewType {
                    id: 2,
                    name: "feasibility".to_string(),
                    description: Some("Feasibility Rating".to_string()),
                    min: 0,
                    max: 5,
                    map: vec![],
                    note: Some(true),
                    group: Some("review_group 2".to_string()),
                },
            ],
            review_types
        );

        let review_types = event_db
            .get_review_types(EventId(1), ObjectiveId(1), None, Some(1))
            .await
            .unwrap();

        assert_eq!(
            vec![
                ReviewType {
                    id: 2,
                    name: "feasibility".to_string(),
                    description: Some("Feasibility Rating".to_string()),
                    min: 0,
                    max: 5,
                    map: vec![],
                    note: Some(true),
                    group: Some("review_group 2".to_string()),
                },
                ReviewType {
                    id: 5,
                    name: "vpa_ranking".to_string(),
                    description: Some("VPA Ranking of the review".to_string()),
                    min: 0,
                    max: 3,
                    map: vec![
                        json!(
                            {"name":"Excellent","desc":"Excellent Review"}
                        ),
                        json!({"name":"Good","desc":"Could be improved."}),
                        json!({"name":"FilteredOut","desc":"Exclude this review"}),
                        json!({"name":"NA", "desc":"Not Applicable"})
                    ],
                    note: Some(false),
                    group: None,
                }
            ],
            review_types
        );

        let review_types = event_db
            .get_review_types(EventId(1), ObjectiveId(1), Some(1), Some(1))
            .await
            .unwrap();

        assert_eq!(
            vec![ReviewType {
                id: 2,
                name: "feasibility".to_string(),
                description: Some("Feasibility Rating".to_string()),
                min: 0,
                max: 5,
                map: vec![],
                note: Some(true),
                group: Some("review_group 2".to_string()),
            }],
            review_types
        );
    }
}
