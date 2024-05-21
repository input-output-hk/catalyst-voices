//! Implementation of the GET `/registration` endpoint

use poem_openapi::{payload::Json, ApiResponse};

use crate::{
    event_db::{cardano::chain_state::SlotNumber, error::NotFoundError},
    service::{
        common::{
            objects::cardano::{
                network::Network, registration_info::RegistrationInfo, stake_address::StakeAddress,
            },
            responses::WithErrorResponses,
        },
        utilities::check_network,
    },
    state::State,
};

/// Endpoint responses
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// The registration information for the stake address queried.
    #[oai(status = 200)]
    Ok(Json<RegistrationInfo>),
    /// No valid registration found for the provided stake address
    /// and provided slot number.
    #[oai(status = 404)]
    NotFound,
}

/// All responses
pub(crate) type AllResponses = WithErrorResponses<Responses>;

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
        Err(err) => return AllResponses::handle_error(&err),
    };

    // get the total utxo amount from the database
    match event_db
        .get_registration_info(stake_credential, network.into(), date_time)
        .await
    {
        Ok((tx_id, payment_address, voting_info, nonce)) => {
            Responses::Ok(Json(RegistrationInfo::new(
                tx_id,
                &payment_address,
                voting_info,
                nonce,
            )))
            .into()
        },
        Err(err) if err.is::<NotFoundError>() => Responses::NotFound.into(),
        Err(err) => AllResponses::handle_error(&err),
    }
}
