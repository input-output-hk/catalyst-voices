//! This module provides an encoding and decoding of C509 Object Identifier (OID).
//! Please refer to [RFC9090](https://datatracker.ietf.org/doc/rfc9090/) for OID encoding
//! Please refer to [CDDL Wrapping](https://datatracker.ietf.org/doc/html/rfc8610#section-3.7) for unwrapped types.

use asn1_rs::FromDer;
use minicbor::{
    decode,
    encode::{self, Write},
    Decode, Decoder, Encode, Encoder,
};
use oid_registry::Oid;

/// Represent an instance of C509 OID where it contains an oid.
#[allow(dead_code)]
#[derive(Debug, PartialEq)]
pub struct C509oid<'a> {
    oid: Oid<'a>,
}

/// Tag representing DER OID.
const DER_OID_TAG: u8 = 0x06;

#[allow(dead_code)]
impl<'a> C509oid<'a> {
    /// Create an new instance of C509oid.
    pub fn new(oid: Oid<'a>) -> Self {
        C509oid { oid }
    }
}

impl<C> Encode<C> for C509oid<'_> {
    /// Encode an unwrapped OID (as bytes string without tag).
    /// ~oid indicates a unwrapped OID.
    ///
    /// # Returns
    ///
    /// A vector of bytes containing the CBOR encoded unwrapped OID.
    /// If the encoding fails, it will return an error.
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, _ctx: &mut C,
    ) -> Result<(), encode::Error<W::Error>> {
        let oid_bytes: &[u8] = self.oid.as_bytes();
        e.bytes(oid_bytes)?.ok()
    }
}

impl<'b, C> Decode<'b, C> for C509oid<'_> {
    /// Decode an unwrapped OID.
    ///
    /// # Returns
    ///
    /// A C509oid instance containing the decoded OID.
    /// If the decoding fails, it will return an error.
    fn decode(d: &mut Decoder<'b>, _ctx: &mut C) -> Result<Self, decode::Error> {
        let oid_bytes = d.bytes()?;
        // Time Length Value (TLV) format.
        let mut der_bytes = vec![DER_OID_TAG, oid_bytes.len() as u8];
        der_bytes.extend_from_slice(oid_bytes);
        let oid = Oid::from_der(&der_bytes).map_err(|e| decode::Error::message(e.to_string()))?;
        Ok(C509oid::new(oid.1.to_owned()))
    }
}

#[cfg(test)]
mod test_c509_oid {
    use asn1_rs::oid;
    use minicbor::{Decoder, Encoder};

    use crate::c509_oid::C509oid;

    // Test reference 3.1. Encoding of the SHA-256 OID
    // https://datatracker.ietf.org/doc/rfc9090/
    #[test]
    fn test_encode_decode() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        let oid = C509oid::new(oid!(2.16.840 .1 .101 .3 .4 .2 .1));
        encoder.encode(&oid).expect("Failed to encode OID");
        assert_eq!(hex::encode(buffer.clone()), "49608648016503040201");

        let mut decoder = Decoder::new(&buffer);
        let decoded_oid = decoder.decode::<C509oid>().expect("Failed to decode OID");
        assert_eq!(oid, decoded_oid);
    }

    #[test]
    fn test_encode_decode_from_registry() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        // OID_HASH_SHA1 = 1.3.14.3.2.26
        let oid = C509oid::new(oid_registry::OID_HASH_SHA1);
        encoder.encode(&oid).expect("Failed to encode OID");
        assert_eq!(hex::encode(buffer.clone()), "452b0e03021a");

        let mut decoder = Decoder::new(&buffer);
        let decoded_oid = decoder.decode::<C509oid>().expect("Failed to decode OID");
        assert_eq!(oid, decoded_oid);
    }

    #[test]
    fn test_partial_equal() {
        let oid1 = C509oid::new(oid_registry::OID_HASH_SHA1);
        let oid2 = C509oid::new(oid!(1.3.14 .3 .2 .26));
        assert_eq!(oid1, oid2);
    }
}
