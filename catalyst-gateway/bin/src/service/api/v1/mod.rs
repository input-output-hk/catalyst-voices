use crate::{service::common::tags::ApiTags, state::State};
use poem::web::{Data, Path};
use poem_openapi::OpenApi;
use std::sync::Arc;

mod account_votes_get;

/// V1 API Endpoints
pub(crate) struct V1Api;

#[OpenApi(prefix_path = "/v1", tag = "ApiTags::V1")]
impl V1Api {
    #[oai(
        path = "/votes/plan/account-votes/:account_id",
        method = "get",
        operation_id = "AccountVotes"
    )]
    async fn get_account_votes(
        &self,
        _state: Data<&Arc<State>>,
        _account_id: Path<String>,
    ) -> account_votes_get::AllResponses {
        todo!();
    }
}
