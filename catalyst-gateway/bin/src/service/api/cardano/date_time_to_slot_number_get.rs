//! Implementation of the GET `/date_time_to_slot_number` endpoint

use poem_extensions::{
    response,
    UniResponse::{T200, T503},
};
use poem_openapi::payload::Json;

use crate::{
    cli::Error,
    event_db::{
        error::Error as DBError,
        follower::{DateTime, SlotInfoQueryType},
    },
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

    let (previous, current, next) = tokio::join!(
        event_db.get_slot_info(
            date_time,
            network.clone().into(),
            SlotInfoQueryType::Previous
        ),
        event_db.get_slot_info(
            date_time,
            network.clone().into(),
            SlotInfoQueryType::Current
        ),
        event_db.get_slot_info(date_time, network.into(), SlotInfoQueryType::Next)
    );

    let process_slot_info_result = |slot_info_result| {
        match slot_info_result {
            Ok((slot_number, block_hash, block_time)) => {
                Ok(Some(Slot {
                    slot_number,
                    block_hash,
                    block_time,
                }))
            },
            Err(DBError::NotFound) => Ok(None),
            Err(err) => Err(err),
        }
    };

    let current = match process_slot_info_result(current) {
        Ok(current) => current,
        Err(err) => return server_error_response!("{err}"),
    };
    let previous = match process_slot_info_result(previous) {
        Ok(current) => current,
        Err(err) => return server_error_response!("{err}"),
    };
    let next = match process_slot_info_result(next) {
        Ok(current) => current,
        Err(err) => return server_error_response!("{err}"),
    };

    T200(OK(Json(SlotInfo {
        previous,
        current,
        next,
    })))
}
