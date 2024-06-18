//! This module provides an encoding and decoding of C509 Object Identifier (OID).
//! Please refer to [RFC9090](https://datatracker.ietf.org/doc/rfc9090/) for OID encoding
//! Please refer to [CDDL Wrapping](https://datatracker.ietf.org/doc/html/rfc8610#section-3.7) for unwrapped types.

use asn1_rs::oid;
use asn1_rs::FromBer;
use minicbor::{
    data::Tag,
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
    pen_supported: bool,
}

/*
/// A C509 Oid with Registered Integer Encoding/Decoding.
pub struct C509oidRegistered {
    oid: C509oid,
    registration_table: Arc<&phf::Map<Oid, Keyword>>
}

impl C509oidRegistered {
    fn new(oid: Oid<'a>, table: Arc<&phf::Map<Oid, Keyword>>) {
        C509oidRegistered {
            oid : C509oid::new(oid),
            registration_table: table.clone()
        }
    }
}
*/

/*
// In a seperate file say "c509_oid_extension"
struct C509ExtensionOid(C509oidRegistered);

// Use https://github.com/billyrieger/bimap-rs instead of PHF
static ExtensionsTable: phf::Map<oid, uint64> = phf_map! {
    oid!(1.2.3.4.5.6) => 5,
    oid!(1.2.3.4.5.7.8.9) => 11,
};


impl C509ExtensionOid {
    fn new(oid: Oid<'a>) {
        C509ExtensionOid(C509oidRegistered::new(oid, ExtenionsTable).pen_encoded)
    }
}
*/
/// Tag representing BER OID.
const BER_OID_TAG: u8 = 0x06;
/// Tag representing BER Relative OID.
const BER_RELATIVE_OID_TAG: u8 = 0x0d;
/// IANA Private Enterprise Number OID prefix.
const PEN_PREFIX: Oid<'static> = oid!(1.3.6 .1 .4 .1);
/// Length of the PEN prefix.
const PEN_PREFIX_LEN: usize = 6;
/// Tag number representing IANA Private Enterprise Number (PEN) OID.
const OID_PEN_TAG: u64 = 112;

#[allow(dead_code)]
impl<'a> C509oid<'a> {
    /// Create an new instance of C509oid.
    pub fn new(oid: Oid<'a>) -> Self {
        C509oid {
            oid,
            pen_supported: false,
        }
    }

    /// Is PEN Encoding supported for this OID
    pub fn pen_encoded(mut self) -> Self {
        self.pen_supported = true;
        self
    }
}

/// Encode an OID as Private Enterprise Number (PEN) OID.
fn encode_pen<W: Write>(oid: &Oid, e: &mut Encoder<W>) -> Result<(), encode::Error<W::Error>> {
    e.tag(Tag::new(OID_PEN_TAG))?;
    // Extracts the OID components, collects them into a Vec<u64>.
    let raw_oid: Vec<u64> =
        oid.iter()
            .map(|iter| iter.collect())
            .ok_or(minicbor::encode::Error::message(
                "Failed to collect OID components from iterator",
            ))?;
    // relative_oid = raw_oid relative to PEN_PREFIX 1.3.6.1.4.1
    let relative_oid = Oid::from_relative(&raw_oid[PEN_PREFIX_LEN..])
        .map_err(|_| minicbor::encode::Error::message("Failed to build a relative OID"))?;
    e.bytes(relative_oid.as_bytes())?.ok()
}

impl<C> Encode<C> for C509oid<'_> {
    /// Encode an OID
    /// If `pen_supported` flag is set, and OID start with a valid `PEN_PREFIX`
    /// is encoded as PEN (Private Enterprise Number)
    /// else encode as an unwrapped OID (~oid) - as bytes string without tag.
    ///
    /// # Returns
    ///
    /// A vector of bytes containing the CBOR encoded OID.
    /// If the encoding fails, it will return an error.
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, _ctx: &mut C,
    ) -> Result<(), encode::Error<W::Error>> {
        // Check if PEN encoding is supported and the OID starts with the PEN prefix.
        if self.pen_supported && self.oid.starts_with(&PEN_PREFIX) {
            return encode_pen(&self.oid, e);
        }
        let oid_bytes = self.oid.as_bytes();
        e.bytes(oid_bytes)?.ok()
    }
}

