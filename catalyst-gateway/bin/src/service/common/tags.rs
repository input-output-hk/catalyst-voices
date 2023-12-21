//! `OpenAPI` Tags we need to classify the endpoints.
use poem_openapi::Tags;

/// `OpenAPI` Tags
#[derive(Tags)]
pub(crate) enum ApiTags {
    /// Fragment endpoints
    Fragments,
    /// Health Endpoints
    Health,
    /// Information relating to Voter Registration, Delegations and Calculated Voting
    /// Power.
    Registration,
    /// Test Endpoints (Not part of the API)
    Test,
    /// Test Endpoints (Not part of the API)
    TestTag2,
    /// API Version 0 Endpoints
    V0,
    /// API Version 1 Endpoints
    V1,
}
