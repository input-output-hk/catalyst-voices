//! Implementation of the GET `/utxo/staked_ada` endpoint

use poem_extensions::{response, UniResponse::T503};

use crate::{
    service::common::responses::{
        resp_4xx::ApiValidationError,
        resp_5xx::{ServerError, ServiceUnavailable},
    },
    state::State,
};

/// # All Responses
pub(crate) type AllResponses = response! {
    400: ApiValidationError,
    500: ServerError,
    503: ServiceUnavailable,
};

/// # GET `/utxo/staked_ada`
/// 
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(_state: &State) -> AllResponses {
    // state.event_db();
    T503(ServiceUnavailable)
}
