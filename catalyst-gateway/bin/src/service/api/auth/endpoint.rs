use std::{sync::LazyLock, time::Duration};

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
static CACHE: LazyLock<Cache<EncodedAuthToken, DecodedAuthToken>> = LazyLock::new(|| {
    let cache = Cache::builder()
        // Time to live (TTL): 30 minutes
        .time_to_live(Duration::from_secs(30 * 60))
        // Time to idle (TTI):  5 minutes
        .time_to_idle(Duration::from_secs(5 * 60))
        // Create the cache.
        .build();

    cache
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
/// Auth token security scheme
/// Add to endpoint params e.g async fn endpoint(&self, auth: CatalystSecurityScheme)
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
    if !CACHE.contains_key(&bearer.token) {
        // Decode bearer token
        let (kid, ulid, sig, msg) = match decode_auth_token_ed25519(bearer.token.clone()) {
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

        // Strictly verify a signature on a message with this keypair public key.
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

        // This entry will expire after 5 minutes (TTI) if there is no get().
        CACHE
            .insert(bearer.token, (kid.clone(), ulid.clone(), sig.clone()))
            .await;

        Ok((kid, ulid, sig))
    } else {
        // This get() will extend the entry life for another 5 minutes.
        // Even though we keep calling get(), the entry will expire
        // after 30 minutes (TTL) from the origin insert().
        match CACHE.get(&bearer.token).await {
            Some((kid, ulid, sig)) => Ok((kid, ulid, sig)),
            None => {
                error!("Auth token is not in the cache: {:?}", bearer.token);
                Err(AuthTokenError)?
            },
        }
    }
}
