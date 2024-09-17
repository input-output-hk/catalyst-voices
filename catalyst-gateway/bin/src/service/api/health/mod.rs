//! Health Endpoints
use poem_openapi::{param::Query, OpenApi};

use crate::service::common::tags::ApiTags;

mod inspection_get;
mod live_get;
mod ready_get;
mod started_get;
pub(crate) use started_get::started;

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
    async fn ready_get(&self) -> ready_get::AllResponses {
        ready_get::endpoint().await
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
    async fn live_get(&self) -> live_get::AllResponses {
        live_get::endpoint().await
    }

    #[oai(
        path = "/inspection",
        method = "get",
        operation_id = "healthInspection"
    )]
    /// Options for service inspection.
    async fn inspection(
        &self, log_level: Query<Option<inspection_get::LogLevel>>,
        query_inspection: Query<Option<inspection_get::DeepQueryInspectionFlag>>,
    ) -> inspection_get::AllResponses {
        inspection_get::endpoint(log_level.0, query_inspection.0).await
    }
}
