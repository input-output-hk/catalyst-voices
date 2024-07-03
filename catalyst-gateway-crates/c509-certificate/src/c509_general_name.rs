//! C509 General Name

// FIXME - revisit visibility

use std::collections::HashMap;

use crate::{c509_oid::C509oid, tables::IntegerToGNTable};
use anyhow::Error;
use asn1_rs::Oid;
use minicbor::{
    encode::{self, Write},
    Decode, Decoder, Encode, Encoder,
};
use once_cell::sync::Lazy;
use std::fmt::Debug;
use strum_macros::{EnumDiscriminants, EnumIs};

// ----------------General Name Data-------------------

/// Type of GeneralName data.
/// Int | Name | Type
type GeneralNameDataTuple = (i16, GeneralNameRegistry, GeneralNameValueType);
const GENERAL_NAME_DATA: [GeneralNameDataTuple; 10] = [
    (
        -3,
        GeneralNameRegistry::OtherNameBundleEID,
        GeneralNameValueType::Unsupported,
    ),
    (
        -2,
        GeneralNameRegistry::OtherNameSmtpUTF8Mailbox,
        GeneralNameValueType::Text,
    ),
    (
        -1,
        GeneralNameRegistry::OtherNameHardwareModuleName,
        GeneralNameValueType::OtherNameHWModuleName,
    ),
    (
        0,
        GeneralNameRegistry::OtherName,
        GeneralNameValueType::OtherNameHWModuleName,
    ),
    (
        1,
        GeneralNameRegistry::Rfc822Name,
        GeneralNameValueType::Text,
    ),
    (2, GeneralNameRegistry::DNSName, GeneralNameValueType::Text),
    (
        4,
        GeneralNameRegistry::DirectoryName,
        GeneralNameValueType::Unsupported,
    ),
    (
        6,
        GeneralNameRegistry::UniformResourceIdentifier,
        GeneralNameValueType::Text,
    ),
    (
        7,
        GeneralNameRegistry::IPAddress,
        GeneralNameValueType::Bytes,
    ),
    (
        8,
        GeneralNameRegistry::RegisteredID,
        GeneralNameValueType::Oid,
    ),
];

/// A struct of data that contains lookup table for `GeneralName`.
///
/// # Fields
/// * `int_to_name_table` - A table of ineger to `GeneralNameRegistry`, provide a bidirectional lookup.
/// * `int_to_type_table` - A table of integer to `GeneralNameValueType`, provide a lookup for the type of `GeneralName` value.
struct GeneralNameData {
    int_to_name_table: IntegerToGNTable,
    int_to_type_table: HashMap<i16, GeneralNameValueType>,
}

/// Define static lookup for general names table
/// Reference Section - 9.9. C509 General Names Registry.
static GENERAL_NAME_TABLES: Lazy<GeneralNameData> = Lazy::new(|| {
    let mut int_to_name_table = IntegerToGNTable::new();
    let mut int_to_type_table = HashMap::new();

    for data in GENERAL_NAME_DATA {
        int_to_name_table.add(data.0, data.1);
        int_to_type_table.insert(data.0, data.2);
    }

    return GeneralNameData {
        int_to_name_table,
        int_to_type_table,
    };
});

// ------------------GeneralNames---------------------

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
        // GeneralNames is encode as array
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

// -------------------GeneralName----------------------

/// A struct represents a GeneralName.
/// GeneralName = ( GeneralNameType : int, GeneralNameValue : any )
///
/// # Fields
/// * `gn` - An enum of registered `GeneralName`.
/// * `value` - The value of the `GeneralName` in `GeneralNameValue`.
#[derive(Debug, Clone, PartialEq)]
pub struct GeneralName {
    gn: GeneralNameRegistry,
    value: GeneralNameValue,
}

#[allow(dead_code)]
impl GeneralName {
    /// Create a new instance of `GeneralName`.
    pub(crate) fn new(gn: GeneralNameRegistry, value: GeneralNameValue) -> Self {
        Self { gn, value }
    }

    /// Get the `GeneralName` type.
    pub(crate) fn get_gn(&self) -> &GeneralNameRegistry {
        &self.gn
    }

