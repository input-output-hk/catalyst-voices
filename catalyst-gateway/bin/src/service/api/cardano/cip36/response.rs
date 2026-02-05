//! Cip36 Registration Query Endpoint Response

use catalyst_types::problem_report::ProblemReport;
use derive_more::{From, Into};
use poem_openapi::{
    ApiResponse, NewType, Object,
    payload::Json,
    types::{Example, ToJSON},
};

use crate::service::common::{self, types::array_types::impl_array_types};

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
    pub voting_key: Cip36RegistrationsForVotingPublicKeyList,
    /// List of latest invalid registrations that were found, for the requested filter.
    #[oai(skip_serializing_if_is_empty)]
    pub invalid: common::types::cardano::registration_list::RegistrationCip36List,
    /// Current Page
    #[oai(skip_serializing_if_is_none)]
    pub page: Option<Cip36RegistrationListPage>,
}

impl Example for Cip36RegistrationList {
    fn example() -> Self {
        Self {
            slot: (common::types::cardano::slot_no::EXAMPLE + 635)
                .try_into()
                .unwrap_or_default(),
            voting_key: Example::example(),
            invalid: vec![Cip36Details::invalid_example()].into(),
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

// List of CIP-36 Registrations for voting public key
impl_array_types!(
    Cip36RegistrationsForVotingPublicKeyList,
    Cip36RegistrationsForVotingPublicKey,
    Some(poem_openapi::registry::MetaSchema {
        example: Self::example().to_json(),
        max_items: Some(100),
        items: Some(Box::new(Cip36RegistrationsForVotingPublicKey::schema_ref())),
        ..poem_openapi::registry::MetaSchema::ANY
    })
);

impl Example for Cip36RegistrationsForVotingPublicKeyList {
    fn example() -> Self {
        Self(vec![Example::example()])
    }
}

/// List of CIP36 Registration Data for a Voting Key.
#[derive(Object, Debug, Clone)]
#[oai(example = true)]
pub(crate) struct Cip36RegistrationsForVotingPublicKey {
    /// Voting Public Key
    pub vote_pub_key: common::types::generic::ed25519_public_key::Ed25519HexEncodedPublicKey,
    /// List of Registrations associated with this Voting Key
    pub registrations: common::types::cardano::registration_list::RegistrationCip36List,
}

impl Example for Cip36RegistrationsForVotingPublicKey {
    fn example() -> Self {
        Self {
            vote_pub_key: Example::example(),
            registrations: Example::example(),
        }
    }
}

/// CIP36 Registration Data as found on-chain.
#[derive(Object, Debug, Clone)]
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
    pub is_payable: common::types::generic::boolean::BooleanFlag,
    /// If this field is set, then the registration was in CIP15 format.
    pub cip15: common::types::generic::boolean::BooleanFlag,
    /// If there are errors with this registration, they are listed here.
    /// This field is *NEVER* returned for a valid registration.
    #[oai(skip_serializing_if_is_none)]
    pub errors: Option<common::objects::generic::problem_report::ProblemReport>,
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
            is_payable: true.into(),
            cip15: false.into(),
            errors: None,
        }
    }
}

impl Cip36Details {
    /// Example of an invalid registration
    fn invalid_example() -> Self {
        let problem_report = ProblemReport::new("Cip36");
        problem_report.other("Error occurred", "Cip36 decoding error");

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
            is_payable: false.into(),
            cip15: true.into(),
            errors: Some(
                common::objects::generic::problem_report::ProblemReport::from(&problem_report),
            ),
        }
    }
}
