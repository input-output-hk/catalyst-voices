//! Implementation of the GET `/rbac/registrations` endpoint.
use futures::StreamExt as _;
use poem_openapi::{payload::Json, ApiResponse, Object};
use tracing::error;

use crate::{
    db::index::{
        queries::rbac::get_registrations::{
            GetRegistrationsByChainRootQuery, GetRegistrationsByChainRootQueryParams,
        },
        session::CassandraSession,
    },
    service::common::{objects::cardano::hash::Hash, responses::WithErrorResponses},
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
    /// Response for bad requests.
    #[oai(status = 400)]
    BadRequest,
    /// Internal server error.
    #[oai(status = 500)]
    InternalServerError,
}

pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// Get chain root endpoint.
pub(crate) async fn endpoint(chain_root: String) -> AllResponses {
    let Some(session) = CassandraSession::get(true) else {
        error!("Failed to acquire db session");
        return Responses::InternalServerError.into();
    };

    let Ok(decoded_chain_root) = hex::decode(chain_root) else {
        return Responses::BadRequest.into();
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
            return Responses::InternalServerError.into();
        },
    };

    let mut registrations = Vec::new();
    while let Some(row_res) = row_iter.next().await {
        let row = match row_res {
            Ok(row) => row,
            Err(err) => {
                error!(error = ?err, "Failed to parse get registrations by chain root query row");
                return Responses::InternalServerError.into();
            },
        };

        let item = RbacRegistration {
            tx_hash: row.transaction_id.into(),
        };
        registrations.push(item);
    }

    Responses::Ok(Json(RbacRegistrationsResponse { registrations })).into()
}