    /// Get the value of the `GeneralName` in `GeneralNameValue`.
    pub(crate) fn get_gn_value(&self) -> &GeneralNameValue {
        &self.value
    }
}

impl Encode<()> for GeneralName {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        // Encode GeneralNameType as int
        let i = self
            .gn
            .get_int()
            .map_err(|e| minicbor::encode::Error::message(e))?;
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
                .int_to_name_table
                .get_map()
                .get_by_left(&i)
                .ok_or(minicbor::decode::Error::message(
                    "GeneralName int value not found in the table",
                ))?;
            // Get the value type from the int value
            let value_type = *GENERAL_NAME_TABLES
                .int_to_type_table
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

// -----------------GeneralNameRegistry------------------------

/// Enum of `GeneralName` registered in table Section 9.9 C509.
#[derive(Debug, Copy, PartialEq, Clone, Eq, Hash, EnumIs)]
pub enum GeneralNameRegistry {
    OtherNameBundleEID, // EID
    OtherNameSmtpUTF8Mailbox,
    OtherNameHardwareModuleName,
    OtherName,
    Rfc822Name,
    DNSName,
    DirectoryName, // Name
    UniformResourceIdentifier,
    IPAddress,
    RegisteredID,
}

impl GeneralNameRegistry {
    /// Get the integer value associated with the `GeneralNameRegistry`.
    pub(crate) fn get_int(&self) -> Result<i16, Error> {
        let i = GENERAL_NAME_TABLES
            .int_to_name_table
            .get_map()
            .get_by_right(&self);
        match i {
            Some(i) => Ok(*i),
            None => Err(Error::msg("Int value of GeneralName not found")),
        }
    }
}

// -------------------GeneralNameValue----------------------

/// Trait for `GeneralNameValueType`
trait GeneralNameValueTrait {
    /// Get the type of the `GeneralNameValueType`.
    fn get_type(&self) -> GeneralNameValueType;
}

#[allow(dead_code)]
#[derive(Debug, PartialEq, Clone, Eq, Hash, EnumDiscriminants)]
#[strum_discriminants(name(GeneralNameValueType))]
pub enum GeneralNameValue {
    Text(String),
    OtherNameHWModuleName(OtherNameHardwareModuleName),
    Bytes(Vec<u8>),
    Oid(C509oid),
    Unsupported,
}

impl GeneralNameValueTrait for GeneralNameValueType {
    fn get_type(&self) -> GeneralNameValueType {
        self.clone()
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
where
    C: GeneralNameValueTrait + Debug,
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
            GeneralNameValueType::Unsupported => Err(minicbor::decode::Error::message(
                "Cannot decode Unsupported GeneralName value",
            )),
        }
    }
}

// -----------------------------------------

/*
/// A struct represents an Endpoint IDentifier (EID) in the Bundle Protocol.
/// EID structure define in [RFC9171](https://datatracker.ietf.org/doc/rfc9171/)
///
/// # Fields
/// * `uri_code` - The URI code of the EID.
/// * `ssp` - The Scheme Specific Part (SSP) of the EID.
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub(crate) struct Eid {
    uri_code: BundleProtocolURISchemeTypes,
    ssp: String,
}

/// An Enum of `BundleProtocolURISchemeTypes` defines the type of URI scheme
/// URI Scheme can be found in [RFC9171](https://datatracker.ietf.org/doc/rfc9171/) Section 9.7
///
/// DTN scheme syntax
/// ```text
/// dtn-uri = "dtn:" ("none" / dtn-hier-part)
/// dtn-hier-part = "//" node-name name-delim demux ; a path-rootless
/// node-name = reg-name
/// name-delim = "/"
/// demux = *VCHAR
/// ```
/// Note that - *VCHAR consists of zero or more visible characters
/// Example dtn://node1/service1/data
///
/// IPN scheme syntax
/// ```text
/// ipn-uri = "ipn:" ipn-hier-part
/// ipn-hier-part = node-nbr nbr-delim service-nbr ; a path-rootless
/// node-nbr = 1*DIGIT
/// nbr-delim = "."
/// service-nbr = 1*DIGIT
/// ```
/// Note that 1*DIGIT consists of one or more digits
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub(crate) enum BundleProtocolURISchemeTypes {
    Dtn,
    Ipn,
}

impl BundleProtocolURISchemeTypes {
    /// Convert the integer value to associated BundleProtocolURISchemeTypes.
    fn from_int(value: u8) -> Option<Self> {
        match value {
            1 => Some(BundleProtocolURISchemeTypes::Dtn),
            2 => Some(BundleProtocolURISchemeTypes::Ipn),
            _ => None,
        }
    }
}

impl Eid {
    /// Create a new instance of Eid.
    pub fn new(uri_code: BundleProtocolURISchemeTypes, ssp: String) -> Self {
        Self { uri_code, ssp }
    }
}

impl Encode<()> for Eid {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, _ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        e.array(2)?;
        e.u8(self.uri_code.clone() as u8)?;
        e.bytes(&self.ssp.as_bytes())?;
        Ok(())
    }
}

impl<'a> Decode<'a, ()> for Eid {
    fn decode(d: &mut Decoder<'a>, _ctx: &mut ()) -> Result<Self, decode::Error> {
        d.array()?;
        let uri_code = d.u8()?;
        let ssp = d.bytes()?;
        Ok(Eid::new(
            BundleProtocolURISchemeTypes::from_int(uri_code).ok_or(decode::Error::message(
                format!("Invalid uri code value, provided {uri_code}"),
            ))?,
            String::from_utf8(ssp.to_vec())
                .map_err(|_| decode::Error::message("Failed to convert bytes to string"))?,
        ))
    }
}
*/

