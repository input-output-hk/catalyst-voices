//! Cardano UTXO endpoints

use std::sync::Arc;

use chrono::{DateTime, Utc};
use poem::web::Data;
use poem_openapi::{
    param::{Path, Query},
    OpenApi,
};

use crate::{
    service::{
        common::{objects::network::Network, tags::ApiTags},
        utilities::middleware::schema_validation::schema_version_validation,
    },
    state::State,
};

mod staked_ada_get;

/// Cardano UTXO API Endpoints
pub(crate) struct UTXOApi;

#[OpenApi(prefix_path = "/utxo", tag = "ApiTags::Utxo")]
impl UTXOApi {
    #[oai(
        path = "/staked_ada/:stake_address",
        method = "get",
        operation_id = "stakedAdaAmountGet",
        transform = "schema_version_validation"
    )]
    /// Get staked ada amount.
    ///
    /// This endpoint returns the total Cardano's staked ada amount to the corresponded
    /// user's stake address.
    ///
    /// ## Responses
    /// * 200
    /// * 400 Bad Request.
    /// * 500 Server Error - If anything within this function fails unexpectedly.
    /// * 503 Service Unavailable - Service is not ready, requests to other
    /// endpoints should not be sent until the service becomes ready.
    async fn staked_ada_get(
        &self, data: Data<&Arc<State>>,
        /// The stake address of the user.
        /// Should a valid Bech32 encoded address followed by the https://cips.cardano.org/cip/CIP-19/#stake-addresses.
        stake_address: Path<String>,
        /// Cardano network type.
        network: Query<Option<Network>>,
        /// Date time.
        date_time: Query<Option<DateTime<Utc>>>,
    ) -> staked_ada_get::AllResponses {
        tracing::info!(
            "GET /utxo/staked_ada/:stake_address, stake_address: {}, network: {:?}, date_time: {:?}",
            stake_address.0,
            network.0,
            date_time.0
        );
        staked_ada_get::endpoint(&data, stake_address.0, network.0, date_time.0).await
    }
}
