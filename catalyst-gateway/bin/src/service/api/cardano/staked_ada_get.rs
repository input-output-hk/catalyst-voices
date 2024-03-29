//! Implementation of the GET `/utxo/staked_ada` endpoint

use chrono::{DateTime, Utc};
use poem_extensions::{
    response,
    UniResponse::{T200, T400, T404, T503},
};
use poem_openapi::{payload::Json, types::ToJSON};

use crate::{
    cli::Error,
    event_db::error::Error as DBError,
    service::common::{
        objects::cardano::{
            network::Network, stake_address::StakeAddress, stake_amount::StakeInfo,
        },
        responses::{
            resp_2xx::OK,
            resp_4xx::{ApiValidationError, NotFound},
            resp_5xx::{server_error_response, ServerError, ServiceUnavailable},
        },
    },
    state::{SchemaVersionStatus, State},
};

/// # All Responses
pub(crate) type AllResponses = response! {
    200: OK<Json<StakeInfo>>,
    400: ApiValidationError,
    404: NotFound,
    500: ServerError,
    503: ServiceUnavailable,
};

/// Check the provided network type with the encoded inside the stake address
fn check_network(
    address_network: pallas::ledger::addresses::Network, provided_network: Option<Network>,
) -> Result<Network, ApiValidationError> {
    match address_network {
        pallas::ledger::addresses::Network::Mainnet => {
            if let Some(network) = provided_network {
                if !matches!(&network, Network::Mainnet) {
                    return Err(ApiValidationError::new(format!(
                                "Provided network type {} does not match stake address network type Mainnet",  network.to_json_string()
                            )));
                }
            }
            Ok(Network::Mainnet)
        },
        pallas::ledger::addresses::Network::Testnet => {
            // the preprod and preview network types are encoded as `testnet` in the stake
            // address, so here we are checking if the `provided_network` type matches the
            // one, and if not - we return an error.
            // if the `provided_network` omitted - we return the `testnet` network type
            if let Some(network) = provided_network {
                if !matches!(
                    network,
                    Network::Testnet | Network::Preprod | Network::Preview
                ) {
                    return Err(ApiValidationError::new(format!(
                                "Provided network type {} does not match stake address network type Testnet", network.to_json_string()
                            )));
                }
                Ok(network)
            } else {
                Ok(Network::Testnet)
            }
        },
        pallas::ledger::addresses::Network::Other(x) => {
            Err(ApiValidationError::new(format!("Unknown network type {x}")))
        },
    }
}

/// # GET `/utxo/staked_ada`
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(
    state: &State, stake_address: StakeAddress, provided_network: Option<Network>,
    date_time: Option<DateTime<Utc>>,
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

    let date_time = date_time.unwrap_or_else(Utc::now);
    let stake_credential = stake_address.payload().as_hash().as_ref();

    let network = match check_network(stake_address.network(), provided_network) {
        Ok(network) => network,
        Err(err) => return T400(err),
    };

    // get the total utxo amount from the database
    match event_db
        .total_utxo_amount(stake_credential, network.into(), date_time)
        .await
    {
        Ok((amount, slot_number, block_time)) => {
            T200(OK(Json(StakeInfo {
                amount,
                slot_number,
                block_time,
            })))
        },
        Err(DBError::NotFound) => T404(NotFound),
        Err(err) => server_error_response!("{err}"),
    }
}
