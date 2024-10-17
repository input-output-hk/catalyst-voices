//! Implementation of the GET `/rbac/registrations` endpoint.
use anyhow::anyhow;
use futures::StreamExt as _;
use poem_openapi::{payload::Json, ApiResponse};

use crate::{
    db::index::{
        queries::rbac::get_registrations::{
            GetRegistrationsByChainRootQuery, GetRegistrationsByChainRootQueryParams,
        },
        session::CassandraSession,
    },
    service::common::responses::WithErrorResponses,
};

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// Success returns a list of registration transaction ids.
    #[oai(status = 200)]
    Ok(Json<Vec<String>>),
}

pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// Get chain root endpoint.
pub(crate) async fn endpoint(chain_root: String) -> AllResponses {
    let Some(session) = CassandraSession::get(true) else {
        return AllResponses::handle_error(&anyhow!("Failed to connect to database"));
    };

    let decoded_chain_root = match hex::decode(chain_root) {
        Ok(s) => s,
        Err(err) => return AllResponses::handle_error(&anyhow!(err)),
    };

    let query_res = GetRegistrationsByChainRootQuery::execute(
        &session,
        GetRegistrationsByChainRootQueryParams {
            chain_root: decoded_chain_root,
        },
    )
    .await;

    let mut row_iter = match query_res {
        Ok(row_iter) => row_iter,
        Err(err) => return AllResponses::handle_error(&anyhow!(err)),
    };

    let mut registrations = Vec::new();
    while let Some(row_res) = row_iter.next().await {
        let row = match row_res {
            Ok(row) => row,
            Err(err) => return AllResponses::handle_error(&anyhow!(err)),
        };

        let tx_id = hex::encode(row.transaction_id);
        registrations.push(tx_id);
    }

    Responses::Ok(Json(registrations)).into()
}
