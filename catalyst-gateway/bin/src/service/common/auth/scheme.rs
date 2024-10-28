use std::{sync::LazyLock, time::Duration};

use dashmap::DashMap;
use ed25519_dalek::{Signature, VerifyingKey, PUBLIC_KEY_LENGTH};
use moka::future::Cache;
use poem::{error::ResponseError, http::StatusCode, Request};
use poem_openapi::{auth::Bearer, SecurityScheme};
use tracing::error;

use super::token::{decode_auth_token_ed25519, Kid, SignatureEd25519, UlidBytes};

/// Decoded token consists of a Kid, Ulid and Signature
pub type DecodedAuthToken = (Kid, UlidBytes, SignatureEd25519);

/// Auth token in the form of catv1..
pub type EncodedAuthToken = String;

/// Cached auth tokens
static CACHE: LazyLock<Cache<EncodedAuthToken, DecodedAuthToken>> = LazyLock::new(|| {
    Cache::builder()
        // Time to live (TTL): 30 minutes
        .time_to_live(Duration::from_secs(30 * 60))
        // Time to idle (TTI):  5 minutes
        .time_to_idle(Duration::from_secs(5 * 60))
        // Create the cache.
        .build()
});

/// Mocked Valid certificates
/// TODO: the following is temporary state for POC until RBAC database is complete.
static CERTS: LazyLock<DashMap<String, [u8; PUBLIC_KEY_LENGTH]>> = LazyLock::new(|| {
    /// Mock KID
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
    bearer_format = "catalyst-rbac-token",
    checker = "checker_api_catalyst_auth"
)]
/// Catalyst RBAC Access Token
#[allow(clippy::module_name_repetitions)]
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

/// When added to an endpoint, this hook is called per request to verify the bearer token
/// is valid.
async fn checker_api_catalyst_auth(
    _req: &Request, bearer: Bearer,
) -> poem::Result<DecodedAuthToken> {
    if CACHE.contains_key(&bearer.token) {
        // This get() will extend the entry life for another 5 minutes.
        // Even though we keep calling get(), the entry will expire
        // after 30 minutes (TTL) from the origin insert().
        if let Some((kid, ulid, sig)) = CACHE.get(&bearer.token).await {
            Ok((kid, ulid, sig))
        } else {
            error!("Auth token is not in the cache: {:?}", bearer.token);
            Err(AuthTokenError)?
        }
    } else {
        // Decode bearer token
        let (kid, ulid, sig, msg) = match decode_auth_token_ed25519(&bearer.token.clone()) {
            Ok((kid, ulid, sig, msg)) => (kid, ulid, sig, msg),
            Err(err) => {
                error!("Corrupt auth token: {:?}", err);
                Err(AuthTokenError)?
            },
        };

        // Get pub key from CERTS state given decoded KID from decoded bearer token
        let pub_key_bytes = if let Some(cert) = CERTS.get(&hex::encode(kid.0)) {
            *cert
        } else {
            error!("Invalid KID {:?}", kid);
            Err(AuthTokenError)?
        };

        let public_key = match VerifyingKey::from_bytes(&pub_key_bytes) {
            Ok(pub_key) => pub_key,
            Err(err) => {
                error!("Invalid public key: {:?}", err);
                Err(AuthTokenError)?
            },
        };

        // Strictly verify a signature on a message with this key-pair public key.
        if public_key
            .verify_strict(&msg, &Signature::from_bytes(&sig.0))
            .is_err()
        {
            error!(
                "Message {:?} was not signed by this key-pair {:?}",
                hex::encode(msg),
                public_key,
            );
            Err(AuthTokenError)?;
        }

        // This entry will expire after 5 minutes (TTI) if there is no get().
        CACHE.insert(bearer.token, (kid, ulid, sig.clone())).await;

        Ok((kid, ulid, sig))
    }
}
