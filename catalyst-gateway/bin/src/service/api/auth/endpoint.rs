use std::sync::LazyLock;

use dashmap::DashMap;
use ed25519_dalek::{Signature, VerifyingKey, PUBLIC_KEY_LENGTH};
use moka::future::Cache;
use poem::{error::ResponseError, http::StatusCode, Request};
use poem_openapi::{auth::Bearer, SecurityScheme};
use tracing::error;

use super::token::{Kid, SignatureEd25519, UlidBytes};
use crate::service::api::auth::token::decode_auth_token_ed25519;

/// Decoded token consists ok Kid, Ulid and Signature
pub type DecodedAuthToken = (Kid, UlidBytes, SignatureEd25519);

/// Auth token in the form of catv1..
pub type EncodedAuthToken = String;

/// Cached auth tokens
#[allow(dead_code)]
static CACHE: LazyLock<Cache<EncodedAuthToken, DecodedAuthToken>> = LazyLock::new(|| {
    const CACHE_LIMIT: u64 = 10_000;
    Cache::new(CACHE_LIMIT)
});

/// Mocked Valid certificates
/// TODO: the following is temporary state for POC until RBAC database is complete.
static CERTS: LazyLock<DashMap<String, [u8; PUBLIC_KEY_LENGTH]>> = LazyLock::new(|| {
    const KID: &str = "0467de6bd945b9207bfa09d846b77ef5";

    let public_key_bytes: [u8; PUBLIC_KEY_LENGTH] = [
        180, 91, 130, 149, 226, 112, 29, 45, 188, 141, 64, 147, 250, 233, 75, 151, 151, 53, 248,
        197, 225, 122, 24, 67, 207, 100, 162, 152, 232, 102, 89, 162,
    ];

    let cert_map = DashMap::new();
    cert_map.insert(KID.to_string(), public_key_bytes);
    cert_map
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
    // Decode bearer token
    let (kid, ulid, sig, msg) = match decode_auth_token_ed25519(bearer.token) {
        Ok((kid, ulid, sig, msg)) => (kid, ulid, sig, msg),
        Err(err) => {
            error!("Corrupt auth token: {:?}", err);
            Err(AuthTokenError)?
        },
    };

    // Get pub key from CERTS state given decoded KID from decoded bearer token
    let pub_key_bytes = match CERTS.get(&hex::encode(kid.0)) {
        Some(cert) => cert.clone(),
        None => {
            error!("Invalid KID {:?}", kid);
            Err(AuthTokenError)?
        },
    };

    let public_key = match VerifyingKey::from_bytes(&pub_key_bytes) {
        Ok(pub_key) => pub_key,
        Err(err) => {
            error!("Invalid public key: {:?}", err);
            Err(AuthTokenError)?
        },
    };

    // Strictly verify a signature on a message with this keypair's public key.
    match public_key.verify_strict(&msg, &Signature::from_bytes(&sig.0)) {
        Ok(_) => (),
        Err(err) => {
            error!(
                "Message {:?} was not signed by this pub key {:?} {:?}",
                hex::encode(msg),
                public_key,
                err
            );
            Err(AuthTokenError)?
        },
    };

    Ok((kid, ulid, sig))
}
