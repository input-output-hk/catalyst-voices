//! Implementation of the GET `/rbac/role0_chain_root` endpoint.
use anyhow::anyhow;
use futures::StreamExt as _;
use poem_openapi::{payload::Json, ApiResponse};

use crate::{
    db::index::{
        queries::rbac::get_role0_chain_root::{
            GetRole0ChainRootQuery, GetRole0ChainRootQueryParams,
        },
        session::CassandraSession,
    },
    service::common::responses::WithErrorResponses,
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

/// Get chain root for role0 key endpoint.
pub(crate) async fn endpoint(role0_key: String) -> AllResponses {
    let Some(session) = CassandraSession::get(true) else {
        return AllResponses::handle_error(&anyhow!("Failed to connect to database"));
    };

    let decoded_role0_key = match hex::decode(role0_key) {
        Ok(s) => s,
        Err(err) => return AllResponses::handle_error(&anyhow!(err)),
    };

    let query_res = GetRole0ChainRootQuery::execute(&session, GetRole0ChainRootQueryParams {
        role0_key: decoded_role0_key,
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
