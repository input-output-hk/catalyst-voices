//! This module contains common and re-usable responses with a 2xx response code.

use poem::IntoResponse;
use poem_extensions::OneResponse;
use poem_openapi::payload::Payload;

#[derive(OneResponse)]
#[oai(status = 200)]
/// ## OK, success status response code indicates that the request has succeeded
pub(crate) struct OK<T: IntoResponse + Payload>(pub(crate) T);

#[derive(OneResponse)]
#[oai(status = 204)]
/// ## NO CONTENT
///
/// The operation completed successfully, but there is no data to return.
///
/// #### NO DATA BODY IS RETURNED FOR THIS RESPONSE
pub(crate) struct NoContent;
