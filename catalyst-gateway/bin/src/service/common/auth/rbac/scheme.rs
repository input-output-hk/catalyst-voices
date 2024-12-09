//! Catalyst RBAC Security Scheme
use std::{error::Error, sync::LazyLock, time::Duration};

use dashmap::DashMap;
use ed25519_dalek::{VerifyingKey, PUBLIC_KEY_LENGTH};
use futures::StreamExt;
use moka::future::Cache;
use poem::{error::ResponseError, http::StatusCode, IntoResponse, Request};
use poem_openapi::{auth::Bearer, payload::Json, SecurityScheme};
use tracing::error;

use super::token::CatalystRBACTokenV1;
use crate::{
    db::index::{
        queries::rbac::get_role0_chain_root::{
            GetRole0ChainRootQuery, GetRole0ChainRootQueryParams,
        },
        session::CassandraSession,
    },
    service::common::{
        responses::{
            code_500_internal_server_error::InternalServerError,
            code_503_service_unavailable::ServiceUnavailable, ErrorResponses,
        },
        types::headers::retry_after::RetryAfterHeader,
    },
};

/// Auth token in the form of catv1..
pub type EncodedAuthToken = String;

/// Cached auth tokens
static CACHE: LazyLock<Cache<EncodedAuthToken, CatalystRBACTokenV1>> = LazyLock::new(|| {
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

/// Catalyst RBAC Access Token
#[derive(SecurityScheme)]
#[oai(
    ty = "bearer",
    bearer_format = "catalyst-rbac-token",
    checker = "checker_api_catalyst_auth"
)]
#[allow(clippy::module_name_repetitions)]
#[allow(dead_code)]
pub struct CatalystRBACSecurityScheme(pub CatalystRBACTokenV1);

/// Error with the Authorization Token
///
/// We can not parse it, so its a 401 response.
#[derive(Debug, thiserror::Error)]
#[error("Invalid Catalyst RBAC Auth Token")]
pub struct AuthTokenError;

impl ResponseError for AuthTokenError {
    fn status(&self) -> StatusCode {
        StatusCode::UNAUTHORIZED
    }

    /// Convert this error to a HTTP response.
    fn as_response(&self) -> poem::Response
    where Self: Error + Send + Sync + 'static {
        ErrorResponses::unauthorized().into_response()
    }
}

/// Token does not have required access rights
///
/// Not enough access rights, so its a 403 response.
#[derive(Debug, thiserror::Error)]
#[error("Insufficient Permission for Catalyst RBAC Token")]
pub struct AuthTokenAccessViolation(Vec<String>);

impl ResponseError for AuthTokenAccessViolation {
    fn status(&self) -> StatusCode {
        StatusCode::FORBIDDEN
    }

    /// Convert this error to a HTTP response.
    fn as_response(&self) -> poem::Response
    where Self: Error + Send + Sync + 'static {
        // TODO: Actually check permissions needed for an endpoint.
        ErrorResponses::forbidden(Some(self.0.clone())).into_response()
    }
}

/// Time in the past the Token can be valid for.
const MAX_TOKEN_AGE: Duration = Duration::from_secs(60 * 60); // 1 hour.

/// Time in the future the Token can be valid for.
const MAX_TOKEN_SKEW: Duration = Duration::from_secs(5 * 60); // 5 minutes

/// When added to an endpoint, this hook is called per request to verify the bearer token
/// is valid.
async fn checker_api_catalyst_auth(
    _req: &Request, bearer: Bearer,
) -> poem::Result<CatalystRBACTokenV1> {
    // First check the token can be deserialized.
    let token = match CatalystRBACTokenV1::decode(&bearer.token) {
        Ok(token) => token,
        Err(err) => {
            // Corrupted Authorisation Token received
            error!("Corrupt auth token: {:?}", err);
            Err(AuthTokenError)?
        },
    };

    // Check if the token is young enough.
    if !token.is_young(MAX_TOKEN_AGE, MAX_TOKEN_SKEW) {
        // Token is too old or too far in the future.
        error!("Auth token expired: {:?}", token);
        Err(AuthTokenAccessViolation(vec!["EXPIRED".to_string()]))?;
    }

    // Its valid and young enough, check if its in the auth cache.
    // This get() will extend the entry life for another 5 minutes.
    // Even though we keep calling get(), the entry will expire
    // after 30 minutes (TTL) from the origin insert().
    // This is an optimization which saves us constantly looking up registrations we have
    // already validated.
    if let Some(token) = CACHE.get(&bearer.token).await {
        return Ok(token);
    }

    // Ok, so its validly decoded, but we haven't seen it before.
    // Check that the token is able to be authorized.

    // Get pub key from CERTS state given decoded KID from decoded bearer token
    // TODO: FIXME: Remove CERTS?..
    let pub_key_bytes = if let Some(cert) = CERTS.get(&hex::encode(token.kid.0)) {
        *cert
    } else {
        error!("Invalid KID {:?}", token.kid);
        Err(AuthTokenAccessViolation(vec!["UNREGISTERED".to_string()]))?
    };

    // TODO: FIXME: Better error handling?
    let Some(session) = CassandraSession::get(true) else {
        let error = ServiceUnavailable::new(None);
        let retry = RetryAfterHeader::default();
        error!(id=%error.id(), error = "Failed to acquire db session", retry_after=?retry);
        return Err(ErrorResponses::ServiceUnavailable(Json(error), Some(retry)).into());
    };

    let chain_root = match GetRole0ChainRootQuery::execute(&session, GetRole0ChainRootQueryParams {
        role0_key: token.kid.0.into(),
    })
    .await
    {
        Ok(mut iter) => {
            match iter.next().await {
                None => {
                    error!("Invalid KID {:?}", token.kid);
                    return Err(AuthTokenAccessViolation(vec!["UNREGISTERED".to_string()]).into());
                },
                Some(Err(e)) => {
                    error!("Failed to parse 'get chain root by role 0 key' query: {e:?}");
                    let error = InternalServerError::new(None);
                    return Err(ErrorResponses::ServerError(Json(error)).into());
                },
                Some(Ok(r)) => r.chain_root,
            }
        },
        Err(e) => {
            error!("Failed to execute 'get chain root by role 0 key' query: {e:?}");
            let error = InternalServerError::new(None);
            return Err(ErrorResponses::ServerError(Json(error)).into());
        },
    };
    let _fixme = chain_root;

    // TODO: FIXME: Check if the latest KID.
    // TODO: FIXME: Get the cert.

    // Verify the token signature using the public key.
    let public_key = match VerifyingKey::from_bytes(&pub_key_bytes) {
        Ok(pub_key) => pub_key,
        Err(err) => {
            // In theory this should never happen.
            error!("Invalid public key: {:?}", err);
            Err(AuthTokenAccessViolation(vec![
                "INVALID PUBLIC KEY".to_string()
            ]))?
        },
    };

    if let Err(error) = token.verify(&public_key) {
        error!(error=%error, "Token Invalidly Signed");
        Err(AuthTokenAccessViolation(vec![
            "INVALID SIGNATURE".to_string()
        ]))?;
    }

    // This entry will expire after 5 minutes (TTI) if there is no more ().
    CACHE.insert(bearer.token, token.clone()).await;

    Ok(token)
}
