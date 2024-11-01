//! Implementation of the GET `/registration` endpoint

use poem_openapi::{payload::Json, ApiResponse};

use super::types::SlotNumber;
use crate::service::{
    common::{
        objects::cardano::{network::Network, registration_info::RegistrationInfo},
        responses::WithErrorResponses,
        types::cardano::address::Cip19StakeAddress,
    },
    utilities::check_network,
};

/// Endpoint responses
#[derive(ApiResponse)]
#[allow(dead_code)]
pub(super) enum Responses {
    /// The registration information for the stake address queried.
    #[oai(status = 200)]
    Ok(Json<RegistrationInfo>),
    /// No valid registration found for the provided stake address
    /// and provided slot number.
    #[oai(status = 404)]
    NotFound,
}

/// All responses
pub(super) type AllResponses = WithErrorResponses<Responses>;

/// # GET `/registration`
#[allow(clippy::unused_async, clippy::no_effect_underscore_binding)]
pub(crate) async fn endpoint(
    stake_address: Cip19StakeAddress, provided_network: Option<Network>,
    slot_num: Option<SlotNumber>,
) -> AllResponses {
    let _date_time = slot_num.unwrap_or(SlotNumber::MAX);
    // TODO - handle appropriate response
    let Ok(address) = stake_address.to_stake_address() else {
        return Responses::NotFound.into();
    };
    let _stake_credential = address.payload().as_hash().to_vec();

    // If the network is not valid, just say NotFound.
    if let Ok(_network) = check_network(address.network(), provided_network) {
        let _unused = "
        // get the total utxo amount from the database
        match EventDB::get_registration_info(stake_credential, network.into(), date_time).await {
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
        ";
    }

    Responses::NotFound.into()
}
