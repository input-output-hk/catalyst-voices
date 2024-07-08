//! C509 General Names
//!
//! For more information about `GeneralNames`,
//! visit [C509 Certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/)

mod data;
pub mod general_name;
mod other_name_hw_module;

use general_name::GeneralName;
use minicbor::{encode::Write, Decode, Decoder, Encode, Encoder};

/// A struct represents an array of `GeneralName`.
///
/// ```cddl
/// GeneralNames = [ + GeneralName ]
/// ```
#[derive(Debug, Clone, PartialEq)]
pub struct GeneralNames(Vec<GeneralName>);

impl Default for GeneralNames {
    fn default() -> Self {
        Self::new()
    }
}

impl GeneralNames {
    /// Create a new instance of `GeneralNames` as empty vector.
    #[must_use]
    pub fn new() -> Self {
        Self(Vec::new())
    }

    /// Add a new `GeneralName` to the `GeneralNames`.
    pub fn add_gn(&mut self, gn: GeneralName) {
        self.0.push(gn);
    }

    /// Get the a vector of `GeneralName`.
    pub(crate) fn get_gns(&self) -> &Vec<GeneralName> {
        &self.0
    }
}

impl Encode<()> for GeneralNames {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        if self.0.is_empty() {
            return Err(minicbor::encode::Error::message(
                "GeneralNames should not be empty",
            ));
        }
        e.array(self.0.len() as u64)?;
        for gn in &self.0 {
            gn.encode(e, ctx)?;
        }
        Ok(())
    }
}

impl Decode<'_, ()> for GeneralNames {
    fn decode(d: &mut Decoder<'_>, ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
        let len = d.array()?.ok_or(minicbor::decode::Error::message(
            "GeneralNames should be an array",
        ))?;
        let mut gn = GeneralNames::new();
        for _ in 0..len {
            gn.add_gn(GeneralName::decode(d, ctx)?);
        }
        Ok(gn)
    }
}

// ------------------Test----------------------

#[cfg(test)]
mod test_general_names {

    use std::net::Ipv4Addr;

    use asn1_rs::oid;
    use general_name::{GeneralNameRegistry, GeneralNameValue};
    use other_name_hw_module::OtherNameHardwareModuleName;

    use super::*;
    use crate::c509_oid::C509oid;

    #[test]
    fn encode_decode_gns() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let mut gns = GeneralNames::new();
        gns.add_gn(GeneralName::new(
            GeneralNameRegistry::DNSName,
            GeneralNameValue::Text("example.com".to_string()),
        ));
        gns.add_gn(GeneralName::new(
            GeneralNameRegistry::OtherNameHardwareModuleName,
            GeneralNameValue::OtherNameHWModuleName(OtherNameHardwareModuleName::new(
                oid!(2.16.840 .1 .101 .3 .4 .2 .1),
                vec![0x01, 0x02, 0x03, 0x04],
            )),
        ));
        gns.add_gn(GeneralName::new(
            GeneralNameRegistry::IPAddress,
            GeneralNameValue::Bytes(Ipv4Addr::new(192, 168, 1, 1).octets().to_vec()),
        ));
        gns.add_gn(GeneralName::new(
            GeneralNameRegistry::RegisteredID,
            GeneralNameValue::Oid(C509oid::new(oid!(2.16.840 .1 .101 .3 .4 .2 .1))),
        ));
        gns.encode(&mut encoder, &mut ())
            .expect("Failed to encode GeneralNames");
        assert_eq!(hex::encode(buffer.clone()), "84026b6578616d706c652e636f6d20824960864801650304020144010203040744c0a801010849608648016503040201");

        let mut decoder = Decoder::new(&buffer);
        let gns_decoded =
            GeneralNames::decode(&mut decoder, &mut ()).expect("Failed to decode GeneralName");
        assert_eq!(gns_decoded, gns);
    }

    #[test]
    fn encode_decode_gns_empty() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let gns = GeneralNames::new();
        gns.encode(&mut encoder, &mut ())
            .expect_err("GeneralNames should not be empty");
    }
}
