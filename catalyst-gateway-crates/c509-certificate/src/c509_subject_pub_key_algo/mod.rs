//! C509 Issuer Signature Algorithm as a part of `TBSCertificate` used in C509
//! Certificate.
//!
//! ```cddl
//! subjectPublicKeyAlgorithm: AlgorithmIdentifier
//! ```

mod data;
use asn1_rs::Oid;
use data::{get_oid_from_int, SUBJECT_PUB_KEY_ALGO_LOOKUP};
use minicbor::{encode::Write, Decode, Decoder, Encode, Encoder};

use crate::{c509_algo_identifier::AlgorithmIdentifier, c509_oid::C509oidRegistered};

/// A struct represents the `SubjectPubKeyAlgorithm`
#[derive(Debug, Clone, PartialEq)]
pub struct SubjectPubKeyAlgorithm {
    /// The registered OID of the `SubjectPubKeyAlgorithm`.
    registered_oid: C509oidRegistered,
    /// An `AlgorithmIdentifier` type
    algo_identifier: AlgorithmIdentifier,
}

impl SubjectPubKeyAlgorithm {
    /// Create new instance of `SubjectPubKeyAlgorithm` where it registered with
    /// Subject Public Key Algorithm lookup table.
    pub fn new(oid: Oid<'static>, param: Option<String>) -> Self {
        Self {
            registered_oid: C509oidRegistered::new(
                oid.clone(),
                SUBJECT_PUB_KEY_ALGO_LOOKUP.get_int_to_oid_table(),
            ),
            algo_identifier: AlgorithmIdentifier::new(oid, param),
        }
    }
}

impl Encode<()> for SubjectPubKeyAlgorithm {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        if let Some(&i) = self
            .registered_oid
            .get_table()
            .get_map()
            .get_by_right(&self.registered_oid.get_c509_oid().get_oid())
        {
            e.i16(i)?;
        } else {
            AlgorithmIdentifier::encode(&self.algo_identifier, e, ctx)?;
        }
        Ok(())
    }
}

impl Decode<'_, ()> for SubjectPubKeyAlgorithm {
    fn decode(d: &mut Decoder<'_>, ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
        // Check u8 for 0 - 28
        if d.datatype()? == minicbor::data::Type::U8 {
            let i = d.i16()?;
            let oid = get_oid_from_int(i).map_err(minicbor::decode::Error::message)?;
            Ok(Self::new(oid, None))
        } else {
            let algo_identifier = AlgorithmIdentifier::decode(d, ctx)?;
            Ok(SubjectPubKeyAlgorithm::new(
                algo_identifier.get_oid(),
                algo_identifier.get_param(),
            ))
        }
    }
}

// ------------------Test----------------------

#[cfg(test)]
mod test_subject_public_key_algorithm {
    use asn1_rs::oid;

    use super::*;

    #[test]
    fn test_registered_oid() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let spka = SubjectPubKeyAlgorithm::new(oid!(1.3.101 .112), None);
        spka.encode(&mut encoder, &mut ())
            .expect("Failed to encode SubjectPubKeyAlgorithm");

        // Ed25519 - int 10: 0x0a
        assert_eq!(hex::encode(buffer.clone()), "0a");

        let mut decoder = Decoder::new(&buffer);
        let decoded_spka = SubjectPubKeyAlgorithm::decode(&mut decoder, &mut ())
            .expect("Failed to decode SubjectPubKeyAlgorithm");
        assert_eq!(decoded_spka, spka);
    }

    #[test]
    fn test_unregistered_oid() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let spka = SubjectPubKeyAlgorithm::new(oid!(2.16.840 .1 .101 .3 .4 .2 .1), None);
        spka.encode(&mut encoder, &mut ())
            .expect("Failed to encode SubjectPubKeyAlgorithm");

        // 2.16.840 .1 .101 .3 .4 .2 .1: 0x49608648016503040201
        assert_eq!(hex::encode(buffer.clone()), "49608648016503040201");

        let mut decoder = Decoder::new(&buffer);
        let decoded_spka = SubjectPubKeyAlgorithm::decode(&mut decoder, &mut ())
            .expect("Failed to decode SubjectPubKeyAlgorithm");
        assert_eq!(decoded_spka, spka);
    }

    #[test]
    fn test_unregistered_oid_with_param() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let spka = SubjectPubKeyAlgorithm::new(
            oid!(2.16.840 .1 .101 .3 .4 .2 .1),
            Some("example".to_string()),
        );
        spka.encode(&mut encoder, &mut ())
            .expect("Failed to encode SubjectPubKeyAlgorithm");
        // Array of 2 items: 0x82
        // 2.16.840 .1 .101 .3 .4 .2 .1: 0x49608648016503040201
        // bytes "example": 0x476578616d706c65
        assert_eq!(
            hex::encode(buffer.clone()),
            "8249608648016503040201476578616d706c65"
        );

        let mut decoder = Decoder::new(&buffer);
        let decoded_spka = SubjectPubKeyAlgorithm::decode(&mut decoder, &mut ())
            .expect("Failed to decode SubjectPubKeyAlgorithm");
        assert_eq!(decoded_spka, spka);
    }
}
