use poem_openapi::payload::Json;
use poem_openapi_derive::ApiResponse;

use crate::service::{
    api::cardano::rbac::registrations_get::{
        registration_chain::RbacRegistrationChain, unprocessable_content::RbacUnprocessableContent,
    },
    common::responses::WithErrorResponses,
};

/// An `/rbac/registrations` endpoint responses.
#[derive(ApiResponse)]
pub enum Responses {
    /// ## Ok
    ///
    /// Success returns a list of registration transaction ids.
    #[oai(status = 200)]
    Ok(Json<Box<RbacRegistrationChain>>),

    /// No valid registration.
    #[oai(status = 404)]
    NotFound,

    /// Response for unprocessable content.
    #[oai(status = 422)]
    UnprocessableContent(Json<RbacUnprocessableContent>),
}

pub type AllResponses = WithErrorResponses<Responses>;
