//! API Key authorization scheme is used ONLY by internal endpoints.
//!
//! Its purpose is to prevent their use externally, if they were accidentally exposed.
//!
//! It is NOT to be used on any endpoint intended to be publicly facing.

use anyhow::{bail, Result};
use poem::{http::HeaderMap, Request};
use poem_openapi::{auth::ApiKey, SecurityScheme};

use crate::settings::Settings;

/// The header name that holds the API Key
const API_KEY_HEADER: &str = "X-API-Key";

/// `ApiKey` authorization for Internal Endpoints
#[derive(SecurityScheme)]
#[oai(
    ty = "api_key",
    key_name = "X-API-Key", // MUST match the above constant.
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

/// Check if the API Key is correctly set.
/// Returns an error if it is not.
pub(crate) fn check_api_key(headers: &HeaderMap) -> Result<()> {
    if let Some(key) = headers.get(API_KEY_HEADER) {
        if Settings::check_internal_api_key(key.to_str()?) {
            return Ok(());
        }
    }
    bail!("Invalid API Key");
}
