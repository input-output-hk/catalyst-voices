use serde_json::Value;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ReviewType {
    pub id: i32,
    pub name: String,
    pub description: Option<String>,
    pub min: i32,
    pub max: i32,
    pub map: Vec<Value>,
    pub note: Option<bool>,
    pub group: Option<String>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Rating {
    pub review_type: i32,
    pub score: i32,
    pub note: Option<String>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct AdvisorReview {
    pub assessor: String,
    pub ratings: Vec<Rating>,
}
