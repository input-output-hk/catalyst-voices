//! Either has No Authorization, or defined security schema.

use poem_openapi::SecurityScheme;

use super::{api_key::InternalApiKeyAuthorization, none::NoAuthorization};

/// Endpoint allows Authorization with or without API Key.
#[derive(SecurityScheme)]
#[allow(dead_code, clippy::upper_case_acronyms, clippy::large_enum_variant)]
pub(crate) enum NoneOrApiKey {
    /// Has API Key.
    Auth(InternalApiKeyAuthorization),
    /// Has No Authorization.
    None(NoAuthorization),
}
