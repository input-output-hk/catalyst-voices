//! Implementation of the GET `/registration` endpoint

use poem_extensions::{
    response,
    UniResponse::{T200, T400, T404, T503},
};
use poem_openapi::{payload::Json, types::Example};

use crate::{
    cli::Error,
    event_db::{error::Error as DBError, follower::SlotNumber},
    service::{
        common::{
            objects::cardano::{
                network::Network, registration_info::RegistrationInfo, stake_address::StakeAddress,
            },
            responses::{
                resp_2xx::OK,
                resp_4xx::{ApiValidationError, NotFound},
                resp_5xx::{server_error_response, ServerError, ServiceUnavailable},
            },
        },
        utilities::check_network,
    },
    state::{SchemaVersionStatus, State},
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
    let event_db = match state.event_db() {
        Ok(event_db) => event_db,
        Err(Error::EventDb(DBError::MismatchedSchema { was, expected })) => {
            tracing::error!(
                expected = expected,
                current = was,
                "DB schema version status mismatch"
            );
            state.set_schema_version_status(SchemaVersionStatus::Mismatch);
            return T503(ServiceUnavailable);
        },
        Err(err) => return server_error_response!("{err}"),
    };
    let date_time = slot_num.unwrap_or(SlotNumber::MAX);
    let stake_credential = stake_address.payload().as_hash().as_ref();
    let network = match check_network(stake_address.network(), provided_network) {
        Ok(network) => network,
        Err(err) => return T400(err),
    };

    // get the total utxo amount from the database
    match event_db
        .get_registration_info(stake_credential, network.into(), date_time)
        .await
    {
        Ok(()) => T200(OK(Json(RegistrationInfo::example()))),
        Err(DBError::NotFound) => T404(NotFound),
        Err(err) => server_error_response!("{err}"),
    }
}
