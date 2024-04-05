//! Implementation of the GET `/date_time_to_slot_number` endpoint

use poem_extensions::{response, UniResponse::T503};

use crate::{
    cli::Error,
    event_db::{error::Error as DBError, follower::DateTime},
    service::common::{
        objects::cardano::network::Network,
        responses::{
            resp_4xx::ApiValidationError,
            resp_5xx::{server_error_response, ServerError, ServiceUnavailable},
        },
    },
    state::{SchemaVersionStatus, State},
};

/// # All Responses
pub(crate) type AllResponses = response! {
    // 200: OK<Json<Option<SyncState>>>,
    400: ApiValidationError,
    500: ServerError,
    503: ServiceUnavailable,
};

/// # GET `/date_time_to_slot_number`
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(
    state: &State, _date_time: DateTime, _network: Option<Network>,
) -> AllResponses {
    match state.event_db() {
        Ok(_event_db) => T503(ServiceUnavailable),
        Err(Error::EventDb(DBError::MismatchedSchema { was, expected })) => {
            tracing::error!(
                expected = expected,
                current = was,
                "DB schema version status mismatch"
            );
            state.set_schema_version_status(SchemaVersionStatus::Mismatch);
            T503(ServiceUnavailable)
        },
        Err(err) => server_error_response!("{err}"),
    }
}
