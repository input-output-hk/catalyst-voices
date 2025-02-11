//! Implementation of the GET `/rbac/role0_chain_root` endpoint.
use anyhow::anyhow;
use futures::StreamExt;
use poem_openapi::{payload::Json, ApiResponse, Object};
use tracing::error;

use crate::{
    db::index::{
        queries::rbac::get_role0_chain_root::{
            GetRole0ChainRootQuery, GetRole0ChainRootQueryParams,
        },
        session::CassandraSession,
    },
    service::common::{
        objects::cardano::hash::Hash256, responses::WithErrorResponses,
        types::headers::retry_after::RetryAfterOption,
    },
};

/// GET RBAC chain root response.
#[derive(Object)]
pub(crate) struct RbacRole0ChainRootResponse {
    /// RBAC certificate chain root.
    chain_root: Hash256,
}

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// ## Ok
    ///
    /// Success returns the chain root hash.
    #[oai(status = 200)]
    Ok(Json<RbacRole0ChainRootResponse>),
    /// ## Not Found
    /// No chain root found for the given stake address.
    #[oai(status = 404)]
    NotFound,
    /// ## Unprocessable Content
    ///
    /// Response for unprocessable content.
    #[oai(status = 422)]
    UnprocessableContent,
}

pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// Get chain root for role0 key endpoint.
pub(crate) async fn endpoint(role0_key: String) -> AllResponses {
    let Some(session) = CassandraSession::get(true) else {
        error!("Failed to acquire db session");
        let err = anyhow::anyhow!("Failed to acquire db session");
        return AllResponses::service_unavailable(&err, RetryAfterOption::Default);
    };

    let Ok(decoded_role0_key) = hex::decode(role0_key) else {
        return Responses::UnprocessableContent.into();
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
                    Err(err) => {
                        error!(error = ?err, "Failed to parse get chain root by role0 key query row");
                        let err = anyhow!(err);
                        return AllResponses::internal_error(&err);
                    },
                };

                let res = RbacRole0ChainRootResponse {
                    chain_root: Hash256::from(row.chain_root),
                };

                Responses::Ok(Json(res)).into()
            } else {
                Responses::NotFound.into()
            }
        },
        Err(err) => {
            error!(error = ?err, "Failed to execute get chain root by role0 key query");
            AllResponses::internal_error(&err)
        },
    }
}