impl<'b, C> Decode<'b, C> for C509oid<'_> {
    /// Decode an OID
    /// If the data to be decoded is a `Tag`, and the tag is an `OID_PEN_TAG`,
    /// then decode the OID as Private Enterprise Number (PEN) OID.
    /// else decode the OID as unwrapped OID (~oid) - as bytes string without tag.

    /// # Returns
    ///
    /// A C509oid instance.
    /// If the decoding fails, it will return an error.
    fn decode(d: &mut Decoder<'b>, _ctx: &mut C) -> Result<Self, decode::Error> {
        if (minicbor::data::Type::Tag == d.datatype()?) && (Tag::new(OID_PEN_TAG) == d.tag()?) {
            let oid_bytes = d.bytes()?;
            // Time Length Value (TLV) format.
            let mut ber_bytes = vec![BER_RELATIVE_OID_TAG, oid_bytes.len() as u8];
            ber_bytes.extend_from_slice(oid_bytes);
            // Generate a relative OID from the BER bytes.
            let relative_oid = Oid::from_ber_relative(&ber_bytes).map_err(|_| {
                minicbor::decode::Error::message("Failed to generate a relative OID from BER bytes")
            })?;
            let relative_oid_u64: Vec<u64> =
                relative_oid.1.iter().map(|iter| iter.collect()).ok_or(
                    minicbor::decode::Error::message("Failed to collect OID components"),
                )?;
            let mut pen_prefix_oid_u64: Vec<u64> =
                PEN_PREFIX.iter().map(|iter| iter.collect()).ok_or(
                    minicbor::decode::Error::message("Failed to collect OID components"),
                )?;
            // Combine the PEN prefix and the relative OID.
            pen_prefix_oid_u64.extend_from_slice(&relative_oid_u64);
            let oid = Oid::from(&pen_prefix_oid_u64)
                .map_err(|_| minicbor::decode::Error::message("Failed to build an OID"))?;
            return Ok(C509oid::new(oid).pen_encoded());
        }
        // Not a PEN Relative OID, so treat as a normal OID
        let oid_bytes = d.bytes()?;
        // Time Length Value (TLV) format.
        let mut ber_bytes = vec![BER_OID_TAG, oid_bytes.len() as u8];
        ber_bytes.extend_from_slice(oid_bytes);
        let oid = Oid::from_ber(&ber_bytes)
            .map_err(|e| minicbor::decode::Error::message(e.to_string()))?;
        Ok(C509oid::new(oid.1.to_owned()))
    }
}

#[cfg(test)]
mod test_c509_oid {

    use asn1_rs::oid;
    use minicbor::{Decode, Decoder, Encode, Encoder};

    use crate::c509_oid::C509oid;

    // Test reference 3.1. Encoding of the SHA-256 OID
    // https://datatracker.ietf.org/doc/rfc9090/
    #[test]
    fn test_encode_decode() {
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
    fn test_encode_decode_from_registry() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        // OID_HASH_SHA1 = 1.3.14.3.2.26
        let oid = C509oid::new(oid_registry::OID_HASH_SHA1);
        oid.encode(&mut encoder, &mut ())
            .expect("Failed to encode OID");
        assert_eq!(hex::encode(buffer.clone()), "452b0e03021a");

        let mut decoder = Decoder::new(&buffer);
        let decoded_oid = C509oid::decode(&mut decoder, &mut ()).expect("Failed to decode OID");
        assert_eq!(decoded_oid, oid);
    }

    #[test]
    fn test_encode_decode_pen() {
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
    fn test_partial_equal() {
        let oid1 = C509oid::new(oid_registry::OID_HASH_SHA1);
        let oid2 = C509oid::new(oid!(1.3.14 .3 .2 .26));
        assert_eq!(oid1, oid2);
    }
}
