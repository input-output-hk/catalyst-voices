//! Cip36 Registration Query Endpoint Response

mod cip36_reg;

pub(crate) use cip36_reg::Cip36Details;
use cip36_reg::Cip36List;
use derive_more::{From, Into};
use poem_openapi::{payload::Json, types::Example, ApiResponse, NewType, Object};

use crate::service::common::{
    self,
    types::{cardano::slot_no::SlotNo, generic::boolean::BooleanFlag},
};

// TODO: The examples of this response should be taken from representative data from a
// response generated on pre-prod.

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum Cip36Registration {
    /// All CIP36 registrations according to the request.
    #[oai(status = 200)]
    Ok(Json<Cip36RegistrationList>),
    /// Registrations not found.
    #[oai(status = 404)]
    NotFound,
    /// Response for unprocessable content.
    #[oai(status = 422)]
    UnprocessableContent(Json<Cip36RegistrationUnprocessableContent>),
}

/// All responses to a cip36 registration query
pub(crate) type AllRegistration = common::responses::WithErrorResponses<Cip36Registration>;

/// List of CIP36 Registration Data as found on-chain.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct Cip36RegistrationList {
    /// The Slot the Registrations are up to this specific slot.
    ///
    /// Any registrations that occurred after this Slot are not included in the list.
    /// If absent return the most recent registrations.
    #[oai(skip_serializing_if_is_none)]
    pub slot: Option<SlotNo>,
    /// Flag which identifies that resulted registrations are all valid or not
    pub is_valid: BooleanFlag,
    /// List of registrations that were found, for the requested filter from the finalized
    /// blockchain state.
    #[oai(skip_serializing_if_is_empty)]
    pub regs: Cip36List,
    /// Current Page
    #[oai(skip_serializing_if_is_none)]
    pub page: Option<Cip36RegistrationListPage>,
}

impl Example for Cip36RegistrationList {
    fn example() -> Self {
        Self {
            slot: Some(SlotNo::example()),
            is_valid: true.into(),
            regs: vec![Cip36Details::example()].into(),
            page: Some(Example::example()),
        }
    }
}

/// The Page of CIP-36 Registration List.
#[derive(NewType, From, Into)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
pub(crate) struct Cip36RegistrationListPage(common::objects::generic::pagination::CurrentPage);

impl Example for Cip36RegistrationListPage {
    fn example() -> Self {
        Self(Example::example())
    }
}

/// Cip36 Registration Validation Error.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct Cip36RegistrationUnprocessableContent {
    /// Error messages.
    error: common::types::generic::error_msg::ErrorMessage,
}

impl Cip36RegistrationUnprocessableContent {
    /// Create a new instance of `Cip36RegistrationUnprocessableContent`.
    pub(crate) fn new(error: &(impl ToString + ?Sized)) -> Self {
        Self {
            error: error.to_string().into(),
        }
    }
}

impl Example for Cip36RegistrationUnprocessableContent {
    fn example() -> Self {
        Self::new("Cip36 Registration in request body")
    }
}
