//! Implementation of the GET `/sync_state` endpoint

use poem_openapi::{payload::Json, ApiResponse};

use crate::{
    event_db::error::{NotFoundError, TimedOutError},
    service::common::{
        objects::cardano::{network::Network, sync_state::SyncState},
        responses::WithAllErrorResponse,
    },
    state::State,
};

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// The synchronisation state of the blockchain with the catalyst gateway service.
    #[oai(status = 200)]
    Ok(Json<SyncState>),
    /// The network is unknown. Catalyst gateway is not syncing the queried network.
    #[oai(status = 404)]
    NotFound,
}

/// All responses.
pub(crate) type AllResponses = WithAllErrorResponse<Responses>;

/// # GET `/sync_state`
pub(crate) async fn endpoint(state: &State, network: Option<Network>) -> AllResponses {
    let event_db = state.event_db();

    let network = network.unwrap_or(Network::Mainnet);

    match event_db.last_updated_state(network.into()).await {
        Ok((slot_number, block_hash, last_updated)) => {
            Responses::Ok(Json(SyncState {
                slot_number,
                block_hash: block_hash.into(),
                last_updated,
            }))
            .into()
        },
        Err(err) if err.is::<NotFoundError>() => Responses::NotFound.into(),
        Err(err) if err.is::<TimedOutError>() => AllResponses::service_unavailable(),
        Err(err) => AllResponses::internal_server_error(&err),
    }
}
