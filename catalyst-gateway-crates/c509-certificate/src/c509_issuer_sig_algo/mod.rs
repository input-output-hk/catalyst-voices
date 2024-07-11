//! C509 Issuer Signature Algorithm as a part of `TBSCertificate` used in C509 Certificate.
//!
//! ```cddl
//! issuerSignatureAlgorithm: AlgorithmIdentifier
//! ```

mod data;
use asn1_rs::Oid;
use data::{get_oid_from_int, ISSUER_SIG_ALGO_LOOKUP};
use minicbor::{encode::Write, Decode, Decoder, Encode, Encoder};

use crate::{c509_algo_iden::AlgorithmIdentifier, c509_oid::C509oidRegistered};

/// A struct represents the `IssuerSignatureAlgorithm`
pub struct IssuerSignatureAlgorithm {
    /// The registered OID of the `Extension`.
    registered_oid: C509oidRegistered,
    /// An `AlgorithmIdentifier` type
    algo_iden: AlgorithmIdentifier,
}

impl IssuerSignatureAlgorithm {
    /// Create new instance of `IssuerSignatureAlgorithm` where it registered with
    /// Issuer Signature Algorithm lookup table.
    pub fn new(oid: Oid<'static>, param: Option<String>) -> Self {
        Self {
            registered_oid: C509oidRegistered::new(
                oid.clone(),
                ISSUER_SIG_ALGO_LOOKUP.get_int_to_oid_table(),
            ),
            algo_iden: AlgorithmIdentifier::new(oid, param),
        }
    }
}

impl Encode<()> for IssuerSignatureAlgorithm {
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
            AlgorithmIdentifier::encode(&self.algo_iden, e, ctx)?;
        }
        Ok(())
    }
}

impl Decode<'_, ()> for IssuerSignatureAlgorithm {
    fn decode(d: &mut Decoder<'_>, ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
        match d.datatype()? {
            minicbor::data::Type::U8 | minicbor::data::Type::I16 => {
                let i = d.i16()?;
                let oid = get_oid_from_int(i).map_err(minicbor::decode::Error::message)?;
                Ok(Self::new(oid, None))
            },
            _ => {
                let algo_iden = AlgorithmIdentifier::decode(d, ctx)?;
                Ok(IssuerSignatureAlgorithm::new(
                    algo_iden.get_oid(),
                    algo_iden.get_param(),
                ))
            },
        }
    }
}
