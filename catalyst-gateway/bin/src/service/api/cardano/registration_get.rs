//! Implementation of the GET `/registration` endpoint

use poem_openapi::{payload::Json, types::Example, ApiResponse};
use tracing::error;

use super::types::SlotNumber;
use crate::{
    db::index::session::CassandraSession,
    service::{
        common::{
            objects::cardano::{
                network::Network, registration_info::RegistrationInfo, stake_address::StakeAddress,
            },
            responses::WithErrorResponses,
        },
        utilities::check_network,
    },
};

/// Endpoint responses
#[derive(ApiResponse)]
#[allow(dead_code)]
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
#[allow(clippy::unused_async, clippy::no_effect_underscore_binding)]
pub(crate) async fn endpoint(
    stake_address: StakeAddress, provided_network: Option<Network>, slot_num: Option<SlotNumber>,
) -> AllResponses {
    let _date_time = slot_num.unwrap_or(SlotNumber::MAX);
    let _stake_credential = stake_address.payload().as_hash().to_vec();
    let _network = match check_network(stake_address.network(), provided_network) {
        Ok(network) => network,
        Err(err) => return AllResponses::handle_error(&err),
    };

    Responses::NotFound.into()
}

/// Get latest registration given a stake key hash or stake address
pub(crate) fn latest_registration(persistent: bool) -> AllResponses {
    let Some(_session) = CassandraSession::get(persistent) else {
        error!("Failed to acquire db session");
        return Responses::NotFound.into();
    };

    GetLatestRegistrationQuery::execute();

    let r = RegistrationInfo::example();

    Responses::Ok(Json(r)).into()
}
