//! Implementation of the GET `/staked_ada` endpoint

use poem_openapi::{payload::Json, ApiResponse};

use crate::{
    event_db::{
        cardano::chain_state::SlotNumber,
        error::{NotFoundError, TimedOutError},
    },
    service::{
        common::{
            objects::cardano::{
                network::Network, stake_address::StakeAddress, stake_info::StakeInfo,
            },
            responses::WithAllErrorResponse,
        },
        utilities::check_network,
    },
    state::State,
};

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// The amount of ADA staked by the queried stake address, as at the indicated slot.
    #[oai(status = 200)]
    Ok(Json<StakeInfo>),
    /// The queried stake address was not found at the requested slot number.
    #[oai(status = 404)]
    NotFound,
}

/// All responses.
pub(crate) type AllResponses = WithAllErrorResponse<Responses>;

/// # GET `/staked_ada`
pub(crate) async fn endpoint(
    state: &State, stake_address: StakeAddress, provided_network: Option<Network>,
    slot_num: Option<SlotNumber>,
) -> AllResponses {
    let event_db = state.event_db();

    let date_time = slot_num.unwrap_or(SlotNumber::MAX);
    let stake_credential = stake_address.payload().as_hash().to_vec();

    let network = match check_network(stake_address.network(), provided_network) {
        Ok(network) => network,
        Err(err) => return AllResponses::bad_request(&err),
    };

    // get the total utxo amount from the database
    match event_db
        .total_utxo_amount(stake_credential, network.into(), date_time)
        .await
    {
        Ok((amount, slot_number)) => {
            Responses::Ok(Json(StakeInfo {
                amount,
                slot_number,
            }))
            .into()
        },
        Err(err) if err.is::<NotFoundError>() => Responses::NotFound.into(),
        Err(err) if err.is::<TimedOutError>() => AllResponses::service_unavailable(),
        Err(err) => AllResponses::internal_server_error(&err),
    }
}
