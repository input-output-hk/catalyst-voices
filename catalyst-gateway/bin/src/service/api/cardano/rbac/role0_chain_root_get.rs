//! Implementation of the GET `/rbac/role0_chain_root` endpoint.
use futures::StreamExt as _;
use poem_openapi::{payload::Json, ApiResponse, Object};
use tracing::error;

use crate::{
    db::index::{
        queries::rbac::get_role0_chain_root::{
            GetRole0ChainRootQuery, GetRole0ChainRootQueryParams,
        },
        session::CassandraSession,
    },
    service::common::responses::WithErrorResponses,
};

/// GET RBAC chain root response.
#[derive(Object)]
pub(crate) struct RbacRole0ChainRootResponse {
    /// RBAC certificate chain root.
    #[oai(validator(max_length = 66, min_length = 64, pattern = "0x[0-9a-f]{64}"))]
    chain_root: String,
}

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// Success returns the chain root hash.
    #[oai(status = 200)]
    Ok(Json<RbacRole0ChainRootResponse>),
    /// No chain root found for the given stake address.
    #[oai(status = 404)]
    NotFound,
    /// Bad requests.
    #[oai(status = 400)]
    BadRequest,
    /// Internal server error
    #[oai(status = 500)]
    InternalServerError,
}

pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// Get chain root for role0 key endpoint.
pub(crate) async fn endpoint(role0_key: String) -> AllResponses {
    let Some(session) = CassandraSession::get(true) else {
        error!("Failed to acquire db session");
        return Responses::InternalServerError.into();
    };

    let Ok(decoded_role0_key) = hex::decode(role0_key) else {
        return Responses::BadRequest.into();
    };

    let query_res = GetRole0ChainRootQuery::execute(
        &session,
        GetRole0ChainRootQueryParams {
            role0_key: decoded_role0_key,
        },
    )
    .await;

    match query_res {
        Ok(mut row_iter) => {
            if let Some(row_res) = row_iter.next().await {
                let row = match row_res {
                    Ok(row) => row,
                    Err(err) => {
                        error!(error = ?err, "Failed to parse get chain root by role0 key query row");
                        return Responses::InternalServerError.into();
                    },
                };

                let res = RbacRole0ChainRootResponse {
                    chain_root: format!("0x{}", hex::encode(row.chain_root)),
                };

                Responses::Ok(Json(res)).into()
            } else {
                Responses::NotFound.into()
            }
        },
        Err(err) => {
            error!(error = ?err, "Failed to execute get chain root by role0 key query");
            Responses::InternalServerError.into()
        },
    }
}
