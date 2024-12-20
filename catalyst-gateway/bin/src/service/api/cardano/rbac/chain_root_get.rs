//! Implementation of the GET `/rbac/chain_root` endpoint.
use anyhow::anyhow;
use der_parser::asn1_rs::ToDer;
use futures::StreamExt;
use poem_openapi::{payload::Json, ApiResponse, Object};
use tracing::error;

use crate::{
    db::index::{
        queries::rbac::get_chain_root_from_stake_addr::{self},
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
    /// Success returns the chain root hash.
    #[oai(status = 200)]
    Ok(Json<Response>),
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

    let Ok(stake_address) = stake_address.to_der_vec() else {
        error!("Failed to create stake address vec");
        let err = anyhow!("Failed to create stake address vec");
        return AllResponses::internal_error(&err);
    };

    let query_res = get_chain_root_from_stake_addr::Query::execute(
        &session,
        get_chain_root_from_stake_addr::QueryParams { stake_address },
    )
    .await;

    match query_res {
        Ok(mut row_iter) => {
            if let Some(row_res) = row_iter.next().await {
                let row = match row_res {
                    Ok(row) => row,
                    Err(err) => {
                        error!(error = ?err, "Failed to parse get chain root by stake address query row");
                        let err = anyhow!(err);
                        return AllResponses::internal_error(&err);
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
            let err = anyhow!(err);
            AllResponses::internal_error(&err)
        },
    }
}
