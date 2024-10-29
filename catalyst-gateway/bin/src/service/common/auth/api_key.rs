//! API Key authorization scheme is used ONLY by internal endpoints.
//!
//! Its purpose is to prevent their use externally, if they were accidentally exposed.
//!
//! It is NOT to be used on any endpoint intended to be publicly facing.

use poem::Request;
use poem_openapi::{auth::ApiKey, SecurityScheme};

use crate::settings::Settings;

/// `ApiKey` authorization for Internal Endpoints
#[derive(SecurityScheme)]
#[oai(
    ty = "api_key",
    key_name = "X-API-Key",
    key_in = "header",
    checker = "api_checker"
)]
#[allow(dead_code)]
pub(crate) struct InternalApiKeyAuthorization(String);

/// Check the provided API Key matches the API Key defined by for the deployment.
#[allow(clippy::unused_async)]
async fn api_checker(_req: &Request, api_key: ApiKey) -> Option<String> {
    if Settings::check_internal_api_key(&api_key.key) {
        Some(api_key.key)
    } else {
        None
    }
}
