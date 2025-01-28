//! Implementation of the GET `/sync_state` endpoint

use cardano_blockchain_types::Network;
use poem_openapi::{payload::Json, ApiResponse};

use crate::service::common::{
    objects::cardano::sync_state::SyncState, responses::WithErrorResponses,
};

/// Endpoint responses.
#[derive(ApiResponse)]
#[allow(dead_code)]
pub(crate) enum Responses {
    /// The synchronisation state of the blockchain with the catalyst gateway service.
    #[oai(status = 200)]
    Ok(Json<SyncState>),
    /// The network is unknown. Catalyst gateway is not syncing the queried network.
    #[oai(status = 404)]
    NotFound,
}

/// All responses.
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// # GET `/sync_state`
#[allow(clippy::unused_async, clippy::no_effect_underscore_binding)]
pub(crate) async fn endpoint(network: Option<Network>) -> AllResponses {
    let _network = network.unwrap_or(Network::Mainnet);

    let _unused = "
    match EventDB::last_updated_state(network.into()).await {
        Ok((slot_number, block_hash, last_updated)) => {
            Responses::Ok(Json(SyncState {
                slot_number,
                block_hash: block_hash.into(),
                last_updated,
            }))
            .into()
        },
        Err(err) if err.is::<NotFoundError>() => Responses::NotFound.into(),
        Err(err) => AllResponses::handle_error(&err),
    }
    ";

    Responses::NotFound.into()
}