// --------------OtherNameHardwareModuleName------------------

/// A struct represents the hardwareModuleName type of otherName.
/// Containing a pair of ( hwType, hwSerialNum ) as mentioned in
/// [RFC4108](https://datatracker.ietf.org/doc/rfc4108/)
///
/// # Fields
/// * `hw_type` - The hardware type OID.
/// * `hw_serial_num` - The hardware serial number represent in bytes.
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub(crate) struct OtherNameHardwareModuleName {
    hw_type: C509oid,
    hw_serial_num: Vec<u8>,
}

impl OtherNameHardwareModuleName {
    /// Create a new instance of OtherNameHardwareModuleName.
    pub fn new(hw_type: Oid<'static>, hw_serial_num: Vec<u8>) -> Self {
        Self {
            hw_type: C509oid::new(hw_type),
            hw_serial_num,
        }
    }
}

impl Encode<()> for OtherNameHardwareModuleName {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut (),
    ) -> Result<(), encode::Error<W::Error>> {
        e.array(2)?;
        self.hw_type.encode(e, ctx)?;
        e.bytes(&self.hw_serial_num)?;
        Ok(())
    }
}

impl<'a> Decode<'a, ()> for OtherNameHardwareModuleName {
    fn decode(d: &mut Decoder<'a>, ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
        d.array()?;
        let hw_type = C509oid::decode(d, ctx)?;
        let hw_serial_num = d.bytes()?.to_vec();
        Ok(OtherNameHardwareModuleName::new(
            hw_type.get_oid(),
            hw_serial_num,
        ))
    }
}

// ------------------Test----------------------

#[cfg(test)]
mod test_general_name {
    use std::net::Ipv4Addr;

    use super::*;
    use asn1_rs::oid;

    #[test]
    fn test_encode_decode_gn_text() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let gn = GeneralName::new(
            GeneralNameRegistry::DNSName,
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
    fn test_encode_decode_gn_hw_module_name() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let hw = OtherNameHardwareModuleName::new(
            oid!(2.16.840 .1 .101 .3 .4 .2 .1),
            vec![0x01, 0x02, 0x03, 0x04],
        );
        let gn = GeneralName::new(
            GeneralNameRegistry::OtherNameHardwareModuleName,
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
    fn test_encode_decode_gn_ip() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let ipv4 = Ipv4Addr::new(192, 168, 1, 1);
        let gn = GeneralName::new(
            GeneralNameRegistry::IPAddress,
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
    fn test_encode_decode_gn_oid() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let gn = GeneralName::new(
            GeneralNameRegistry::RegisteredID,
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
    fn test_encode_decode_gn_mismatch_type() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let gn = GeneralName::new(
            GeneralNameRegistry::OtherNameSmtpUTF8Mailbox,
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

    #[test]
    fn test_encode_decode_gns() {
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
}
