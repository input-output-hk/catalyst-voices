//! Implementation of the GET `/rbac/role0_chain_root` endpoint.

use poem_openapi::{payload::Json, ApiResponse, Object};
use tracing::error;

use crate::{
    db::index::session::CassandraSession,
    service::common::{
        objects::cardano::hash::Hash256, responses::WithErrorResponses,
        types::headers::retry_after::RetryAfterOption,
    },
};

/// GET RBAC chain root response.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct RbacRole0ChainRootResponse {
    /// RBAC certificate chain root.
    chain_root: Hash256,
}

/// Endpoint responses.
#[allow(dead_code)]
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// ## Ok
    ///
    /// Success returns the chain root hash.
    #[oai(status = 200)]
    Ok(Json<RbacRole0ChainRootResponse>),
}

pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// Get chain root for role0 key endpoint.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(_role0_key: String) -> AllResponses {
    let Some(_session) = CassandraSession::get(true) else {
        error!("Failed to acquire db session");
        let err = anyhow::anyhow!("Failed to acquire db session");
        return AllResponses::service_unavailable(&err, RetryAfterOption::Default);
    };

    // TODO: This endpoint needs to be removed or updated because "chain root" was replaced by
    // Catalyst ID.
    AllResponses::forbidden(None)
}

impl Example for RbacRole0ChainRootResponse {
    fn example() -> Self {
        Self {
            chain_root: Hash256::example(),
        }
    }
}
