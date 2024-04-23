//! Implementation of the GET `/date_time_to_slot_number` endpoint

use poem_extensions::{response, UniResponse::T200};
use poem_openapi::payload::Json;

use crate::{
    event_db::{
        cardano::chain_state::{BlockHash, DateTime, SlotInfoQueryType, SlotNumber},
        error::NotFoundError,
    },
    service::common::{
        objects::cardano::{
            network::Network,
            slot_info::{Slot, SlotInfo},
        },
        responses::{
            resp_2xx::OK,
            resp_4xx::ApiValidationError,
            resp_5xx::{handle_5xx_response, ServerError, ServiceUnavailable},
        },
    },
    state::State,
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
    let event_db = state.event_db();

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

    let process_slot_info_result =
        |slot_info_result: anyhow::Result<(SlotNumber, BlockHash, DateTime)>| {
            match slot_info_result {
                Ok((slot_number, block_hash, block_time)) => {
                    Ok(Some(Slot {
                        slot_number,
                        block_hash: From::from(block_hash),
                        block_time,
                    }))
                },
                Err(err) if err.is::<NotFoundError>() => Ok(None),
                Err(err) => Err(err),
            }
        };

    let current = match process_slot_info_result(current) {
        Ok(current) => current,
        Err(err) => return handle_5xx_response!(err),
    };
    let previous = match process_slot_info_result(previous) {
        Ok(current) => current,
        Err(err) => return handle_5xx_response!(err),
    };
    let next = match process_slot_info_result(next) {
        Ok(current) => current,
        Err(err) => return handle_5xx_response!(err),
    };

    T200(OK(Json(SlotInfo {
        previous,
        current,
        next,
    })))
}
