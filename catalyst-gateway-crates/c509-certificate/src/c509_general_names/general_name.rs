//! C509 General Name
//!
//! For more information about `GeneralName`,
//! visit [C509 Certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/)

use std::fmt::Debug;

use anyhow::Error;
use minicbor::{encode::Write, Decode, Decoder, Encode, Encoder};
use strum_macros::{EnumDiscriminants, EnumIs};

use super::{data::GENERAL_NAME_TABLES, other_name_hw_module::OtherNameHardwareModuleName};
use crate::c509_oid::C509oid;

/// A struct represents a `GeneralName`.
/// ```cddl
/// GeneralName = ( GeneralNameType : int, GeneralNameValue : any )
/// ```
#[derive(Debug, Clone, PartialEq)]
pub struct GeneralName {
    /// A registered general name type.
    gn_type: GeneralNameTypeRegistry,
    /// A general name value.
    value: GeneralNameValue,
}

#[allow(dead_code)]
impl GeneralName {
    /// Create a new instance of `GeneralName`.
    #[must_use]
    pub fn new(gn_type: GeneralNameTypeRegistry, value: GeneralNameValue) -> Self {
        Self { gn_type, value }
    }

    /// Get the `GeneralName` type.
    #[must_use]
    pub fn get_gn_type(&self) -> &GeneralNameTypeRegistry {
        &self.gn_type
    }

    /// Get the value of the `GeneralName` in `GeneralNameValue`.
    #[must_use]
    pub fn get_gn_value(&self) -> &GeneralNameValue {
        &self.value
    }
}

impl Encode<()> for GeneralName {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        // Encode GeneralNameType as int
        let i = self
            .gn_type
            .get_int()
            .map_err(minicbor::encode::Error::message)?;
        e.i16(i)?;
        // Encode GeneralNameValue as its type
        self.value.encode(e, ctx)?;
        Ok(())
    }
}

impl Decode<'_, ()> for GeneralName {
    fn decode(d: &mut Decoder<'_>, _ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
        if minicbor::data::Type::U8 == d.datatype()? || minicbor::data::Type::I8 == d.datatype()? {
            let i = d.i16()?;
            // Get the name from the int value
            let gn = *GENERAL_NAME_TABLES
                .get_int_to_name_table()
                .get_map()
                .get_by_left(&i)
                .ok_or(minicbor::decode::Error::message(
                    "GeneralName int value not found in the table",
                ))?;
            // Get the value type from the int value
            let value_type = *GENERAL_NAME_TABLES
                .get_int_to_type_table()
                .get(&i)
                .ok_or_else(|| {
                    minicbor::decode::Error::message("Extension value type not found")
                })?;
            Ok(GeneralName::new(
                gn,
                GeneralNameValue::decode(d, &mut value_type.get_type())?,
            ))
        } else {
            // GeneralName is not type int
            Err(minicbor::decode::Error::message(
                "GeneralName id type invalid, expected int",
            ))
        }
    }
}

// -----------------GeneralNameTypeRegistry------------------------

/// Enum of `GeneralName` registered in table Section 9.9 C509.
#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Copy, PartialEq, Clone, Eq, Hash, EnumIs)]
pub enum GeneralNameTypeRegistry {
    /// An otherName with `BundleEID`.
    OtherNameBundleEID, // EID
    /// An otherName with `SmtpUTF8Mailbox`.
    OtherNameSmtpUTF8Mailbox,
    /// An otherName with `HardwareModuleName`.
    OtherNameHardwareModuleName,
    /// An otherName.
    OtherName,
    /// A rfc822Name.
    Rfc822Name,
    /// A dNSName.
    DNSName,
    /// A directoryName.
    DirectoryName, // Name
    /// A uniformResourceIdentifier.
    UniformResourceIdentifier,
    /// An iPAddress.
    IPAddress,
    /// A registeredID.
    RegisteredID,
}

impl GeneralNameTypeRegistry {
    /// Get the integer value associated with the `GeneralNameTypeRegistry`.
    pub(crate) fn get_int(self) -> Result<i16, Error> {
        let i = GENERAL_NAME_TABLES
            .get_int_to_name_table()
            .get_map()
            .get_by_right(&self);
        match i {
            Some(i) => Ok(*i),
            None => Err(Error::msg("Int value of GeneralName not found")),
        }
    }
}

// -------------------GeneralNameValue----------------------

/// An enum of possible value types for `GeneralName`.
#[allow(clippy::module_name_repetitions)]
#[derive(Debug, PartialEq, Clone, Eq, Hash, EnumDiscriminants)]
#[strum_discriminants(name(GeneralNameValueType))]
pub enum GeneralNameValue {
    /// A text string.
    Text(String),
    /// A otherName + hardwareModuleName.
    OtherNameHWModuleName(OtherNameHardwareModuleName),
    /// A bytes.
    Bytes(Vec<u8>),
    /// An OID
    Oid(C509oid),
    /// An unsupported value.
    Unsupported,
}

/// Trait for `GeneralNameValueType`
trait GeneralNameValueTrait {
    /// Get the type of the `GeneralNameValueType`.
    fn get_type(&self) -> GeneralNameValueType;
}

impl GeneralNameValueTrait for GeneralNameValueType {
    fn get_type(&self) -> GeneralNameValueType {
        *self
    }
}

