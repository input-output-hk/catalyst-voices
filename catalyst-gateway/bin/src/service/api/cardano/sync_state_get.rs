//! Implementation of the GET `/sync_state` endpoint

use poem_extensions::{
    response,
    UniResponse::{T200, T503},
};
use poem_openapi::payload::Json;

use crate::{
    cli::Error,
    event_db::error::Error as DBError,
    service::common::{
        objects::cardano::{network::Network, sync_state::SyncState},
        responses::{
            resp_2xx::OK,
            resp_4xx::ApiValidationError,
            resp_5xx::{server_error_response, ServerError, ServiceUnavailable},
        },
    },
    state::{SchemaVersionStatus, State},
};

/// # All Responses
pub(crate) type AllResponses = response! {
    200: OK<Json<Option<SyncState>>>,
    400: ApiValidationError,
    500: ServerError,
    503: ServiceUnavailable,
};

/// # GET `/staked_ada`
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(state: &State, network: Option<Network>) -> AllResponses {
    let event_db = match state.event_db() {
        Ok(event_db) => event_db,
        Err(Error::EventDb(DBError::MismatchedSchema { was, expected })) => {
            tracing::error!(
                expected = expected,
                current = was,
                "DB schema version status mismatch"
            );
            state.set_schema_version_status(SchemaVersionStatus::Mismatch);
            return T503(ServiceUnavailable);
        },
        Err(err) => return server_error_response!("{err}"),
    };

    let network = network.unwrap_or(Network::Mainnet);

    match event_db.last_updated_metadata(network.into()).await {
        Ok((slot_number, block_hash, last_updated)) => {
            T200(OK(Json(Some(SyncState {
                slot_number,
                block_hash,
                last_updated,
            }))))
        },
        Err(err) => server_error_response!("{err}"),
    }
}
