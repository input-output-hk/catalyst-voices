//! `OpenAPI` Tags we need to classify the endpoints.
use poem_openapi::Tags;

/// `OpenAPI` Tags
#[derive(Tags)]
pub(crate) enum ApiTags {
    /// Service Health and Readiness
    Health,
    /// General Cardano Blockchain Information
    Cardano,
    // Registration and Role Based Access Control (RBAC) Operations.
    // Registration,
    /// Legacy Mobile App Support
    Legacy,
    /// Service Configuration and Status
    Config,
}