impl Encode<()> for GeneralNameValue {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        match self {
            GeneralNameValue::Text(value) => {
                e.str(value)?;
            },
            GeneralNameValue::Bytes(value) => {
                e.bytes(value)?;
            },
            GeneralNameValue::Oid(value) => {
                value.encode(e, ctx)?;
            },
            GeneralNameValue::OtherNameHWModuleName(value) => {
                value.encode(e, ctx)?;
            },
            GeneralNameValue::Unsupported => {
                return Err(minicbor::encode::Error::message(
                    "Cannot encode unsupported GeneralName value",
                ))
            },
        };
        Ok(())
    }
}
impl<C> Decode<'_, C> for GeneralNameValue
where C: GeneralNameValueTrait + Debug
{
    fn decode(d: &mut Decoder<'_>, ctx: &mut C) -> Result<Self, minicbor::decode::Error> {
        match ctx.get_type() {
            GeneralNameValueType::Text => {
                let value = d.str()?.to_string();
                Ok(GeneralNameValue::Text(value))
            },
            GeneralNameValueType::Bytes => {
                let value = d.bytes()?.to_vec();
                Ok(GeneralNameValue::Bytes(value))
            },
            GeneralNameValueType::Oid => {
                let value = C509oid::decode(d, &mut ())?;
                Ok(GeneralNameValue::Oid(value))
            },
            GeneralNameValueType::OtherNameHWModuleName => {
                let value = OtherNameHardwareModuleName::decode(d, &mut ())?;
                Ok(GeneralNameValue::OtherNameHWModuleName(value))
            },
            GeneralNameValueType::Unsupported => {
                Err(minicbor::decode::Error::message(
                    "Cannot decode Unsupported GeneralName value",
                ))
            },
        }
    }
}

// ------------------Test----------------------

#[cfg(test)]
mod test_general_name {
    use std::net::Ipv4Addr;

    use asn1_rs::oid;

    use super::*;

    #[test]
    fn encode_decode_text() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let gn = GeneralName::new(
            GeneralNameTypeRegistry::DNSName,
            GeneralNameValue::Text("example.com".to_string()),
        );
        gn.encode(&mut encoder, &mut ())
            .expect("Failed to encode GeneralName");
        // DNSName: 0x02
        // "example.com": 0x6b6578616d706c652e636f6d
        assert_eq!(hex::encode(buffer.clone()), "026b6578616d706c652e636f6d");

        let mut decoder = Decoder::new(&buffer);
        let gn_decoded =
            GeneralName::decode(&mut decoder, &mut ()).expect("Failed to decode GeneralName");
        assert_eq!(gn_decoded, gn);
    }

    #[test]
    fn encode_decode_hw_module_name() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let hw = OtherNameHardwareModuleName::new(oid!(2.16.840 .1 .101 .3 .4 .2 .1), vec![
            0x01, 0x02, 0x03, 0x04,
        ]);
        let gn = GeneralName::new(
            GeneralNameTypeRegistry::OtherNameHardwareModuleName,
            GeneralNameValue::OtherNameHWModuleName(hw),
        );
        gn.encode(&mut encoder, &mut ())
            .expect("Failed to encode GeneralName");
        // OtherNameHardwareModuleName: 0x20
        // [ ~oid, bytes ] = 0x82496086480165030402014401020304
        assert_eq!(
            hex::encode(buffer.clone()),
            "2082496086480165030402014401020304"
        );

        let mut decoder = Decoder::new(&buffer);
        let gn_decoded =
            GeneralName::decode(&mut decoder, &mut ()).expect("Failed to decode GeneralName");
        assert_eq!(gn_decoded, gn);
    }

    #[test]
    fn encode_decode_ip() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let ipv4 = Ipv4Addr::new(192, 168, 1, 1);
        let gn = GeneralName::new(
            GeneralNameTypeRegistry::IPAddress,
            GeneralNameValue::Bytes(ipv4.octets().to_vec()),
        );

        gn.encode(&mut encoder, &mut ())
            .expect("Failed to encode GeneralName");
        // IPAddress: 0x07
        // 192.168.1.1 bytes: 0x44c0a8010
        assert_eq!(hex::encode(buffer.clone()), "0744c0a80101");

        let mut decoder = Decoder::new(&buffer);
        let gn_decoded =
            GeneralName::decode(&mut decoder, &mut ()).expect("Failed to decode GeneralName");
        assert_eq!(gn_decoded, gn);
    }

    #[test]
    fn encode_decode_oid() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let gn = GeneralName::new(
            GeneralNameTypeRegistry::RegisteredID,
            GeneralNameValue::Oid(C509oid::new(oid!(2.16.840 .1 .101 .3 .4 .2 .1))),
        );
        gn.encode(&mut encoder, &mut ())
            .expect("Failed to encode GeneralName");
        // RegisteredID: 0x08
        // oid: 49608648016503040201
        assert_eq!(hex::encode(buffer.clone()), "0849608648016503040201");

        let mut decoder = Decoder::new(&buffer);
        let gn_decoded =
            GeneralName::decode(&mut decoder, &mut ()).expect("Failed to decode GeneralName");
        assert_eq!(gn_decoded, gn);
    }

    #[test]
    fn encode_decode_mismatch_type() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let gn = GeneralName::new(
            GeneralNameTypeRegistry::OtherNameSmtpUTF8Mailbox,
            GeneralNameValue::Oid(C509oid::new(oid!(2.16.840 .1 .101 .3 .4 .2 .1))),
        );
        gn.encode(&mut encoder, &mut ())
            .expect("Failed to encode GeneralName");
        // OtherNameSmtpUTF8Mailbox: 0x21
        // oid: 49608648016503040201
        assert_eq!(hex::encode(buffer.clone()), "2149608648016503040201");

        let mut decoder = Decoder::new(&buffer);
        // Decode should fail, because rely on the int value
        GeneralName::decode(&mut decoder, &mut ()).expect_err("Failed to decode GeneralName");
    }
}
