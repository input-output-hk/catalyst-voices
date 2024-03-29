//! Implementation of the GET `/follower/sync_state` endpoint

use poem_extensions::{
    response,
    UniResponse::{T200, T500, T503},
};
use poem_openapi::{payload::Json, types::Example};

use crate::{
    cli::Error,
    event_db::error::Error as DBError,
    service::common::{
        objects::cardano::sync_state::SyncState,
        responses::{
            resp_2xx::OK,
            resp_5xx::{server_error, ServerError, ServiceUnavailable},
        },
    },
    state::{SchemaVersionStatus, State},
};

/// # All Responses
pub(crate) type AllResponses = response! {
    200: OK<Json<Option<SyncState>>>,
    500: ServerError,
    503: ServiceUnavailable,
};

/// # GET `/utxo/staked_ada`
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(state: &State) -> AllResponses {
    match state.event_db() {
        Ok(_event_db) => T200(OK(Json(Some(SyncState::example())))),
        Err(Error::EventDb(DBError::MismatchedSchema { was, expected })) => {
            tracing::error!(
                expected = expected,
                current = was,
                "DB schema version status mismatch"
            );
            state.set_schema_version_status(SchemaVersionStatus::Mismatch);
            T503(ServiceUnavailable)
        },
        Err(err) => T500(server_error!("{}", err.to_string())),
    }
}
