//! Implementation of the GET `/date_time_to_slot_number` endpoint

use poem_openapi::{payload::Json, ApiResponse};

use crate::{
    event_db::{
        cardano::chain_state::{DateTime, SlotInfoQueryType},
        error::{NotFoundError, TimedOutError},
    },
    service::common::{
        objects::cardano::{
            network::Network,
            slot_info::{Slot, SlotInfo},
        },
        responses::WithAllErrorResponse,
    },
    state::State,
};

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// Returns the slot info.
    #[oai(status = 200)]
    Ok(Json<SlotInfo>),
}

/// All responses.
pub(crate) type AllResponses = WithAllErrorResponse<Responses>;

/// Process slot info result
macro_rules! process_slot_info_result {
    ($slot_info_result:ident) => {
        match $slot_info_result {
            Ok((slot_number, block_hash, block_time)) => {
                Some(Slot {
                    slot_number,
                    block_hash: From::from(block_hash),
                    block_time,
                })
            },
            Err(err) if err.is::<NotFoundError>() => None,
            Err(err) if err.is::<TimedOutError>() => return AllResponses::service_unavailable(),
            Err(err) => return AllResponses::internal_server_error(&err),
        }
    };
}

/// # GET `/date_time_to_slot_number`
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

    let current = process_slot_info_result!(current);
    let previous = process_slot_info_result!(previous);
    let next = process_slot_info_result!(next);

    Responses::Ok(Json(SlotInfo {
        previous,
        current,
        next,
    }))
    .into()
}
