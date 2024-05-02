//! Implementation of the GET `/sync_state` endpoint

use poem_openapi::{payload::Json, ApiResponse};

use crate::{
    event_db::error::NotFoundError,
    service::common::{
        objects::cardano::{network::Network, sync_state::SyncState},
        responses::WithErrorResponses,
    },
    state::State,
};

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// Returns the sync state.
    #[oai(status = 200)]
    Ok(Json<SyncState>),
    /// Cardano chain follower was not syncing for the provided network.
    #[oai(status = 404)]
    NotFound,
}

/// All responses.
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// # GET `/sync_state`
#[allow(clippy::unused_async)]
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
        Err(err) => AllResponses::handle_5xx_response(&err),
    }
}
