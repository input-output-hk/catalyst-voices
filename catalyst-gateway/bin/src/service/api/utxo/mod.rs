//! Cardano UTXO endpoints

use std::sync::Arc;

use poem::web::Data;
use poem_openapi::OpenApi;

use crate::{
    service::{
        common::tags::ApiTags, utilities::middleware::schema_validation::schema_version_validation,
    },
    state::State,
};

mod staked_ada_get;

/// Cardano UTXO API Endpoints
pub(crate) struct UTXOApi;

#[OpenApi(prefix_path = "/utxo", tag = "ApiTags::Utxo")]
impl UTXOApi {
    #[oai(
        path = "/staked_ada",
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
    async fn staked_ada_get(&self, data: Data<&Arc<State>>) -> staked_ada_get::AllResponses {
        staked_ada_get::endpoint(&data).await
    }
}
