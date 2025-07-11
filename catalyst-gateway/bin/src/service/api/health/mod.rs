//! Health Endpoints
use poem_openapi::{param::Query, OpenApi};

use crate::service::common::{
    auth::{api_key::InternalApiKeyAuthorization, none::NoAuthorization},
    tags::ApiTags,
};

mod inspection_get;
pub(crate) mod live_get;
pub(crate) mod ready_get;
pub(crate) mod started_get;

/// Health API Endpoints
pub(crate) struct HealthApi;

#[OpenApi(tag = "ApiTags::Health")]
impl HealthApi {
    /// Service Started
    ///
    /// This endpoint is used to determine if the service has started properly
    /// and is able to serve requests.
    ///
    /// ## Note
    ///
    /// *This endpoint is for internal use of the service deployment infrastructure.
    /// It may not be exposed publicly.*
    #[oai(
        path = "/v1/health/started",
        method = "get",
        operation_id = "healthStarted"
    )]
    async fn started_get(&self, _auth: NoAuthorization) -> started_get::AllResponses {
        started_get::endpoint().await
    }

    /// Service Ready
    ///
    /// This endpoint is used to determine if the service is ready and able to serve
    /// requests.
    ///
    /// ## Note
    ///
    /// *This endpoint is for internal use of the service deployment infrastructure.
    /// It may not be exposed publicly.*
    #[oai(
        path = "/v1/health/ready",
        method = "get",
        operation_id = "healthReady"
    )]
    async fn ready_get(&self, _auth: NoAuthorization) -> ready_get::AllResponses {
        ready_get::endpoint().await
    }

    /// Service Live
    ///
    /// This endpoint is used to determine if the service is live.
    ///
    /// ## Note
    ///
    /// *This endpoint is for internal use of the service deployment infrastructure.
    /// It may not be exposed publicly. Refer to []*
    #[oai(path = "/v1/health/live", method = "get", operation_id = "healthLive")]
    async fn live_get(&self, _auth: NoAuthorization) -> live_get::AllResponses {
        live_get::endpoint().await
    }

    /// Service Inspection Control.
    ///
    /// This endpoint is used to control internal service inspection features.
    ///
    /// ## Note
    ///
    /// *This endpoint is for internal use of the service deployment infrastructure.
    /// It may not be exposed publicly.*
    // TODO: Make the parameters to this a JSON Body, not query parameters.
    #[oai(
        path = "/v1/health/inspection",
        method = "put",
        operation_id = "healthInspection",
        hidden = true
    )]
    async fn inspection(
        &self,
        /// The log level to use for the service.  Controls what detail gets logged.
        log_level: Query<Option<inspection_get::LogLevel>>,
        /// Enable or disable Verbose Query inspection in the logs.  Used to find query
        /// performance issues.
        query_inspection: Query<Option<inspection_get::DeepQueryInspectionFlag>>,
        _auth: InternalApiKeyAuthorization,
    ) -> inspection_get::AllResponses {
        inspection_get::endpoint(log_level.0, query_inspection.0).await
    }
}
