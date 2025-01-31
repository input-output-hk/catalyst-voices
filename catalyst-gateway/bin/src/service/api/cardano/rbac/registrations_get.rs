//! Implementation of the GET `/rbac/registrations` endpoint.
use anyhow::anyhow;
use futures::StreamExt;
use poem_openapi::{payload::Json, ApiResponse, Object};
use tracing::error;

use crate::{
    db::index::{
        queries::rbac::get_registrations::{
            GetRegistrationsByChainRootQuery, GetRegistrationsByChainRootQueryParams,
        },
        session::CassandraSession,
    },
    service::common::{
        objects::cardano::hash::Hash, responses::WithErrorResponses,
        types::headers::retry_after::RetryAfterOption,
    },
};

/// GET RBAC registrations by chain root response list item.
#[derive(Object)]
pub(crate) struct RbacRegistration {
    /// Registration transaction hash.
    tx_hash: Hash,
}

/// GET RBAC registrations by chain root response.
#[derive(Object)]
pub(crate) struct RbacRegistrationsResponse {
    /// Registrations by RBAC chain root.
    #[oai(validator(max_items = "100000"))]
    registrations: Vec<RbacRegistration>,
}

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// Success returns a list of registration transaction ids.
    #[oai(status = 200)]
    Ok(Json<RbacRegistrationsResponse>),
    /// Response for unprocessable content.
    #[oai(status = 422)]
    UnprocessableContent,
}

pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// Get chain root endpoint.
pub(crate) async fn endpoint(chain_root: String) -> AllResponses {
    let Some(session) = CassandraSession::get(true) else {
        error!("Failed to acquire db session");
        let err = anyhow::anyhow!("Failed to acquire db session");
        return AllResponses::service_unavailable(&err, RetryAfterOption::Default);
    };

    let Ok(decoded_chain_root) = hex::decode(chain_root) else {
        return Responses::UnprocessableContent.into();
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
        Err(err) => {
            error!(
                error = ?err,
                "Failed to execute get registrations by chain root query"
            );
            return AllResponses::internal_error(&err);
        },
    };

    let mut registrations = Vec::new();
    while let Some(row_res) = row_iter.next().await {
        let row = match row_res {
            Ok(row) => row,
            Err(err) => {
                error!(error = ?err, "Failed to parse get registrations by chain root query row");
                let err = anyhow!(err);
                return AllResponses::internal_error(&err);
            },
        };

        let item = RbacRegistration {
            tx_hash: row.transaction_id.into(),
        };
        registrations.push(item);
    }

    Responses::Ok(Json(RbacRegistrationsResponse { registrations })).into()
}
