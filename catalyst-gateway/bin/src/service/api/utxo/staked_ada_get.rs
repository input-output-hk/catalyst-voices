//! Implementation of the GET `/utxo/staked_ada` endpoint

use chrono::{DateTime, Utc};
use poem_extensions::{
    response,
    UniResponse::{T200, T500, T503},
};
use poem_openapi::{payload::Json, types::Example};

use crate::{
    cli::Error,
    event_db::error::Error as DBError,
    service::common::{
        objects::{
            cardano_address::CardanoStakeAddress, network::Network, stake_amount::StakeAmount,
        },
        responses::{
            resp_2xx::OK,
            resp_4xx::ApiValidationError,
            resp_5xx::{server_error, ServerError, ServiceUnavailable},
        },
    },
    state::{SchemaVersionStatus, State},
};

/// # All Responses
pub(crate) type AllResponses = response! {
    200: OK<Json<StakeAmount>>,
    400: ApiValidationError,
    500: ServerError,
    503: ServiceUnavailable,
};

/// # GET `/utxo/staked_ada`
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(
    state: &State, stake_address: CardanoStakeAddress, network: Option<Network>,
    date_time: Option<DateTime<Utc>>,
) -> AllResponses {
    tracing::info!(
        "stake_address: {:?}, network: {:?}, date_time: {:?}",
        stake_address,
        network,
        date_time
    );
    match state.event_db() {
        Ok(_event_db) => {
            // let _res = event_db
            //     .total_utxo_amount(&stake_credential, chrono::offset::Utc::now())
            //     .await;

            T200(OK(Json(StakeAmount::example())))
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
