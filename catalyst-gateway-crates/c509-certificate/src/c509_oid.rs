//! This module provides an encoding and decoding of C509 Object Identifier (OID).
//! Please refer to [RFC9090](https://datatracker.ietf.org/doc/rfc9090/) for OID encoding
//! Please refer to the [CDDL Wrapping](https://datatracker.ietf.org/doc/html/rfc8610#section-3.7) for unwrapped types.

use asn1_rs::FromDer;
use minicbor::{Decoder, Encoder};
use oid_registry::Oid;

/// Represent an instance of C509 OID where it contains an oid.
#[allow(dead_code)]
#[derive(Debug, PartialEq)]
pub struct C509Oid<'a> {
    oid: Oid<'a>,
}

/// Tag representing DER OID.
const DER_OID_TAG: u8 = 0x06;

#[allow(dead_code)]
impl<'a> C509Oid<'a> {
    /// Create an new instance of C509Oid.
    pub fn new(oid: Oid<'a>) -> Self {
        C509Oid { oid }
    }

    /// Encode an unwrapped OID (as bytes string without tag).
    /// ~oid indicates a unwrapped OID.
    ///
    /// # Returns
    ///
    /// A vector of bytes containing the CBOR encoded unwrap OID.
    /// if the encoding fails, it will return an error.
    pub fn encode_unwrap_oid(&self) -> anyhow::Result<Vec<u8>> {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        encoder
            .bytes((&self.oid).as_bytes())
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;
        Ok(buffer)
    }

    /// Decode an unwrapped OID.
    ///
    /// # Returns
    ///
    /// A C509Oid instance containing the decoded OID.
    /// if the decoding fails, it will return an error.
    pub fn decode_unwrap_oid(cbor_bytes: &Vec<u8>) -> anyhow::Result<C509Oid> {
        let mut decoder = Decoder::new(cbor_bytes);
        let oid_bytes = decoder
            .bytes()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;
        // Time Length Value (TLV) format.
        let mut der_bytes = vec![DER_OID_TAG, oid_bytes.len() as u8];
        der_bytes.extend_from_slice(oid_bytes);
        let oid = Oid::from_der(&der_bytes).map_err(|e| anyhow::anyhow!(e.to_string()))?;
        Ok(C509Oid::new(oid.1.to_owned()))
    }
}

#[cfg(test)]
mod test_c509_oid {
    use asn1_rs::oid;

    use crate::c509_oid::C509Oid;

    // Test reference 3.1. Encoding of the SHA-256 OID
    // https://datatracker.ietf.org/doc/rfc9090/
    #[test]
    fn test_encode_decode_unwrap_oid() {
        let oid = C509Oid::new(oid!(2.16.840 .1 .101 .3 .4 .2 .1));
        let encoded_unwrap_oid = oid.encode_unwrap_oid().expect("Failed to encode OID");
        assert_eq!(
            hex::encode(encoded_unwrap_oid.clone()),
            "49608648016503040201"
        );
        let decoded_unwrap_oid =
            C509Oid::decode_unwrap_oid(&encoded_unwrap_oid).expect("Failed to decode OID");
        assert_eq!(oid, decoded_unwrap_oid);
    }

    #[test]
    fn test_encode_decode_unwrap_oid_from_registry() {
        // OID_HASH_SHA1 = 1.3.14.3.2.26
        let oid = C509Oid::new(oid_registry::OID_HASH_SHA1);
        let encoded_unwrap_oid = oid.encode_unwrap_oid().expect("Failed to encode OID");
        assert_eq!(hex::encode(encoded_unwrap_oid.clone()), "452b0e03021a");
        let decoded_unwrap_oid =
            C509Oid::decode_unwrap_oid(&encoded_unwrap_oid).expect("Failed to decode OID");
        assert_eq!(oid, decoded_unwrap_oid);
    }
}
