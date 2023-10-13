use super::SerdeType;
use event_db::types::review::{AdvisorReview, Rating, ReviewType};
use serde::{ser::Serializer, Serialize};
use serde_json::Value;

impl Serialize for SerdeType<&ReviewType> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct ReviewTypeSerde<'a> {
            id: i32,
            name: &'a String,
            #[serde(skip_serializing_if = "Option::is_none")]
            description: &'a Option<String>,
            min: i32,
            max: i32,
            map: &'a Vec<Value>,
            #[serde(skip_serializing_if = "Option::is_none")]
            note: Option<bool>,
            #[serde(skip_serializing_if = "Option::is_none")]
            group: &'a Option<String>,
        }
        ReviewTypeSerde {
            id: self.id,
            name: &self.name,
            description: &self.description,
            min: self.min,
            max: self.max,
            map: &self.map,
            note: self.note,
            group: &self.group,
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<ReviewType> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&Rating> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct RatingSerde<'a> {
            review_type: i32,
            score: i32,
            #[serde(skip_serializing_if = "Option::is_none")]
            note: &'a Option<String>,
        }
        RatingSerde {
            review_type: self.review_type,
            score: self.score,
            note: &self.note,
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<Rating> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&AdvisorReview> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct AdvisorReviewSerde<'a> {
            assessor: &'a String,
            ratings: Vec<SerdeType<&'a Rating>>,
        }
        AdvisorReviewSerde {
            assessor: &self.assessor,
            ratings: self.ratings.iter().map(SerdeType).collect(),
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<AdvisorReview> {
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
    fn review_type_json_test() {
        let review_type = SerdeType(ReviewType {
            id: 1,
            name: "name".to_string(),
            description: Some("description".to_string()),
            min: 1,
            max: 2,
            note: Some(true),
            map: vec![],
            group: Some("group".to_string()),
        });

        let json = serde_json::to_value(review_type).unwrap();
        assert_eq!(
            json,
            json!(
                    {
                        "id": 1,
                        "name": "name",
                        "description": "description",
                        "min": 1,
                        "max": 2,
                        "note": true,
                        "map": [],
                        "group": "group",
                    }
            )
        );

        let review_type = SerdeType(ReviewType {
            id: 1,
            name: "name".to_string(),
            description: None,
            min: 1,
            max: 2,
            note: None,
            map: vec![],
            group: None,
        });

        let json = serde_json::to_value(review_type).unwrap();
        assert_eq!(
            json,
            json!(
                    {
                        "id": 1,
                        "name": "name",
                        "min": 1,
                        "max": 2,
                        "map": [],
                    }
            )
        );
    }

    #[test]
    fn rating_json_test() {
        let rating = SerdeType(Rating {
            review_type: 1,
            score: 1,
            note: Some("note".to_string()),
        });

        let json = serde_json::to_value(rating).unwrap();
        assert_eq!(
            json,
            json!(
                    {
                        "review_type": 1,
                        "score": 1,
                        "note": "note",
                    }
            )
        );

        let rating = SerdeType(Rating {
            review_type: 1,
            score: 1,
            note: None,
        });

        let json = serde_json::to_value(rating).unwrap();
        assert_eq!(
            json,
            json!(
                    {
                        "review_type": 1,
                        "score": 1,
                    }
            )
        );
    }

    #[test]
    fn advisor_review_json_test() {
        let advisor_review = SerdeType(AdvisorReview {
            assessor: "alice".to_string(),
            ratings: vec![],
        });

        let json = serde_json::to_value(advisor_review).unwrap();
        assert_eq!(
            json,
            json!(
                    {
                        "assessor": "alice",
                        "ratings": [],
                    }
            )
        )
    }
}
