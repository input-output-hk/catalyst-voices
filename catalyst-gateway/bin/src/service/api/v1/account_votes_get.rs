//! Implementation of the `GET /v1/votes/plan/account-votes/:account_id` endpoint
//!
use crate::service::common::responses::resp_5xx::{ServerError, ServiceUnavailable};
use poem_extensions::response;

/// All responses
pub(crate) type AllResponses = response! {
    500: ServerError,
    503: ServiceUnavailable,
};
