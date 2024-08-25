use poem::{error::ResponseError, http::StatusCode, Request};
use poem_openapi::{auth::Bearer, SecurityScheme};
use tracing::error;

use crate::service::api::auth::token::decode_auth_token_ed25519;

use super::token::{Kid, SignatureEd25519, UlidBytes};

/// Decoded token consists ok Kid, Ulid Bytes and Signature
pub type DecodedToken = (Kid, UlidBytes, SignatureEd25519);

#[derive(SecurityScheme)]
#[oai(
    rename = "CatalystSecurityScheme",
    ty = "bearer",
    bearer_format = "JWT",
    key_in = "header",
    key_name = "Bearer",
    checker = "checker_api_catalyst_auth"
)]
#[allow(dead_code)]
pub struct CatalystSecurityScheme(pub DecodedToken);

#[derive(Debug, thiserror::Error)]
#[error("Corrupt Auth Token")]
pub struct AuthTokenError;

impl ResponseError for AuthTokenError {
    fn status(&self) -> StatusCode {
        StatusCode::FORBIDDEN
    }
}

async fn checker_api_catalyst_auth(_req: &Request, bearer: Bearer) -> poem::Result<DecodedToken> {
    let (kid, ulid, sig) = match decode_auth_token_ed25519(bearer.token) {
        Ok((kid, ulid, sig)) => (kid, ulid, sig),
        Err(err) => {
            error!("Corrupt auth token: {:?}", err);
            Err(AuthTokenError)?
        },
    };

    Ok((kid, ulid, sig))
}
