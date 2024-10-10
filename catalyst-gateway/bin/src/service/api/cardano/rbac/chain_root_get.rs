//! Implementation of the GET `/rbac/chain_root` endpoint.
use anyhow::anyhow;
use futures::StreamExt as _;
use poem_openapi::{payload::Json, ApiResponse};

use crate::{
    db::index::{
        queries::rbac::get_chain_root::{GetChainRootQuery, GetChainRootQueryParams},
        session::CassandraSession,
    },
    service::common::{
        objects::cardano::stake_address::StakeAddress, responses::WithErrorResponses,
    },
};

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// Success returns the chain root hash.
    #[oai(status = 200)]
    Ok(Json<String>),
    /// No chain root found for the given stake address.
    #[oai(status = 404)]
    NotFound,
}

pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// Get chain root endpoint.
pub(crate) async fn endpoint(stake_address: StakeAddress) -> AllResponses {
    let Some(session) = CassandraSession::get(true) else {
        return AllResponses::handle_error(&anyhow!("Failed to connect to database"));
    };

    let query_res = GetChainRootQuery::execute(&session, GetChainRootQueryParams {
        stake_address: stake_address.to_vec(),
    })
    .await;

    match query_res {
        Ok(mut row_iter) => {
            if let Some(row_res) = row_iter.next().await {
                let row = match row_res {
                    Ok(row) => row,
                    Err(err) => return AllResponses::handle_error(&anyhow!(err)),
                };

                let chain_root_hex = hex::encode(row.chain_root);
                Responses::Ok(Json(chain_root_hex)).into()
            } else {
                Responses::NotFound.into()
            }
        },
        Err(err) => AllResponses::handle_error(&err),
    }
}
