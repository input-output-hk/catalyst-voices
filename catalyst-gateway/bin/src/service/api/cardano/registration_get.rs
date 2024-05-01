//! Implementation of the GET `/registration` endpoint

use poem_openapi::{payload::Json, ApiResponse};

use crate::{
    event_db::{cardano::chain_state::SlotNumber, error::NotFoundError},
    service::{
        common::{
            objects::{
                cardano::{
                    network::Network, registration_info::RegistrationInfo,
                    stake_address::StakeAddress,
                },
                server_error::ServerError,
                validation_error::ValidationError,
            },
            responses::handle_5xx_response,
        },
        utilities::check_network,
    },
    state::State,
};

/// All Responses
#[derive(ApiResponse)]
pub(crate) enum AllResponses {
    /// Returns the staked ada amount.
    #[oai(status = 200)]
    Ok(Json<RegistrationInfo>),
    /// Content validation error.
    #[oai(status = 400)]
    ValidationError(Json<ValidationError>),
    /// Content not found.
    #[oai(status = 404)]
    NotFound,
    /// Internal Server Error.
    ///
    /// *The contents of this response should be reported to the projects issue tracker.*
    #[oai(status = 500)]
    ServerError(Json<ServerError>),
    /// Service is not ready, do not send other requests.
    #[oai(status = 503)]
    ServiceUnavailable,
}

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
        Err(err) => return AllResponses::ValidationError(Json(err)),
    };

    // get the total utxo amount from the database
    match event_db
        .get_registration_info(stake_credential, network.into(), date_time)
        .await
    {
        Ok((tx_id, payment_address, voting_info, nonce)) => {
            AllResponses::Ok(Json(RegistrationInfo::new(
                tx_id,
                &payment_address,
                voting_info,
                nonce,
            )))
        },
        Err(err) if err.is::<NotFoundError>() => AllResponses::NotFound,
        Err(err) => handle_5xx_response!(err),
    }
}
