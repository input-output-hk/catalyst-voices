//! Catalyst RBAC Security Scheme
use std::{env, error::Error, time::Duration};

use catalyst_types::catalyst_id::role_index::RoleId;
use poem::{error::ResponseError, http::StatusCode, IntoResponse, Request};
use poem_openapi::{auth::Bearer, SecurityScheme};
use tracing::{debug, error};

use super::token::CatalystRBACTokenV1;
use crate::{
    db::index::session::CassandraSessionError,
    rbac::latest_rbac_chain,
    service::common::{
        auth::api_key::check_api_key,
        responses::{ErrorResponses, WithErrorResponses},
        types::headers::retry_after::{RetryAfterHeader, RetryAfterOption},
    },
};

/// The header name that holds the authorization RBAC token
pub(crate) const AUTHORIZATION_HEADER: &str = "Authorization";

/// Catalyst RBAC Access Token
#[derive(SecurityScheme)]
#[oai(
    ty = "bearer",
    key_name = "Authorization", // MUST match the `AUTHORIZATION_HEADER` constant.
    bearer_format = "catalyst-rbac-token",
    checker = "checker_api_catalyst_auth"
)]
#[allow(clippy::module_name_repetitions)]
pub(crate) struct CatalystRBACSecurityScheme(CatalystRBACTokenV1);

impl From<CatalystRBACSecurityScheme> for CatalystRBACTokenV1 {
    fn from(value: CatalystRBACSecurityScheme) -> Self {
        value.0
    }
}

/// Error with the service while processing a Catalyst RBAC Token
///
/// Can be related to database session failure.
#[derive(Debug, thiserror::Error)]
#[error("Service unavailable while processing a Catalyst RBAC Token")]
pub struct ServiceUnavailableError(pub anyhow::Error);

impl ResponseError for ServiceUnavailableError {
    fn status(&self) -> StatusCode {
        StatusCode::SERVICE_UNAVAILABLE
    }

    /// Convert this error to a HTTP response.
    fn as_response(&self) -> poem::Response
    where Self: Error + Send + Sync + 'static {
        WithErrorResponses::<()>::service_unavailable(
            &self.0,
            RetryAfterOption::Some(RetryAfterHeader::default()),
        )
        .into_response()
    }
}

/// Authentication token error.
#[derive(Debug, thiserror::Error)]
enum AuthTokenError {
    /// Registration chain cannot be built.
    #[error("Unable to build registration chain, err: {0}")]
    BuildRegChain(String),
    /// RBAC token cannot be parsed.
    #[error("Fail to parse RBAC token string, err: {0}")]
    ParseRbacToken(String),
    /// Registration chain cannot be found.
    #[error("Registration not found for the auth token.")]
    RegistrationNotFound,
    /// Latest signing key cannot be found.
    #[error("Unable to get the latest signing key.")]
    LatestSigningKey,
}

impl ResponseError for AuthTokenError {
    fn status(&self) -> StatusCode {
        StatusCode::UNAUTHORIZED
    }

    /// Convert this error to a HTTP response.
    fn as_response(&self) -> poem::Response
    where Self: Error + Send + Sync + 'static {
        ErrorResponses::unauthorized(self.to_string()).into_response()
    }
}

/// Token does not have required access rights
///
/// Not enough access rights, so its a 403 response.
#[derive(Debug, thiserror::Error)]
#[error("Insufficient Permission for Catalyst RBAC Token: {0:?}")]
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
/// is valid. The performed validation is described [here].
///
/// [here]: https://github.com/input-output-hk/catalyst-voices/blob/main/docs/src/catalyst-standards/permissionless-auth/auth-header.md#backend-processing-of-the-token
async fn checker_api_catalyst_auth(
    req: &Request, bearer: Bearer,
) -> poem::Result<CatalystRBACTokenV1> {
    /// Temporary: Conditional RBAC for testing
    const RBAC_OFF: &str = "RBAC_OFF";

    // Deserialize the token: this performs the 1-5 steps of the validation.
    let token = CatalystRBACTokenV1::parse(&bearer.token).map_err(|e| {
        debug!("Corrupt auth token: {e:?}");
        AuthTokenError::ParseRbacToken(e.to_string())
    })?;

    // If env var explicitly set by SRE, switch off full verification
    if env::var(RBAC_OFF).is_ok() {
        return Ok(token);
    };

    // Step 6: get the registration chain
    let reg_chain = match latest_rbac_chain(token.catalyst_id()).await {
        Ok(Some(c)) => c.chain,
        Ok(None) => {
            debug!(
                "Unable to find registrations for {} Catalyst ID",
                token.catalyst_id()
            );
            return Err(AuthTokenError::RegistrationNotFound.into());
        },
        Err(e) if e.is::<CassandraSessionError>() => return Err(ServiceUnavailableError(e).into()),
        Err(e) => {
            // This should never happen normally because we validate RBAC registration transactions
            // before adding them to the database.
            error!("Unable to build a registration chain Catalyst ID: {e:?}");
            return Err(AuthTokenError::BuildRegChain(e.to_string()).into());
        },
    };

    // Step 7: Verify that the nonce is in the acceptable range.
    // If `InternalApiKeyAuthorization` auth is provided, skip validation.
    if check_api_key(req.headers()).is_err() && !token.is_young(MAX_TOKEN_AGE, MAX_TOKEN_SKEW) {
        // Token is too old or too far in the future.
        debug!("Auth token expired: {token}");
        Err(AuthTokenAccessViolation(vec!["EXPIRED".to_string()]))?;
    }

    // Step 8: Get the latest stable signing certificate registered for Role 0.
    let (latest_pk, _) = reg_chain
        .get_latest_signing_pk_for_role(&RoleId::Role0)
        .ok_or_else(|| {
            debug!(
                "Unable to get last signing key for {} Catalyst ID",
                token.catalyst_id()
            );
            AuthTokenError::LatestSigningKey
        })?;

    // Step 9: Verify the signature against the Role 0 pk.
    if let Err(error) = token.verify(&latest_pk) {
        debug!(error=%error, "Invalid signature for token: {token}");
        Err(AuthTokenAccessViolation(vec![
            "INVALID SIGNATURE".to_string()
        ]))?;
    }

    // Step 10 is optional and isn't currently implemented.
    //   - Get the latest unstable signing certificate registered for Role 0.
    //   - Verify the signature against the Role 0 Public Key and Algorithm identified by the
    //     certificate. If this fails, return 403.

    // Step 11: Token is valid
    Ok(token)
}
