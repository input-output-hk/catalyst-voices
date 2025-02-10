//! Implementation of the GET `/rbac/chain_root` endpoint.

use anyhow::anyhow;
use catalyst_types::id_uri::IdUri;
use futures::StreamExt;
use pallas::ledger::addresses::StakeAddress;
use poem_openapi::{payload::Json, ApiResponse, Object};
use tracing::error;

use crate::{
    db::index::{
        queries::rbac::get_catalyst_id_from_stake_addr::{self},
        session::CassandraSession,
    },
    service::common::{
        responses::WithErrorResponses,
        types::{
            cardano::cip19_stake_address::Cip19StakeAddress, headers::retry_after::RetryAfterOption,
        },
    },
};

/// GET RBAC chain root response.
#[derive(Object)]
pub(crate) struct Response {
    /// RBAC certificate chain root.
    #[oai(validator(max_length = 66, min_length = 64, pattern = "0x[0-9a-f]{64}"))]
    chain_root: String,
}

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// ## Ok
    ///
    /// Success returns the chain root hash.
    #[oai(status = 200)]
    Ok(Json<Response>),
    /// ## Not Found
    ///
    /// No chain root found for the given stake address.
    #[oai(status = 404)]
    NotFound,
}

pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// Get chain root endpoint.
pub(crate) async fn endpoint(stake_address: Cip19StakeAddress) -> AllResponses {
    let Some(session) = CassandraSession::get(true) else {
        error!("Failed to acquire db session");
        let err = anyhow::anyhow!("Failed to acquire db session");
        return AllResponses::service_unavailable(&err, RetryAfterOption::Default);
    };

    // TODO: This endpoint needs to be removed or updated because "chain root" was replaced by
    // Catalyst ID.
    AllResponses::forbidden(None)
}
