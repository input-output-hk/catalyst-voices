//! Health Endpoints
use std::sync::Arc;

use poem::web::Data;
use poem_openapi::OpenApi;

use crate::{service::common::tags::ApiTags, state::State};

mod live_get;
mod ready_get;
mod started_get;

/// Health API Endpoints
pub(crate) struct HealthApi;

#[OpenApi(prefix_path = "/health", tag = "ApiTags::Health")]
impl HealthApi {
    #[oai(path = "/started", method = "get", operation_id = "healthStarted")]
    /// Service Started
    ///
    /// This endpoint is used to determine if the service has started properly
    /// and is able to serve requests.
    ///
    /// ## Note
    ///
    /// *This endpoint is for internal use of the service deployment infrastructure.
    /// It may not be exposed publicly.*
    ///
    /// ## Responses
    ///
    /// * 204 No Content - Service is Started and can serve requests.
    /// * 500 Server Error - If anything within this function fails unexpectedly.
    /// * 503 Service Unavailable - Service has not started, do not send other requests
    ///   yet.
    async fn started_get(&self) -> started_get::AllResponses {
        started_get::endpoint().await
    }

    #[oai(path = "/ready", method = "get", operation_id = "healthReady")]
    /// Service Ready
    ///
    /// This endpoint is used to determine if the service is ready and able to serve
    /// requests.
    ///
    /// ## Note
    ///
    /// *This endpoint is for internal use of the service deployment infrastructure.
    /// It may not be exposed publicly.*
    ///
    /// ## Responses
    ///
    /// * 204 No Content - Service is Ready and can serve requests.
    /// * 500 Server Error - If anything within this function fails unexpectedly.
    /// * 503 Service Unavailable - Service is not ready, requests to other
    /// endpoints should not be sent until the service becomes ready.
    async fn ready_get(&self, state: Data<&Arc<State>>) -> ready_get::AllResponses {
        ready_get::endpoint(state).await
    }

    #[oai(path = "/live", method = "get", operation_id = "healthLive")]
    /// Service Live
    ///
    /// This endpoint is used to determine if the service is live.
    ///
    /// ## Note
    ///
    /// *This endpoint is for internal use of the service deployment infrastructure.
    /// It may not be exposed publicly. Refer to []*
    ///
    /// ## Responses
    ///
    /// * 204 No Content - Service is OK and can keep running.
    /// * 500 Server Error - If anything within this function fails unexpectedly.
    ///   (Possible but unlikely)
    /// * 503 Service Unavailable - Service is possibly not running reliably.
    async fn live_get(&self) -> live_get::AllResponses {
        live_get::endpoint().await
    }
}
