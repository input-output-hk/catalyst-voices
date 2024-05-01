//! Implementation of the GET `/sync_state` endpoint

use poem_openapi::{payload::Json, ApiResponse};

use crate::{
    event_db::error::NotFoundError,
    service::common::{
        objects::{
            cardano::{network::Network, sync_state::SyncState},
            server_error::ServerError,
        },
        responses::handle_5xx_response,
    },
    state::State,
};

/// # All Responses
#[derive(ApiResponse)]
pub(crate) enum AllResponses {
    /// Returns the sync state.
    #[oai(status = 200)]
    Ok(Json<SyncState>),
    /// Content not found.
    #[oai(status = 404)]
    NotFound,
    /// Internal Server Error.
    ///
    /// *The contents of this response should be reported to the projects issue tracker.*
    #[oai(status = 500)]
    ServerError(Json<ServerError>),
    /// Service is not ready, do not send other requests.
    #[oai(status = 503)]
    ServiceUnavailable,
}

/// # GET `/sync_state`
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(state: &State, network: Option<Network>) -> AllResponses {
    let event_db = state.event_db();

    let network = network.unwrap_or(Network::Mainnet);

    match event_db.last_updated_state(network.into()).await {
        Ok((slot_number, block_hash, last_updated)) => {
            AllResponses::Ok(Json(SyncState {
                slot_number,
                block_hash: block_hash.into(),
                last_updated,
            }))
        },
        Err(err) if err.is::<NotFoundError>() => AllResponses::NotFound,
        Err(err) => handle_5xx_response!(err),
    }
}
