//! Implementation of the GET `/rbac/registrations` endpoint.

use anyhow::anyhow;
use cardano_blockchain_types::TransactionId;
use catalyst_types::id_uri::IdUri;
use futures::StreamExt;
use poem_openapi::{
    payload::Json,
    types::{Example, ToJSON},
    ApiResponse, Object,
};
use tracing::error;

use crate::{
    db::index::{
        queries::rbac::get_rbac_registrations::{Query, QueryParams},
        session::CassandraSession,
    },
    service::common::{
        objects::cardano::hash::Hash256,
        responses::WithErrorResponses,
        types::{array_types::impl_array_types, headers::retry_after::RetryAfterOption},
    },
};

/// GET RBAC registrations by chain root response list item.
#[derive(Object, Debug, Clone)]
#[oai(example = true)]
pub(crate) struct RbacRegistration {
    /// Registration transaction hash.
    tx_hash: Hash256,
}

impl Example for RbacRegistration {
    fn example() -> Self {
        Self {
            tx_hash: Example::example(),
        }
    }
}

// List of RBAC Registrations
impl_array_types!(
    RegistrationRbacList,
    RbacRegistration,
    Some(poem_openapi::registry::MetaSchema {
        example: Self::example().to_json(),
        max_items: Some(100_000),
        items: Some(Box::new(RbacRegistration::schema_ref())),
        ..poem_openapi::registry::MetaSchema::ANY
    })
);

impl Example for RegistrationRbacList {
    fn example() -> Self {
        Self(vec![Example::example()])
    }
}

/// GET RBAC registrations by chain root response.
#[derive(Object, Debug, Clone)]
#[oai(example = true)]
pub(crate) struct RbacRegistrationsResponse {
    /// Registrations by RBAC chain root.
    registrations: RegistrationRbacList,
}

impl Example for RbacRegistrationsResponse {
    fn example() -> Self {
        Self {
            registrations: Example::example(),
        }
    }
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
        let tx_hash = match TryFrom::try_from(tx_hash) {
            Ok(tx_hash) => tx_hash,
            Err(err) => {
                error!(error = ?err, "Failed to parse tx hash value from row");
                return AllResponses::internal_error(&err);
            },
        };

        let item = RbacRegistration { tx_hash };
        registrations.push(item);
    }

    Responses::Ok(Json(RbacRegistrationsResponse {
        registrations: registrations.into(),
    }))
    .into()
}
