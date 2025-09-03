//! A role data key information.

use std::collections::HashMap;

use anyhow::Context;
use c509_certificate::c509::C509;
use cardano_chain_follower::Point;
use ed25519_dalek::VerifyingKey;
use minicbor::{encode::Encode, Encoder};
use poem_openapi::{types::Example, Object};
use rbac_registration::{
    cardano::cip509::{KeyLocalRef, LocalRefInt, PointData},
    registration::cardano::RegistrationChain,
};
use x509_cert::certificate::Certificate as X509Certificate;

use crate::service::{
    api::cardano::rbac::registrations_get::{
        key_type::{KeyType, KeyTypeWrapper},
        pem::Pem,
        v2::{c509::HexEncodedC509, key_value::KeyValue},
    },
    common::types::{
        cardano::{slot_no::SlotNo, txn_index::TxnIndex},
        generic::{
            boolean::BooleanFlag, date_time::DateTime,
            ed25519_public_key::Ed25519HexEncodedPublicKey,
        },
    },
};

/// A role data key information.
#[derive(Object, Debug, Clone)]
#[oai(example)]
pub struct KeyData {
    /// Indicates if the data is persistent or volatile.
    is_persistent: BooleanFlag,
    /// A time when the data was added.
    time: DateTime,
    /// A block slot number.
    slot: SlotNo,
    /// A transaction index.
    txn_index: TxnIndex,
    /// A type of the key.
    key_type: KeyTypeWrapper,
    /// A value of the key.
    ///
    /// The key was deleted if this field is absent or nil.
    key_value: Option<KeyValue>,
}

impl KeyData {
    /// Creates a new `KeyData` instance.
    pub fn new(
        is_persistent: bool,
        time: DateTime,
        slot: SlotNo,
        txn_index: TxnIndex,
        key_ref: &KeyLocalRef,
        point: &Point,
        chain: &RegistrationChain,
    ) -> anyhow::Result<Self> {
        let key_type;
        let key_value = match key_ref.local_ref {
            LocalRefInt::X509Certs => {
                key_type = KeyTypeWrapper(KeyType::X509);
                encode_x509(chain.x509_certs(), key_ref.key_offset, point)?.map(Into::into)
            },
            LocalRefInt::C509Certs => {
                key_type = KeyTypeWrapper(KeyType::C509);
                encode_c509(chain.c509_certs(), key_ref.key_offset, point)?.map(Into::into)
            },
            LocalRefInt::PubKeys => {
                key_type = KeyTypeWrapper(KeyType::Pubkey);
                convert_pub_key(chain.simple_keys(), key_ref.key_offset, point)?.map(Into::into)
            },
        };

        Ok(Self {
            is_persistent: is_persistent.into(),
            time,
            slot,
            txn_index,
            key_type,
            key_value,
        })
    }
}

impl Example for KeyData {
    fn example() -> Self {
        Self {
            is_persistent: BooleanFlag::example(),
            time: DateTime::example(),
            slot: SlotNo::example(),
            txn_index: TxnIndex::example(),
            key_type: KeyTypeWrapper::example(),
            key_value: Some(KeyValue::example()),
        }
    }
}

/// Finds a X509 certificate with given offset and point and hex encodes it.
fn encode_x509(
    certs: &HashMap<usize, Vec<PointData<Option<X509Certificate>>>>,
    offset: usize,
    point: &Point,
) -> anyhow::Result<Option<Pem>> {
    certs
        .get(&offset)
        .with_context(|| format!("Invalid X509 certificate offset: {offset:?}"))?
        .iter()
        .find(|d| d.point() == point)
        .with_context(|| format!("Unable to find X509 certificate for the given point {point}"))?
        .data()
        .as_ref()
        .map(TryInto::try_into)
        .transpose()
}

/// Finds a C509 certificate with given offset and point and hex encodes it.
fn encode_c509(
    certs: &HashMap<usize, Vec<PointData<Option<C509>>>>,
    offset: usize,
    point: &Point,
) -> anyhow::Result<Option<HexEncodedC509>> {
    certs
        .get(&offset)
        .with_context(|| format!("Invalid C509 certificate offset: {offset:?}"))?
        .iter()
        .find(|d| d.point() == point)
        .with_context(|| format!("Unable to find C509 certificate for the given point {point}"))?
        .data()
        .as_ref()
        .map(|cert| {
            let mut buffer = Vec::new();
            let mut e = Encoder::new(&mut buffer);
            cert.encode(&mut e, &mut ())
                .ok()
                .map(|()| buffer.into())
                .context("Failed to encode C509 certificate")
        })
        .transpose()
}

/// Finds a public key with the given offset and point and converts it.
fn convert_pub_key(
    keys: &HashMap<usize, Vec<PointData<Option<VerifyingKey>>>>,
    offset: usize,
    point: &Point,
) -> anyhow::Result<Option<Ed25519HexEncodedPublicKey>> {
    Ok(keys
        .get(&offset)
        .with_context(|| format!("Invalid pub key offset: {offset}"))?
        .iter()
        .find(|d| d.point() == point)
        .with_context(|| format!("Unable to find pub key for the given point {point}"))?
        .data()
        .map(Into::into))
}
