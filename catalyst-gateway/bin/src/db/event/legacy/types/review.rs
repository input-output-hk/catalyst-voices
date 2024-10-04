//! Review Types
use serde_json::Value;

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
/// The Review Type
pub(crate) struct ReviewType {
    /// Review Type ID
    pub(crate) id: i32,
    /// Review Type Name
    pub(crate) name: String,
    /// Review Type Description
    pub(crate) description: Option<String>,
    /// Review Type minimum
    pub(crate) min: i32,
    /// Review Type maximum
    pub(crate) max: i32,
    /// Review Type map of values
    pub(crate) map: Vec<Value>,
    /// Review Type note
    pub(crate) note: Option<bool>,
    /// Review Type group
    pub(crate) group: Option<String>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
/// An individual rating
pub(crate) struct Rating {
    /// Review Type ID
    pub(crate) review_type: i32,
    /// Score given
    pub(crate) score: i32,
    /// Note
    pub(crate) note: Option<String>,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
/// Advisor Review
pub(crate) struct AdvisorReview {
    /// Assessors ID
    pub(crate) assessor: String,
    /// Ratings
    pub(crate) ratings: Vec<Rating>,
}
