//! Implement a response API type of CIP 36 registration info

use catalyst_types::problem_report::ProblemReport;
use poem_openapi::{
    registry::MetaSchema,
    types::{Example, ToJSON},
    Object,
};

use crate::service::common::{
    self,
    objects::generic::json_object::JSONObject,
    types::{
        array_types::impl_array_types,
        cardano::{
            cip19_address::Cip19Address, nonce::Nonce, slot_no::SlotNo, txn_index::TxnIndex,
        },
        generic::{boolean::BooleanFlag, ed25519_public_key::Ed25519HexEncodedPublicKey},
    },
};

/// CIP36 Registration Data as found on-chain.
#[derive(Object, Debug, Clone)]
#[oai(example = true)]
pub(crate) struct Cip36Details {
    /// Blocks Slot Number that the registration certificate is in.
    pub slot_no: SlotNo,
    /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
    #[oai(skip_serializing_if_is_none)]
    pub stake_pub_key: Option<Ed25519HexEncodedPublicKey>,
    /// Voting Public Key (Ed25519 Public key).
    #[oai(skip_serializing_if_is_none)]
    pub vote_pub_key: Option<Ed25519HexEncodedPublicKey>,
    /// A Catalyst corrected nonce, which is used during sorting of registrations.
    #[oai(skip_serializing_if_is_none)]
    pub nonce: Option<Nonce>,
    /// Raw nonce (nonce that has not had slot correction applied).
    /// Field 4 in the CIP-36 61284 Spec.
    #[oai(skip_serializing_if_is_none)]
    pub raw_nonce: Option<Nonce>,
    #[allow(clippy::missing_docs_in_private_items)] // Type is pre documented.
    #[oai(skip_serializing_if_is_none)]
    pub txn_index: Option<TxnIndex>,
    /// Cardano Cip-19 Formatted Shelley Payment Address.
    #[oai(skip_serializing_if_is_none)]
    pub payment_address: Option<Cip19Address>,
    /// If the payment address is a script, then it can not be payed rewards.
    #[oai(default)]
    pub is_payable: BooleanFlag,
    /// If this field is set, then the registration was in CIP15 format.
    #[oai(default)]
    pub cip15: BooleanFlag,
    /// If there are errors with this registration, they are listed here.
    /// This field is *NEVER* returned for a valid registration.
    #[oai(skip_serializing_if_is_none)]
    pub report: Option<JSONObject>,
}

// List of CIP-36 Registrations
impl_array_types!(
    Cip36List,
    Cip36Details,
    Some(MetaSchema {
        example: Self::example().to_json(),
        max_items: Some(100),
        items: Some(Box::new(Cip36Details::schema_ref())),
        ..poem_openapi::registry::MetaSchema::ANY
    })
);

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
            raw_nonce: Some(common::types::cardano::nonce::Nonce::example()),
            txn_index: Some(common::types::cardano::txn_index::TxnIndex::example()),
            payment_address: Some(common::types::cardano::cip19_address::Cip19Address::example()),
            is_payable: true.into(),
            cip15: false.into(),
            report: None,
        }
    }
}

impl Cip36Details {
    /// Example of an invalid registration
    #[allow(dead_code)]
    pub(crate) fn invalid_example() -> Self {
        let problem_report = ProblemReport::new("Cip36");
        problem_report.other("Error occurred", "Cip36 decoding error");
        let json_report = serde_json::to_value(&problem_report).unwrap_or_default();

        Self {
            slot_no: (common::types::cardano::slot_no::EXAMPLE + 135)
                .try_into()
                .unwrap_or_default(),
            stake_pub_key: None,
            vote_pub_key: Some(
                common::types::generic::ed25519_public_key::Ed25519HexEncodedPublicKey::example(),
            ),
            nonce: Some((common::types::cardano::nonce::EXAMPLE + 97).into()),
            raw_nonce: Some((common::types::cardano::nonce::EXAMPLE + 97).into()),
            txn_index: Some(common::types::cardano::txn_index::TxnIndex::example()),
            payment_address: None,
            is_payable: false.into(),
            cip15: true.into(),
            report: Some(json_report.into()),
        }
    }
}

impl Example for Cip36List {
    fn example() -> Self {
        Self(vec![Example::example()])
    }
}
