//! Health Endpoints
use poem_openapi::{param::Query, ApiResponse, OpenApi};
use tracing::error;

use crate::{
    db::index::{queries::rbac::get_chain_root::*, session::CassandraSession},
    service::common::{
        responses::WithErrorResponses,
        tags::ApiTags,
        types::{
            cardano::cip19_stake_address::Cip19StakeAddress, headers::retry_after::RetryAfterOption,
        },
    },
};

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// The test is success.
    #[oai(status = 204)]
    Passed,
    /// The test is success.
    #[oai(status = 500)]
    Failed,
}

impl From<bool> for AllResponses {
    fn from(value: bool) -> Self {
        if value {
            Responses::Passed.into()
        } else {
            Responses::Failed.into()
        }
    }
}

/// All responses.
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// Health API Endpoints
pub(crate) struct IndexDbTestApi;

#[OpenApi(tag = "ApiTags::Health")]
impl IndexDbTestApi {
    /// Test `quries/rbac/get_chain_root.rs`
    #[oai(
        path = "/v1/test/testGetChainRoot",
        method = "get",
        operation_id = "testGetChainRoot"
    )]
    async fn get_chain_root(&self, stake_address: Query<Cip19StakeAddress>) -> AllResponses {
        let Some(session) = CassandraSession::get(true) else {
            error!("Failed to acquire db session");
            let err = anyhow::anyhow!("Failed to acquire db session");
            return AllResponses::service_unavailable(&err, RetryAfterOption::Default);
        };

        let stake_address = stake_address.0.clone().as_bytes().to_vec();

        let query_res =
            GetChainRootQuery::execute(&session, GetChainRootQueryParams { stake_address }).await;

        query_res.is_ok().into()
    }
}
