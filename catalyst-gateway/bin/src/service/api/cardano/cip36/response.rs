//! Cip36 Registration Query Endpoint Response
use poem_openapi::{payload::Json, ApiResponse, Object};

use crate::service::common;

/// Endpoint responses.
#[derive(ApiResponse)]
#[allow(dead_code)] // TODO: Remove once endpoint fully implemented
pub(crate) enum Cip36Registration {
    /// All CIP36 registrations associated with the same Voting Key.
    #[oai(status = 200)]
    Ok(Json<Cip36RegistrationList>),
    /// No valid registration.
    #[oai(status = 404)]
    NotFound,
}

/// All responses to a cip36 registration query
pub(crate) type AllRegistration = common::responses::WithErrorResponses<Cip36Registration>;

/// List of CIP36 Registration Data as found on-chain.
#[derive(Object)]
//#[oai(example = true)]
pub(crate) struct Cip36RegistrationList {
    /// The Slot the Registrations are valid up until.
    ///
    /// Any registrations that occurred after this Slot are not included in the list.
    /// Errors are reported only if they fall between the last valid registration and this
    /// slot number.
    /// Earlier errors are never reported.
    slot: common::types::cardano::slot_no::SlotNo,
    /// List of registrations associated with the query.
    #[oai(validator(max_items = "100"))]
    voting_key: Vec<Cip36RegistrationsForVotingPublicKey>,
    /// List of latest invalid registrations that were found, for the requested filter.
    #[oai(skip_serializing_if_is_empty, validator(max_items = "10"))]
    invalid: Vec<Cip36Details>,
    #[oai(flatten)]
    /// Current Page
    page: common::objects::generic::pagination::CurrentPage,
}

/// List of CIP36 Registration Data for a Voting Key.
#[derive(Object)]
//#[oai(example = true)]
pub(crate) struct Cip36RegistrationsForVotingPublicKey {
    /// Voting Public Key
    pub vote_pub_key: common::types::generic::ed25519_public_key::Ed25519HexEncodedPublicKey,
    /// List of stake addresses registered to the voting key
    #[oai(validator(max_items = "100"))]
    pub stake_address: Vec<Cip36RegistrationsForStakeAddress>,
}

/// List of CIP36 Registration Data for a Stake Address.
#[derive(Object)]
//#[oai(example = true)]
pub(crate) struct Cip36RegistrationsForStakeAddress {
    /// Stake Address registered to the voting key
    pub stake_addr: common::types::cardano::cip19_stake_address::Cip19StakeAddress,
    /// List of stake addresses registered to the voting key
    #[oai(validator(max_items = "100"))]
    pub registrations: Vec<Cip36Details>,
}

/// CIP36 Registration Data as found on-chain.
#[derive(Object)]
pub(crate) struct Cip36Details {
    /// Blocks Slot Number that the registration certificate is in.
    pub slot_no: common::types::cardano::slot_no::SlotNo,
    /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
    pub stake_pub_key:
        Option<common::types::generic::ed25519_public_key::Ed25519HexEncodedPublicKey>,
    /// Voting Public Key
    pub vote_pub_key:
        Option<common::types::generic::ed25519_public_key::Ed25519HexEncodedPublicKey>,

    /// Nonce value after normalization.
    #[oai(validator(minimum(value = "0"), maximum(value = "9223372036854775807")))]
    pub nonce: Option<u64>,
    /// Transaction Index.
    #[oai(validator(minimum(value = "0"), maximum(value = "32767")))]
    pub txn: Option<i16>,
    /// Cardano Cip-19 Formatted Shelley Payment Address.
    pub payment_address: Option<common::types::cardano::cip19_shelley_address::Cip19ShelleyAddress>,
    /// If the payment address is a script, then it can not be payed rewards.
    #[oai(default = "is_payable_default")]
    pub is_payable: bool,
    /// If this field is set, then the registration was in CIP15 format.
    #[oai(default = "cip15_default")]
    pub cip15: bool,
    /// If there are errors with this registration, they are listed here.
    /// This field is *NEVER* returned for a valid registration.
    #[oai(
        default = "Vec::<String>::new",
        skip_serializing_if_is_empty,
        validator(max_items = "10")
    )]
    pub errors: Vec<String>,
}

/// Is the payment address payable by catalyst.
fn is_payable_default() -> bool {
    true
}

/// Is the registration using CIP15 format.
fn cip15_default() -> bool {
    false
}
