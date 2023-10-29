//! `OpenAPI` Tags we need to classify the endpoints.
//!
use poem_openapi::Tags;

/// `OpenAPI` Tags
#[derive(Tags)]
pub(crate) enum ApiTags {
    /// Health Endpoints
    Health,
    /// Message Endpoints
    Message,
    /// Information relating to Voter Registration, Delegations and Calculated Voting Power.
    Registration,
    /// Test Endpoints (Not part of the API)
    Test,
    /// Test Endpoints (Not part of the API)
    TestTag2,
}
