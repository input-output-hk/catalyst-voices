//! `v1` Endpoints

use std::sync::Arc;

use poem::web::{Data, Path};
use poem_openapi::OpenApi;

use crate::{
    service::common::{objects::account_votes::AccountId, tags::ApiTags},
    state::State,
};

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
    /// Votes for
    async fn get_account_votes(
        &self, state: Data<&Arc<State>>, account_id: Path<AccountId>,
    ) -> account_votes_get::AllResponses {
        account_votes_get::endpoint(state, account_id).await
    }
}
