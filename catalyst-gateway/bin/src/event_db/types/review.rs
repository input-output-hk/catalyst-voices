use serde_json::Value;

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct ReviewType {
    pub(crate) id: i32,
    pub(crate) name: String,
    pub(crate) description: Option<String>,
    pub(crate) min: i32,
    pub(crate) max: i32,
    pub(crate) map: Vec<Value>,
    pub(crate) note: Option<bool>,
    pub(crate) group: Option<String>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct Rating {
    pub(crate) review_type: i32,
    pub(crate) score: i32,
    pub(crate) note: Option<String>,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct AdvisorReview {
    pub(crate) assessor: String,
    pub(crate) ratings: Vec<Rating>,
}
