//! Implementation of the GET `/date_time_to_slot_number` endpoint

use poem_extensions::{
    response,
    UniResponse::{T200, T503},
};
use poem_openapi::payload::Json;

use crate::{
    cli::Error,
    event_db::{error::Error as DBError, follower::DateTime},
    service::common::{
        objects::cardano::{
            network::Network,
            slot_info::{Slot, SlotInfo},
        },
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
    200: OK<Json<SlotInfo>>,
    400: ApiValidationError,
    500: ServerError,
    503: ServiceUnavailable,
};

/// # GET `/date_time_to_slot_number`
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(
    state: &State, date_time: Option<DateTime>, network: Option<Network>,
) -> AllResponses {
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

    let date_time = date_time.unwrap_or_else(chrono::Utc::now);
    let network = network.unwrap_or(Network::Mainnet);

    let current = match event_db
        .current_slot_info(date_time, network.clone().into())
        .await
    {
        Ok((slot_number, block_hash, block_time)) => {
            Some(Slot {
                slot_number,
                block_hash,
                block_time,
            })
        },
        Err(DBError::NotFound) => None,
        Err(err) => return server_error_response!("{err}"),
    };

    let next = match event_db.next_slot_info(date_time, network.into()).await {
        Ok((slot_number, block_hash, block_time)) => {
            Some(Slot {
                slot_number,
                block_hash,
                block_time,
            })
        },
        Err(DBError::NotFound) => None,
        Err(err) => return server_error_response!("{err}"),
    };

    T200(OK(Json(SlotInfo { current, next })))
}
