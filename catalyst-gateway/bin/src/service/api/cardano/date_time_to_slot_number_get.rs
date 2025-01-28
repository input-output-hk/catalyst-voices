//! Implementation of the GET `/date_time_to_slot_number` endpoint

use cardano_blockchain_types::Network;
use poem_openapi::{payload::Json, types::Example, ApiResponse};

use super::types::DateTime;
use crate::service::common::{
    objects::cardano::slot_info::{Slot, SlotInfo},
    responses::WithErrorResponses,
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
#[allow(clippy::unused_async, clippy::no_effect_underscore_binding)]
pub(crate) async fn endpoint(
    date_time: Option<DateTime>, network: Option<Network>,
) -> AllResponses {
    let _date_time = date_time.unwrap_or_else(chrono::Utc::now);
    let _network = network.unwrap_or(Network::Mainnet);

    let previous = Some(Slot::example());
    let current = Some(Slot::example());
    let next = Some(Slot::example());

    let _unused = "
        let (previous, current, next) = tokio::join!(
            EventDB::get_slot_info(
                date_time,
                network.clone().into(),
                SlotInfoQueryType::Previous
            ),
            EventDB::get_slot_info(
                date_time,
                network.clone().into(),
                SlotInfoQueryType::Current
            ),
            EventDB::get_slot_info(date_time, network.into(), SlotInfoQueryType::Next)
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
    ";

    Responses::Ok(Json(SlotInfo {
        previous,
        current,
        next,
    }))
    .into()
}
