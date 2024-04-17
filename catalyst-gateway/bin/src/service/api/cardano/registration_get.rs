//! Implementation of the GET `/registration` endpoint

use poem_extensions::{
    response,
    UniResponse::{T200, T400, T404},
};
use poem_openapi::payload::Json;

use crate::{
    event_db::{cardano::follower::SlotNumber, error::NotFoundError},
    service::{
        common::{
            objects::cardano::{
                network::Network, registration_info::RegistrationInfo, stake_address::StakeAddress,
            },
            responses::{
                resp_2xx::OK,
                resp_4xx::{ApiValidationError, NotFound},
                resp_5xx::{handle_5xx_response, ServerError, ServiceUnavailable},
            },
        },
        utilities::check_network,
    },
    state::State,
};

/// # All Responses
#[allow(dead_code)]
pub(crate) type AllResponses = response! {
    200: OK<Json<RegistrationInfo>>,
    400: ApiValidationError,
    404: NotFound,
    500: ServerError,
    503: ServiceUnavailable,
};

/// # GET `/registration`
pub(crate) async fn endpoint(
    state: &State, stake_address: StakeAddress, provided_network: Option<Network>,
    slot_num: Option<SlotNumber>,
) -> AllResponses {
    let event_db = state.event_db();

    let date_time = slot_num.unwrap_or(SlotNumber::MAX);
    let stake_credential = stake_address.payload().as_hash().to_vec();
    let network = match check_network(stake_address.network(), provided_network) {
        Ok(network) => network,
        Err(err) => return T400(err),
    };

    // get the total utxo amount from the database
    match event_db
        .get_registration_info(stake_credential, network.into(), date_time)
        .await
    {
        Ok((tx_id, payment_address, voting_info, nonce)) => {
            T200(OK(Json(RegistrationInfo::new(
                tx_id,
                &payment_address,
                voting_info,
                nonce,
            ))))
        },
        Err(err) if err.is::<NotFoundError>() => T404(NotFound),
        Err(err) => handle_5xx_response!(err),
    }
}
