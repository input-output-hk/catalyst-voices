//! This module contains common and re-usable responses with a 4xx response code.
//!

use poem::IntoResponse;
use poem_extensions::OneResponse;
use poem_openapi::payload::{Payload, PlainText};

#[derive(OneResponse)]
#[oai(status = 400)]
pub(crate) struct BadRequest<T: IntoResponse + Payload>(T);

#[derive(OneResponse)]
#[oai(status = 400)]
/// This error means that the request was malformed.
/// It has failed to pass validation, as specified by the OpenAPI schema.
pub(crate) struct ApiValidationError(PlainText<String>);

#[derive(OneResponse)]
#[oai(status = 401)]
pub(crate) struct Unauthorized;

#[derive(OneResponse)]
#[oai(status = 403)]
pub(crate) struct Forbidden;

#[derive(OneResponse)]
#[oai(status = 404)]
/// ## Content not found
pub(crate) struct NotFound;

#[derive(OneResponse)]
#[oai(status = 405)]
pub(crate) struct MethodNotAllowed;

#[derive(OneResponse)]
#[oai(status = 406)]
pub(crate) struct NotAcceptable;

#[derive(OneResponse)]
#[oai(status = 422)]
/// Common automatically produced validation error for every endpoint.
/// Is generated automatically when any of the OpenAPI validation rules fail.
/// Can also be generated manually.
pub(crate) struct ValidationError;
