//! C509 OID provides an encoding and decoding of C509 Object Identifier (OID).
//!
//! Please refer to [RFC9090](https://datatracker.ietf.org/doc/rfc9090/) for OID encoding
//! Please refer to [CDDL Wrapping](https://datatracker.ietf.org/doc/html/rfc8610#section-3.7)
//! for unwrapped types.

use std::str::FromStr;

use anyhow::Result;
use asn1_rs::oid;
use minicbor::{data::Tag, decode, encode::Write, Decode, Decoder, Encode, Encoder};
use oid_registry::Oid;
use serde::{Deserialize, Deserializer, Serialize};

use crate::tables::IntegerToOidTable;

/// IANA Private Enterprise Number (PEN) OID prefix.
const PEN_PREFIX: Oid<'static> = oid!(1.3.6 .1 .4 .1);

/// Tag number representing IANA Private Enterprise Number (PEN) OID.
const OID_PEN_TAG: u64 = 112;

/// A strut of C509 OID with Registered Integer.
#[derive(Debug, Clone, PartialEq)]
pub struct C509oidRegistered {
    /// The `C509oid`.
    oid: C509oid,
    /// The registration table.
    registration_table: &'static IntegerToOidTable,
}

impl C509oidRegistered {
    /// Create a new instance of `C509oidRegistered`.
    pub(crate) fn new(oid: Oid<'static>, table: &'static IntegerToOidTable) -> Self {
        Self {
            oid: C509oid::new(oid),
            registration_table: table,
        }
    }

    /// Is PEN Encoding supported for this OID.
    /// Depends on each registration table.
    pub(crate) fn pen_encoded(mut self) -> Self {
        self.oid.pen_supported = true;
        self
    }

    /// Get the `C509oid`.
    pub(crate) fn get_c509_oid(&self) -> C509oid {
        self.oid.clone()
    }

    /// Get the registration table.
    pub(crate) fn get_table(&self) -> &'static IntegerToOidTable {
        self.registration_table
    }
}

// -----------------------------------------

/// A struct represent an instance of `C509oid`.
#[derive(Debug, PartialEq, Clone, Eq, Hash)]
pub struct C509oid {
    /// The OID.
    oid: Oid<'static>,
    /// The flag to indicate whether PEN encoding is supported.
    pen_supported: bool,
}

/// A helper struct for deserialize and serialize `C509oid`.
#[derive(Debug, Deserialize, Serialize)]
struct Helper {
    /// OID value in string.
    oid: String,
}

impl<'de> Deserialize<'de> for C509oid {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where D: Deserializer<'de> {
        let helper = Helper::deserialize(deserializer)?;
        let oid =
            Oid::from_str(&helper.oid).map_err(|e| serde::de::Error::custom(format!("{e:?}")))?;
        Ok(C509oid::new(oid))
    }
}

impl Serialize for C509oid {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where S: serde::Serializer {
        let helper = Helper {
            oid: self.oid.to_string(),
        };
        helper.serialize(serializer)
    }
}

impl C509oid {
    /// Create an new instance of `C509oid`.
    /// Default value of PEN flag is false
    #[must_use]
    pub fn new(oid: Oid<'static>) -> Self {
        Self {
            oid,
            pen_supported: false,
        }
    }

    /// Is PEN Encoding supported for this OID
    pub(crate) fn pen_encoded(mut self) -> Self {
        self.pen_supported = true;
        self
    }

    /// Get the underlying OID of the `C509oid`
    #[must_use]
    pub fn get_oid(self) -> Oid<'static> {
        self.oid.clone()
    }
}

