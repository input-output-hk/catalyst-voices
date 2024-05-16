//! Implementation of the GET `/date_time_to_slot_number` endpoint

use poem_openapi::{payload::Json, ApiResponse};

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
        responses::WithErrorResponses,
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
pub(crate) type AllResponses = WithErrorResponses<Responses>;

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
        Err(err) => return AllResponses::handle_error(&err),
    };
    let previous = match process_slot_info_result(previous) {
        Ok(current) => current,
        Err(err) => return AllResponses::handle_error(&err),
    };
    let next = match process_slot_info_result(next) {
        Ok(current) => current,
        Err(err) => return AllResponses::handle_error(&err),
    };

    Responses::Ok(Json(SlotInfo {
        previous,
        current,
        next,
    }))
    .into()
}
