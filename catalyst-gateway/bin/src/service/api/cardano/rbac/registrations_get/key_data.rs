//! A role data key information.

use std::collections::HashMap;

use anyhow::Context;
use c509_certificate::c509::C509;
use cardano_blockchain_types::Point;
use chrono::{DateTime, Utc};
use ed25519_dalek::VerifyingKey;
use minicbor::{encode::Encode, Encoder};
use poem_openapi::{types::Example, Object};
use rbac_registration::{
    cardano::cip509::{KeyLocalRef, LocalRefInt, PointData},
    registration::cardano::RegistrationChain,
};
use x509_cert::{certificate::Certificate as X509Certificate, der::Encode as _};

use crate::service::{
    api::cardano::rbac::registrations_get::binary_data::HexEncodedBinaryData,
    common::types::generic::{
        boolean::BooleanFlag, date_time::DateTime as ServiceDateTime,
        ed25519_public_key::Ed25519HexEncodedPublicKey,
    },
};

/// A role data key information.
///
/// Only one of the `pub_key`, `x509_cert` and `c509_cert` fields can be present at the
/// same time.
#[derive(Object, Debug, Clone)]
#[oai(example)]
pub struct KeyData {
    /// Indicates if the data is persistent or volatile.
    is_persistent: BooleanFlag,
    /// A time when the address was added.
    time: ServiceDateTime,
    /// A hex encoded X509 certificate.
    x509_cert: Option<HexEncodedBinaryData>,
    /// A hex encoded C509 certificate.
    c509_cert: Option<HexEncodedBinaryData>,
    /// An ed25519 public key.
    pub_key: Option<Ed25519HexEncodedPublicKey>,
}

impl KeyData {
    /// Creates a new `KeyData` instance.
    pub fn new(
        is_persistent: bool, time: DateTime<Utc>, key_ref: Option<&KeyLocalRef>, point: &Point,
        chain: &RegistrationChain,
    ) -> anyhow::Result<Self> {
        let mut x509_cert = None;
        let mut c509_cert = None;
        let mut pub_key = None;

        if let Some(key_ref) = key_ref {
            match key_ref.local_ref {
                LocalRefInt::X509Certs => {
                    x509_cert = encode_x509(chain.x509_certs(), key_ref.key_offset, point)?;
                },
                LocalRefInt::C509Certs => {
                    c509_cert = encode_c509(chain.c509_certs(), key_ref.key_offset, point)?;
                },
                LocalRefInt::PubKeys => {
                    pub_key = convert_pub_key(chain.simple_keys(), key_ref.key_offset, point)?;
                },
            }
        }

        Ok(Self {
            is_persistent: is_persistent.into(),
            time: time.into(),
            pub_key,
            x509_cert,
            c509_cert,
        })
    }
}

impl Example for KeyData {
    fn example() -> Self {
        Self {
            is_persistent: BooleanFlag::example(),
            time: ServiceDateTime::example(),
            pub_key: Some(Ed25519HexEncodedPublicKey::example()),
            x509_cert: None,
            c509_cert: None,
        }
    }
}

/// Finds a X509 certificate with given offset and point and hex encodes it.
fn encode_x509(
    certs: &HashMap<usize, Vec<PointData<Option<X509Certificate>>>>, offset: usize, point: &Point,
) -> anyhow::Result<Option<HexEncodedBinaryData>> {
    certs
        .get(&offset)
        .with_context(|| format!("Invalid X509 certificate offset: {offset:?}"))?
        .iter()
        .find(|d| d.point() == point)
        .with_context(|| format!("Unable to find X509 certificate for the given point {point}"))?
        .data()
        .as_ref()
        .map(|cert| {
            cert.to_der()
                .context("Failed to encode X509 certificate")
                .map(Into::into)
        })
        .transpose()
}

/// Finds a C509 certificate with given offset and point and hex encodes it.
fn encode_c509(
    certs: &HashMap<usize, Vec<PointData<Option<C509>>>>, offset: usize, point: &Point,
) -> anyhow::Result<Option<HexEncodedBinaryData>> {
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
    keys: &HashMap<usize, Vec<PointData<Option<VerifyingKey>>>>, offset: usize, point: &Point,
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