impl Encode<()> for C509oid {
    /// Encode an OID
    /// If `pen_supported` flag is set, and OID start with a valid `PEN_PREFIX`,
    /// it is encoded as PEN (Private Enterprise Number)
    /// else encode as an unwrapped OID (~oid) - as bytes string without tag.
    ///
    /// # Returns
    ///
    /// A vector of bytes containing the CBOR encoded OID.
    /// If the encoding fails, it will return an error.
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, _ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        // Check if PEN encoding is supported and the OID starts with the PEN prefix.
        if self.pen_supported && self.oid.starts_with(&PEN_PREFIX) {
            // Set the CBOR tag.
            e.tag(Tag::new(OID_PEN_TAG))?;
            // Convert OID originally store as [u8] to [u64]
            // This process is necessary to get the correct OID
            // For example given - 1.3.6 .1 .4 .1.4.999
            // This OID will be stored as [u8] - [43, 6, 1, 4, 1, 4, 135, 103]
            // The first 2 integer has a special encoding formula where,
            // values is computed using X * 40 + Y (See RFC9090 for more info)
            // The number 999 exceed the 225 limit (max of u8), so it will be encoded as 2 bytes
            let raw_oid: Vec<u64> =
                self.oid
                    .iter()
                    .map(Iterator::collect)
                    .ok_or(minicbor::encode::Error::message(
                        "Failed to collect OID components from iterator",
                    ))?;
            let raw_pen_prefix: Vec<u64> = PEN_PREFIX.iter().map(Iterator::collect).ok_or(
                minicbor::encode::Error::message("Failed to collect OID components from iterator"),
            )?;
            // relative_oid is OID that follows PEN_PREFIX (relative to PEN_PREFIX)
            // Use the [u64] PEN prefix length to extract the relative OID
            let oid_slice =
                raw_oid
                    .get(raw_pen_prefix.len()..)
                    .ok_or(minicbor::encode::Error::message(
                        "Failed to get a OID slice",
                    ))?;
            let relative_oid = Oid::from_relative(oid_slice)
                .map_err(|_| minicbor::encode::Error::message("Failed to get a relative OID"))?;
            return e.bytes(relative_oid.as_bytes())?.ok();
        }
        let oid_bytes = self.oid.as_bytes();
        e.bytes(oid_bytes)?.ok()
    }
}

impl Decode<'_, ()> for C509oid {
    /// Decode an OID
    /// If the data to be decoded is a `Tag`, and the tag is an `OID_PEN_TAG`,
    /// then decode the OID as Private Enterprise Number (PEN) OID.
    /// else decode the OID as unwrapped OID (~oid) - as bytes string without tag.

    /// # Returns
    ///
    /// A C509oid instance.
    /// If the decoding fails, it will return an error.
    fn decode(d: &mut Decoder, _ctx: &mut ()) -> Result<Self, decode::Error> {
        if (minicbor::data::Type::Tag == d.datatype()?) && (Tag::new(OID_PEN_TAG) == d.tag()?) {
            let oid_bytes = d.bytes()?;
            // raw_oid contains the whole OID which stored in bytes
            let mut raw_oid = Vec::new();
            raw_oid.extend_from_slice(PEN_PREFIX.as_bytes());
            raw_oid.extend_from_slice(oid_bytes);
            // Convert the raw_oid to Oid
            let oid = Oid::new(raw_oid.into());
            return Ok(C509oid::new(oid).pen_encoded());
        }
        // Not a PEN Relative OID, so treat as a normal OID
        let oid_bytes = d.bytes()?;
        let oid = Oid::new(oid_bytes.to_owned().into());
        Ok(C509oid::new(oid))
    }
}

// -----------------------------------------

#[cfg(test)]
mod test_c509_oid {

    use super::*;

    // Test reference 3.1. Encoding of the SHA-256 OID
    // https://datatracker.ietf.org/doc/rfc9090/
    #[test]
    fn encode_decode_unwrapped() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        let oid = C509oid::new(oid!(2.16.840 .1 .101 .3 .4 .2 .1));
        oid.encode(&mut encoder, &mut ())
            .expect("Failed to encode OID");
        assert_eq!(hex::encode(buffer.clone()), "49608648016503040201");

        let mut decoder = Decoder::new(&buffer);
        let decoded_oid = C509oid::decode(&mut decoder, &mut ()).expect("Failed to decode OID");
        assert_eq!(decoded_oid, oid);
    }

    #[test]
    fn encode_decode_pen() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        let oid = C509oid::new(oid!(1.3.6 .1 .4 .1 .1 .1 .29)).pen_encoded();
        oid.encode(&mut encoder, &mut ())
            .expect("Failed to encode OID");
        assert_eq!(hex::encode(buffer.clone()), "d8704301011d");

        let mut decoder = Decoder::new(&buffer);
        let decoded_oid = C509oid::decode(&mut decoder, &mut ()).expect("Failed to decode OID");
        assert_eq!(decoded_oid, oid);
    }

    #[test]
    fn partial_equal() {
        let oid1 = C509oid::new(oid_registry::OID_HASH_SHA1);
        let oid2 = C509oid::new(oid!(1.3.14 .3 .2 .26));
        assert_eq!(oid1, oid2);
    }
}
