//! Implementation of the GET `/rbac/chain_root` endpoint.
use futures::StreamExt as _;
use poem_openapi::{payload::Json, ApiResponse, Object};
use tracing::error;

use crate::{
    db::index::{
        queries::rbac::get_chain_root::{GetChainRootQuery, GetChainRootQueryParams},
        session::CassandraSession,
    },
    service::common::{
        objects::cardano::stake_address::StakeAddress, responses::WithErrorResponses,
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
    /// Success returns the chain root hash.
    #[oai(status = 200)]
    Ok(Json<Response>),
    /// No chain root found for the given stake address.
    #[oai(status = 404)]
    NotFound,
    /// Internal server error.
    #[oai(status = 500)]
    InternalServerError,
}

pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// Get chain root endpoint.
pub(crate) async fn endpoint(stake_address: StakeAddress) -> AllResponses {
    let Some(session) = CassandraSession::get(true) else {
        error!("Failed to acquire db session");
        return Responses::InternalServerError.into();
    };

    let query_res = GetChainRootQuery::execute(
        &session,
        GetChainRootQueryParams {
            stake_address: stake_address.to_vec(),
        },
    )
    .await;

    match query_res {
        Ok(mut row_iter) => {
            if let Some(row_res) = row_iter.next().await {
                let row = match row_res {
                    Ok(row) => row,
                    Err(err) => {
                        error!(error = ?err, "Failed to parse get chain root by stake address query row");
                        return Responses::InternalServerError.into();
                    },
                };

                let res = Response {
                    chain_root: format!("0x{}", hex::encode(row.chain_root)),
                };

                Responses::Ok(Json(res)).into()
            } else {
                Responses::NotFound.into()
            }
        },
        Err(err) => {
            error!(error = ?err, "Failed to execute get chain root by stake address query");
            Responses::InternalServerError.into()
        },
    }
}
