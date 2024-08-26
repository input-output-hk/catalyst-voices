use std::sync::LazyLock;

use moka::future::Cache;
use poem::{error::ResponseError, http::StatusCode, Request};
use poem_openapi::{auth::Bearer, SecurityScheme};
use tracing::error;

use super::token::{Kid, SignatureEd25519, UlidBytes};
use crate::service::api::auth::token::decode_auth_token_ed25519;

/// Decoded token consists ok Kid, Ulid Bytes and Signature
pub type DecodedAuthToken = (Kid, UlidBytes, SignatureEd25519);

/// Auth token in the form of catv1..
#[allow(dead_code)]
pub type EncodedAuthToken = String;

/// Cached auth tokens
#[allow(dead_code)]
static CACHE: LazyLock<Cache<EncodedAuthToken, DecodedAuthToken>> = LazyLock::new(|| {
    const CACHE_LIMIT: u64 = 10_000;
    Cache::new(CACHE_LIMIT)
});

#[derive(SecurityScheme)]
#[oai(
    rename = "CatalystSecurityScheme",
    ty = "bearer",
    key_in = "header",
    key_name = "Bearer",
    checker = "checker_api_catalyst_auth"
)]
#[allow(dead_code)]
pub struct CatalystSecurityScheme(pub DecodedAuthToken);

#[derive(Debug, thiserror::Error)]
#[error("Corrupt Auth Token")]
pub struct AuthTokenError;

impl ResponseError for AuthTokenError {
    fn status(&self) -> StatusCode {
        StatusCode::FORBIDDEN
    }
}

async fn checker_api_catalyst_auth(
    _req: &Request, bearer: Bearer,
) -> poem::Result<DecodedAuthToken> {
    let pub_key: [u8; 32] =
        hex::decode("b45b8295e2701d2dbc8d4093fae94b979735f8c5e17a1843cf64a298e86659a2")
            .unwrap()
            .try_into()
            .unwrap();

    let (kid, ulid, sig) = match decode_auth_token_ed25519(bearer.token, pub_key) {
        Ok((kid, ulid, sig)) => (kid, ulid, sig),
        Err(err) => {
            error!("Corrupt auth token: {:?}", err);
            Err(AuthTokenError)?
        },
    };

    Ok((kid, ulid, sig))
}
