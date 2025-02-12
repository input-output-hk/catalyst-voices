//! Cip36 Registration Query Endpoint Response
use poem_openapi::{payload::Json, types::Example, ApiResponse, Object};

use crate::service::common;

// ToDo: The examples of this response should be taken from representative data from a
// response generated on pre-prod.

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum Cip36Registration {
    /// All CIP36 registrations associated with the same Voting Key.
    #[oai(status = 200)]
    Ok(Json<Cip36RegistrationList>),
    /// No valid registration.
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
    /// The Slot the Registrations are valid up until.
    ///
    /// Any registrations that occurred after this Slot are not included in the list.
    /// Errors are reported only if they fall between the last valid registration and this
    /// slot number.
    /// Earlier errors are never reported.
    pub slot: common::types::cardano::slot_no::SlotNo,
    /// List of registrations associated with the query.
    #[oai(validator(max_items = "100"))]
    pub voting_key: Vec<Cip36RegistrationsForVotingPublicKey>,
    /// List of latest invalid registrations that were found, for the requested filter.
    #[oai(skip_serializing_if_is_empty, validator(max_items = "10"))]
    pub invalid: Vec<Cip36Details>,
    /// Current Page
    #[oai(skip_serializing_if_is_none)]
    pub page: Option<common::objects::generic::pagination::CurrentPage>,
}

impl Example for Cip36RegistrationList {
    fn example() -> Self {
        Self {
            slot: (common::types::cardano::slot_no::EXAMPLE + 635)
                .try_into()
                .unwrap_or_default(),
            voting_key: vec![Cip36RegistrationsForVotingPublicKey::example()],
            invalid: vec![Cip36Details::invalid_example()],
            page: Some(common::objects::generic::pagination::CurrentPage::example()),
        }
    }
}

/// List of CIP36 Registration Data for a Voting Key.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct Cip36RegistrationsForVotingPublicKey {
    /// Voting Public Key
    pub vote_pub_key: common::types::generic::ed25519_public_key::Ed25519HexEncodedPublicKey,
    /// List of Registrations associated with this Voting Key
    #[oai(validator(max_items = "100"))]
    pub registrations: Vec<Cip36Details>,
}

impl Example for Cip36RegistrationsForVotingPublicKey {
    fn example() -> Self {
        Cip36RegistrationsForVotingPublicKey {
            vote_pub_key:
                common::types::generic::ed25519_public_key::Ed25519HexEncodedPublicKey::example(),
            registrations: vec![Cip36Details::example()],
        }
    }
}

/// CIP36 Registration Data as found on-chain.
#[derive(Object, Clone)]
#[oai(example = true)]
pub(crate) struct Cip36Details {
    /// Blocks Slot Number that the registration certificate is in.
    pub slot_no: common::types::cardano::slot_no::SlotNo,
    /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
    #[oai(skip_serializing_if_is_none)]
    pub stake_pub_key:
        Option<common::types::generic::ed25519_public_key::Ed25519HexEncodedPublicKey>,
    /// Voting Public Key (Ed25519 Public key).
    #[oai(skip_serializing_if_is_none)]
    pub vote_pub_key:
        Option<common::types::generic::ed25519_public_key::Ed25519HexEncodedPublicKey>,
    #[allow(clippy::missing_docs_in_private_items)] // Type is pre documented.
    #[oai(skip_serializing_if_is_none)]
    pub nonce: Option<common::types::cardano::nonce::Nonce>,
    #[allow(clippy::missing_docs_in_private_items)] // Type is pre documented.
    #[oai(skip_serializing_if_is_none)]
    pub txn: Option<common::types::cardano::txn_index::TxnIndex>,
    /// Cardano Cip-19 Formatted Shelley Payment Address.
    #[oai(skip_serializing_if_is_none)]
    pub payment_address: Option<common::types::cardano::cip19_shelley_address::Cip19ShelleyAddress>,
    /// If the payment address is a script, then it can not be payed rewards.
    #[oai(default = "common::types::cardano::boolean::IsPayable::default")]
    pub is_payable: common::types::cardano::boolean::IsPayable,
    /// If this field is set, then the registration was in CIP15 format.
    #[oai(default = "common::types::cardano::boolean::IsCip15::default")]
    pub cip15: common::types::cardano::boolean::IsCip15,
    /// If there are errors with this registration, they are listed here.
    /// This field is *NEVER* returned for a valid registration.
    #[oai(
        default = "Vec::<common::types::generic::error_msg::ErrorMessage>::new",
        skip_serializing_if_is_empty,
        validator(max_items = "10")
    )]
    pub errors: Vec<common::types::generic::error_msg::ErrorMessage>,
}

impl Example for Cip36Details {
    /// Example of a valid registration
    fn example() -> Self {
        Self {
            slot_no: common::types::cardano::slot_no::SlotNo::example(),
            stake_pub_key: Some(
                common::types::generic::ed25519_public_key::Ed25519HexEncodedPublicKey::examples(0),
            ),
            vote_pub_key: Some(
                common::types::generic::ed25519_public_key::Ed25519HexEncodedPublicKey::example(),
            ),
            nonce: Some(common::types::cardano::nonce::Nonce::example()),
            txn: Some(common::types::cardano::txn_index::TxnIndex::example()),
            payment_address: Some(
                common::types::cardano::cip19_shelley_address::Cip19ShelleyAddress::example(),
            ),
            is_payable: common::types::cardano::boolean::IsPayable::example(),
            cip15: common::types::cardano::boolean::IsCip15::example(),
            errors: Vec::<common::types::generic::error_msg::ErrorMessage>::new(),
        }
    }
}

impl Cip36Details {
    /// Example of an invalid registration
    fn invalid_example() -> Self {
        Self {
            slot_no: (common::types::cardano::slot_no::EXAMPLE + 135)
                .try_into()
                .unwrap_or_default(),
            stake_pub_key: None,
            vote_pub_key: Some(
                common::types::generic::ed25519_public_key::Ed25519HexEncodedPublicKey::example(),
            ),
            nonce: Some((common::types::cardano::nonce::EXAMPLE + 97).into()),
            txn: Some(common::types::cardano::txn_index::TxnIndex::example()),
            payment_address: None,
            is_payable: common::types::cardano::boolean::IsPayable::example(),
            cip15: common::types::cardano::boolean::IsCip15::example(),
            errors: vec!["Stake Public Key is required".into()],
        }
    }
}

/// Cip36 Registration Validation Error.
#[derive(Object, Default)]
#[oai(example = true)]
pub(crate) struct Cip36RegistrationUnprocessableContent {
    /// Error messages.
    #[oai(validator(max_length = "100", pattern = "^[0-9a-zA-Z].*$"))]
    error: String,
}

impl Cip36RegistrationUnprocessableContent {
    /// Create a new instance of `Cip36RegistrationUnprocessableContent`.
    pub(crate) fn new(error: &(impl ToString + ?Sized)) -> Self {
        Self {
            error: error.to_string(),
        }
    }
}

impl Example for Cip36RegistrationUnprocessableContent {
    fn example() -> Self {
        Cip36RegistrationUnprocessableContent::new("Cip36 Registration in request body")
    }
}
