//! Implementation of the GET `/utxo/staked_ada` endpoint

use chrono::{DateTime, Utc};
use poem_extensions::{
    response,
    UniResponse::{T200, T400, T404, T500, T503},
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
            resp_5xx::{server_error, ServerError, ServiceUnavailable},
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

/// # GET `/utxo/staked_ada`
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(
    state: &State, stake_address: StakeAddress, provided_network: Option<Network>,
    date_time: Option<DateTime<Utc>>,
) -> AllResponses {
    match state.event_db() {
        Ok(event_db) => {
            let date_time = date_time.unwrap_or_else(Utc::now);
            let stake_credential = stake_address.payload().as_hash().as_ref();

            // check the provided network type with the encoded inside the stake address
            let network = match stake_address.network() {
                pallas::ledger::addresses::Network::Mainnet => {
                    if let Some(network) = provided_network {
                        if !matches!(&network, Network::Mainnet) {
                            return T400(ApiValidationError::new(format!(
                                "Provided network type {} does not match stake address network type Mainnet",  network.to_json_string()
                            )));
                        }
                    }
                    Network::Mainnet
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
                            return T400(ApiValidationError::new(format!(
                                "Provided network type {} does not match stake address network type Testnet", network.to_json_string()
                            )));
                        }
                        network
                    } else {
                        Network::Testnet
                    }
                },
                pallas::ledger::addresses::Network::Other(x) => {
                    return T400(ApiValidationError::new(format!("Unknown network type {x}")));
                },
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
                Err(err) => T500(server_error!("{}", err.to_string())),
            }
        },
        Err(Error::EventDb(DBError::MismatchedSchema { was, expected })) => {
            tracing::error!(
                expected = expected,
                current = was,
                "DB schema version status mismatch"
            );
            state.set_schema_version_status(SchemaVersionStatus::Mismatch);
            T503(ServiceUnavailable)
        },
        Err(err) => T500(server_error!("{}", err.to_string())),
    }
}
