//! C509 Certificate GeneralNames

mod data;
mod other_name_hw_module;
pub mod general_name;

use general_name::GeneralName;
use minicbor::{encode::Write, Decode, Decoder, Encode, Encoder};

/// A struct represents an array of GeneralName.
/// GeneralNames = [ + GeneralName ]
///
/// # Fields
/// * `general_names` - The array of GeneralName.
#[derive(Debug, Clone, PartialEq)]
pub struct GeneralNames {
    general_names: Vec<GeneralName>,
}

impl GeneralNames {
    /// Create a new instance of `GeneralNames` as empty vector.
    pub fn new() -> Self {
        Self {
            general_names: Vec::new(),
        }
    }

    /// Add a new `GeneralName` to the `GeneralNames`.
    pub fn add(&mut self, gn: GeneralName) {
        self.general_names.push(gn);
    }

    /// Get the a list of GeneralName.
    pub(crate) fn get_gns(&self) -> &Vec<GeneralName> {
        &self.general_names
    }
}

impl Encode<()> for GeneralNames {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        if self.general_names.len() == 0 {
            return Err(minicbor::encode::Error::message(
                "GeneralNames should not be empty",
            ));
        }
        e.array(self.general_names.len() as u64)?;
        for gn in &self.general_names {
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
            gn.add(GeneralName::decode(d, ctx)?);
        }
        Ok(gn)
    }
}

// ------------------Test----------------------

#[cfg(test)]
mod test_general_names {

    use std::net::Ipv4Addr;

    use super::*;
    use crate::c509_oid::C509oid;
    use asn1_rs::oid;
    use general_name::{GeneralNameRegistry, GeneralNameValue};
    use other_name_hw_module::OtherNameHardwareModuleName;

    #[test]
    fn encode_decode_gns() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let mut gns = GeneralNames::new();
        gns.add(GeneralName::new(
            GeneralNameRegistry::DNSName,
            GeneralNameValue::Text("example.com".to_string()),
        ));
        gns.add(GeneralName::new(
            GeneralNameRegistry::OtherNameHardwareModuleName,
            GeneralNameValue::OtherNameHWModuleName(OtherNameHardwareModuleName::new(
                oid!(2.16.840 .1 .101 .3 .4 .2 .1),
                vec![0x01, 0x02, 0x03, 0x04],
            )),
        ));
        gns.add(GeneralName::new(
            GeneralNameRegistry::IPAddress,
            GeneralNameValue::Bytes(Ipv4Addr::new(192, 168, 1, 1).octets().to_vec()),
        ));
        gns.add(GeneralName::new(
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
