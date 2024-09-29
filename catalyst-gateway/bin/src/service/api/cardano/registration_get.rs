//! Implementation of the GET `/registration` endpoint

use futures::StreamExt;
use poem_openapi::{payload::Json, types::Example, ApiResponse};
use tracing::{error, info};

use super::types::SlotNumber;
use crate::{
    db::index::{
        queries::registrations::get_latest_registration_w_stake_addr::{
            GetLatestRegistrationParams, GetLatestRegistrationQuery,
        },
        session::CassandraSession,
    },
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
pub(crate) async fn latest_registration(persistent: bool) -> AllResponses {
    let Some(session) = CassandraSession::get(persistent) else {
        error!("Failed to acquire db session");
        return Responses::NotFound.into();
    };

    info!("here!!!!!!");

    let stake_addr =
        match hex::decode("76e7ac0e460b6cdecea4be70479dab13c4adbd117421259a9b36caac007394de") {
            Ok(k) => k,
            Err(_err) => return Responses::NotFound.into(),
        };

    let mut registrations_iter = match GetLatestRegistrationQuery::execute(
        &session,
        GetLatestRegistrationParams::new(stake_addr),
    )
    .await
    {
        Ok(latest) => latest,
        Err(err) => {
            error!("Failed to get latest registration {:?}", err);
            return Responses::NotFound.into();
        },
    };

    while let Some(row_res) = registrations_iter.next().await {
        info!("made!");
        let row = match row_res {
            Ok(r) => r,
            Err(err) => {
                error!("Failed to get latest registration {:?}", err);
                return Responses::NotFound.into();
            },
        };

        info!("are! {:?}", row.stake_address);
    }

    let r = RegistrationInfo::example();

    Responses::Ok(Json(r)).into()
}
