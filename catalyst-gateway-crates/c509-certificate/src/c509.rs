//! C509 Certificate

use minicbor::{encode::Write, Decode, Decoder, Encode, Encoder};
use serde::{Deserialize, Serialize};

use crate::tbs_cert::TbsCert;

#[derive(Deserialize, Serialize)]
/// A struct represents the `C509` Certificate.
pub struct C509 {
    /// A TBS Certificate.
    tbs_cert: TbsCert,
    /// An optional `IssuerSignatureValue` of the C509 Certificate.
    issuer_signature_value: Option<Vec<u8>>,
}

impl C509 {
    /// Create a new instance of C509 Certificate .
    #[must_use]
    pub fn new(tbs_cert: TbsCert, issuer_signature_value: Option<Vec<u8>>) -> Self {
        Self {
            tbs_cert,
            issuer_signature_value,
        }
    }

    /// Get the `TBSCertificate` of the C509 Certificate.
    #[must_use]
    pub fn get_tbs_cert(&self) -> &TbsCert {
        &self.tbs_cert
    }

    /// Get the `IssuerSignatureValue` of the C509 Certificate.
    #[must_use]
    pub fn get_issuer_signature_value(&self) -> &Option<Vec<u8>> {
        &self.issuer_signature_value
    }
}

impl Encode<()> for C509 {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        self.tbs_cert.encode(e, ctx)?;
        match self.issuer_signature_value {
            Some(ref value) => e.bytes(value)?,
            None => e.null()?,
        };
        Ok(())
    }
}

impl Decode<'_, ()> for C509 {
    fn decode(d: &mut Decoder<'_>, ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
        let tbs_cert = TbsCert::decode(d, ctx)?;
        let issuer_signature_value = match d.datatype()? {
            minicbor::data::Type::Bytes => Some(d.bytes()?.to_vec()),
            _ => None,
        };
        Ok(Self::new(tbs_cert, issuer_signature_value))
    }
}
