//! Implementation of the GET `/rbac/registrations` endpoint.

use anyhow::anyhow;
use cardano_blockchain_types::TransactionId;
use catalyst_types::id_uri::IdUri;
use futures::StreamExt;
use poem_openapi::{payload::Json, ApiResponse, Object};
use tracing::error;

use crate::{
    db::index::{
        queries::rbac::get_rbac_registrations::{Query, QueryParams},
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
    /// ## Ok
    ///
    /// Success returns a list of registration transaction ids.
    #[oai(status = 200)]
    Ok(Json<RbacRegistrationsResponse>),
}

pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// Get chain root endpoint.
pub(crate) async fn endpoint(catalyst_id: IdUri) -> AllResponses {
    let Some(session) = CassandraSession::get(true) else {
        error!("Failed to acquire db session");
        let err = anyhow::anyhow!("Failed to acquire db session");
        return AllResponses::service_unavailable(&err, RetryAfterOption::Default);
    };

    let query_res = Query::execute(&session, QueryParams {
        catalyst_id: catalyst_id.into(),
    })
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

        let tx_hash: Vec<_> = TransactionId::from(row.txn_id).into();
        let item = RbacRegistration {
            tx_hash: tx_hash.into(),
        };
        registrations.push(item);
    }

    Responses::Ok(Json(RbacRegistrationsResponse { registrations })).into()
}
