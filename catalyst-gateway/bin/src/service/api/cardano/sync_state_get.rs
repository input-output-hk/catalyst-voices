//! Implementation of the GET `/sync_state` endpoint

use poem_extensions::{
    response,
    UniResponse::{T200, T404},
};
use poem_openapi::payload::Json;

use crate::{
    event_db::error::NotFoundError,
    service::common::{
        objects::cardano::{network::Network, sync_state::SyncState},
        responses::{
            resp_2xx::OK,
            resp_4xx::{ApiValidationError, NotFound},
            resp_5xx::{server_error_response, ServerError, ServiceUnavailable},
        },
    },
    state::State,
};

/// # All Responses
pub(crate) type AllResponses = response! {
    200: OK<Json<SyncState>>,
    400: ApiValidationError,
    404: NotFound,
    500: ServerError,
    503: ServiceUnavailable,
};

/// # GET `/sync_state`
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(state: &State, network: Option<Network>) -> AllResponses {
    let event_db = state.event_db();

    let network = network.unwrap_or(Network::Mainnet);

    match event_db.last_updated_metadata(network.into()).await {
        Ok((slot_number, block_hash, last_updated)) => {
            T200(OK(Json(SyncState {
                slot_number,
                block_hash: block_hash.into(),
                last_updated,
            })))
        },
        Err(err) if err.is::<NotFoundError>() => T404(NotFound),
        Err(err) => server_error_response!("{err}"),
    }
}
