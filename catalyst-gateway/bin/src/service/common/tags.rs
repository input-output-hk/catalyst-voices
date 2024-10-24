//! `OpenAPI` Tags we need to classify the endpoints.
use poem_openapi::Tags;

/// `OpenAPI` Tags
#[derive(Tags)]
pub(crate) enum ApiTags {
    /// Fragment endpoints
    Fragments,
    /// Health Endpoints
    Health,
    /// Cardano Endpoints
    Cardano,
    /// Information relating to Voter Registration, Delegations and Calculated Voting
    /// Power.
    Registration,
    /// API Version 0 Endpoints
    V0,
    /// API Version 1 Endpoints
    V1,
    /// Configuration Endpoints
    Config,
}
