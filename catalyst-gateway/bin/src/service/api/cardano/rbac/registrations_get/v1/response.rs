//! An `/rbac/registrations` V1 endpoint responses.

use poem_openapi::payload::Json;
use poem_openapi_derive::ApiResponse;

use crate::service::{
    api::cardano::rbac::registrations_get::{
        unprocessable_content::RbacUnprocessableContent,
        v1::registration_chain::RbacRegistrationChainV1,
    },
    common::responses::WithErrorResponses,
};

/// An `/rbac/registrations` V1 endpoint responses.
#[derive(ApiResponse)]
pub enum ResponsesV1 {
    /// ## Ok
    ///
    /// Success returns a list of registration transaction ids.
    #[oai(status = 200)]
    Ok(Json<Box<RbacRegistrationChainV1>>),

    /// No valid registration.
    #[oai(status = 404)]
    NotFound,

    /// Response for unprocessable content.
    #[oai(status = 422)]
    UnprocessableContent(Json<RbacUnprocessableContent>),
}

pub type AllResponsesV1 = WithErrorResponses<ResponsesV1>;
