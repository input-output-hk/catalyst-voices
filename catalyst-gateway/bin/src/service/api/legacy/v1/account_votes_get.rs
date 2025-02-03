//! Implementation of the `GET /v1/votes/plan/account-votes/:account_id` endpoint
use anyhow::anyhow;
use poem_openapi::{param::Path, payload::Json, ApiResponse};

use crate::service::common::{
    objects::legacy::account_votes::{AccountId, AccountVotesVec},
    responses::WithErrorResponses,
};

/// Endpoint responses
#[derive(ApiResponse)]
#[allow(dead_code)]
pub(crate) enum Responses {
    /// ## Ok
    /// 
    /// JSON array of the number of voted proposals in a plan.
    #[oai(status = 200)]
    Ok(Json<AccountVotesVec>),
}

/// All responses
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// GET /v1/votes/plans/account-votes/:account_id
///
/// Get votes for an `account_id` endpoint.
///
/// For each active vote plan, this endpoint returns an array
/// with the proposal index number that the account voted for.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(_account_id: Path<AccountId>) -> AllResponses {
    let err = anyhow!("Not implemented");
    AllResponses::internal_error(&err)
}
