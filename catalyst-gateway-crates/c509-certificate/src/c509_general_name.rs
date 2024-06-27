//! C509 Alternative Name

use asn1_rs::Oid;
use minicbor::{encode::Write, Decode, Decoder, Encode, Encoder};
use num_derive::FromPrimitive;
use num_traits::FromPrimitive;
use once_cell::sync::Lazy;

use crate::{c509_oid::C509oid, tables::IntegerToGNRegistryTable};

#[derive(Debug, PartialEq, Clone, Copy, Eq, Hash)]
pub enum GeneralNamesRegistry {
    OtherNameBundleEID,
    OtherNameSmtpUTF8Mailbox,
    OtherNameHardwareModuleName,
    OtherName,
    Rfc822Name,
    DNSName,
    DirectoryName,
    UniformResourceIdentifier,
    IPAddress,
    RegisteredID,
}

// The GeneralNamesRegistry table in C509 mentioned in Section 9.9.
#[allow(dead_code)]
static GENERAL_NAMES_TABLE: Lazy<IntegerToGNRegistryTable> = Lazy::new(|| {
    IntegerToGNRegistryTable::new(vec![
        // Int | GeneralNamesRegistry | type
        (-3, GeneralNamesRegistry::OtherNameBundleEID), // eid-structure from RFC 9171
        (-2, GeneralNamesRegistry::OtherNameSmtpUTF8Mailbox), // text
        (-1, GeneralNamesRegistry::OtherNameHardwareModuleName), // [ ~oid, bytes ]
        (0, GeneralNamesRegistry::OtherName),           // [ ~oid, bytes ]
        (1, GeneralNamesRegistry::Rfc822Name),          // text
        (2, GeneralNamesRegistry::DNSName),             // text
        (4, GeneralNamesRegistry::DirectoryName),       // Name
        (6, GeneralNamesRegistry::UniformResourceIdentifier), // text
        (7, GeneralNamesRegistry::IPAddress),           // bytes
        (8, GeneralNamesRegistry::RegisteredID),        // ~oid
    ])
});

/// A struct represents an Endpoint IDentifier (EID) in the Bundle Protocol.
/// EID structure define in [RFC9171](https://datatracker.ietf.org/doc/rfc9171/)
///
/// # Fields
/// * `uri_code` - The URI code of the EID.
/// * `ssp` - The Scheme Specific Part (SSP) of the EID.
#[allow(dead_code)]
pub(crate) struct Eid {
    pub uri_code: BundleProtocolURISchemeTypes,
    pub ssp: String,
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
#[allow(dead_code)]
#[derive(Clone, FromPrimitive)]
pub(crate) enum BundleProtocolURISchemeTypes {
    Dtn = 1,
    Ipn = 2,
}

#[allow(dead_code)]
impl Eid {
    /// Create a new instance of Eid.
    pub fn new(uri_code: BundleProtocolURISchemeTypes, ssp: String) -> Self {
        Self { uri_code, ssp }
    }
}

#[allow(dead_code)]
impl<C> Encode<C> for Eid {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, _ctx: &mut C,
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        e.array(2)?;
        e.u8(self.uri_code.clone() as u8)?;
        e.bytes(&self.ssp.as_bytes())?;
        Ok(())
    }
}

#[allow(dead_code)]
impl<'a, C> Decode<'a, C> for Eid {
    fn decode(d: &mut Decoder<'a>, _ctx: &mut C) -> Result<Self, minicbor::decode::Error> {
        d.array()?;
        let uri_code = d.u8()?;
        let ssp = d.bytes()?;
        Ok(Eid::new(
            FromPrimitive::from_u8(uri_code).ok_or(minicbor::decode::Error::message(format!(
                "Invalid uri code value, provided {uri_code}"
            )))?,
            String::from_utf8(ssp.to_vec()).map_err(|_| {
                minicbor::decode::Error::message("Failed to convert bytes to string")
            })?,
        ))
    }
}

// -----------------------------------------

/// Represent the hardwareModuleName type of otherName.
/// Containing a pair of ( hwType, hwSerialNum ) as mentioned in
/// [RFC4108](https://datatracker.ietf.org/doc/rfc4108/)
///
/// # Fields
/// * `hw_type` - The hardware type OID.
/// * `hw_serial_num` - The hardware serial number represent in bytes.
#[allow(dead_code)]
pub(crate) struct OtherNameHardwareModuleName<'a> {
    hw_type: C509oid<'a>,
    hw_serial_num: Vec<u8>,
}

#[allow(dead_code)]
impl<'a> OtherNameHardwareModuleName<'a> {
    /// Create a new instance of OtherNameHardwareModuleName.
    pub fn new(hw_type: Oid<'a>, hw_serial_num: Vec<u8>) -> Self {
        Self {
            hw_type: C509oid::new(hw_type),
            hw_serial_num,
        }
    }
}

impl<C> Encode<C> for OtherNameHardwareModuleName<'_> {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, _ctx: &mut C,
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        e.array(2)?;
        self.hw_type.encode(e, &mut ())?;
        e.bytes(&self.hw_serial_num)?;
        Ok(())
    }
}

impl<'a, C> Decode<'a, C> for OtherNameHardwareModuleName<'_> {
    fn decode(d: &mut Decoder<'a>, _ctx: &mut C) -> Result<Self, minicbor::decode::Error> {
        d.array()?;
        let hw_type = C509oid::decode(d, &mut ())?;
        let hw_serial_num = d.bytes()?.to_vec();
        Ok(OtherNameHardwareModuleName::new(
            hw_type.get_oid(),
            hw_serial_num,
        ))
    }
}

// -----------------------------------------

/// A struct represents a registered GeneralName.
///
/// # Fields
/// * `gn_type` - The general name type enum in the GeneralNamesRegistry table.
/// * `registration_table` - The GeneralNamesRegistry table in C509 mentioned in Section 9.9.
#[derive(Debug, Clone, PartialEq)]
pub(crate) struct GeneralNameRegistered {
    gn_type: GeneralNamesRegistry,
    registration_table: &'static IntegerToGNRegistryTable,
}

#[allow(dead_code)]
impl GeneralNameRegistered {
    /// Create a new instance of GeneralNameRegistered.
    pub(crate) fn new(
        gn_type: GeneralNamesRegistry, table: &'static IntegerToGNRegistryTable,
    ) -> Self {
        GeneralNameRegistered {
            gn_type,
            registration_table: table,
        }
    }

    /// Get the GeneralNamesRegistry type enum.
    pub(crate) fn get_gn_type(&self) -> GeneralNamesRegistry {
        self.gn_type
    }

    /// Get the GeneralNamesRegistry table.
    pub(crate) fn get_table(&self) -> &'static IntegerToGNRegistryTable {
        self.registration_table
    }
}

// -----------------------------------------

/// A struct represents an array of GeneralName.
/// GeneralNames = [ + GeneralName ]
///
/// # Fields
/// * `names` - The array of GeneralName.
#[allow(dead_code)]
pub struct GeneralNames<T> {
    names: Vec<GeneralName<T>>,
}

#[allow(dead_code)]
impl<T> GeneralNames<T> {
    /// Create a new empty instance of GeneralNames.
    pub fn new() -> Self {
        Self { names: Vec::new() }
    }

    /// Add a new GeneralName to the GeneralNames.
    pub fn add(&mut self, gn: GeneralName<T>) {
        self.names.push(gn);
    }
}

#[allow(dead_code)]
impl<T, C> Encode<C> for GeneralNames<T>
where
    T: Encode<()>,
{
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, _ctx: &mut C,
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        e.array(self.names.len() as u64)?;
        for gn in &self.names {
            gn.encode(e, &mut ())?;
        }
        Ok(())
    }
}

impl<'a, C, T> Decode<'a, C> for GeneralNames<T>
where
    T: Decode<'a, ()>,
{
    fn decode(d: &mut Decoder<'a>, _ctx: &mut C) -> Result<Self, minicbor::decode::Error> {
        let len = d.array()?.ok_or(minicbor::decode::Error::message(
            "GeneralNames should be array",
        ))?;
        let mut gn = GeneralNames::new();
        for _ in 0..len {
            gn.add(GeneralName::decode(d, &mut ())?);
        }
        Ok(gn)
    }
}

// -----------------------------------------

/// A struct represents a GeneralName.
/// GeneralName = ( GeneralNameType : int, GeneralNameValue : any )
///
/// # Fields
/// * `registered_gn` - The enum of registered GeneralName type.
/// * `value` - The value of the GeneralName.
#[allow(dead_code)]
#[derive(Debug, Clone, PartialEq)]
pub struct GeneralName<T> {
    registered_gn: GeneralNameRegistered,
    value: T,
}

#[allow(dead_code)]
impl<T> GeneralName<T> {
    /// Create a new instance of GeneralName.
    pub fn new(gn: GeneralNamesRegistry, value: T) -> Self {
        Self {
            registered_gn: GeneralNameRegistered::new(gn, &GENERAL_NAMES_TABLE),
            value,
        }
    }
}

#[allow(dead_code)]
impl<T, C> Encode<C> for GeneralName<T>
where
    T: Encode<()>,
{
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, _ctx: &mut C,
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        if let Some(gn) = self
            .registered_gn
            .get_table()
            .get_map()
            .get_by_right(&self.registered_gn.get_gn_type())
        {
            e.i16(*gn)?;
            self.value.encode(e, &mut ())?;
            Ok(())
        } else {
            Err(minicbor::encode::Error::message(
                "GeneralName type not supported",
            ))
        }
    }
}

impl<'a, C, T> Decode<'a, C> for GeneralName<T>
where
    T: Decode<'a, ()>,
{
    fn decode(d: &mut Decoder<'a>, _ctx: &mut C) -> Result<Self, minicbor::decode::Error> {
        // Since the GENERAL_NAMES_TABLE int doesn't exceed max of int8, minicbor will interpret
        // as i8 or u8
        if minicbor::data::Type::U8 == d.datatype()? || minicbor::data::Type::I8 == d.datatype()? {
            let general_name_id = d.i16()?;
            let gn = GENERAL_NAMES_TABLE
                .get_map()
                .get_by_left(&general_name_id)
                .ok_or(minicbor::decode::Error::message(format!(
                    "GeneralName not found, id: {general_name_id}"
                )))?;
            Ok(GeneralName::new(*gn, d.decode()?))
        } else {
            // GeneralName is not type int
            Err(minicbor::decode::Error::message(
                "GeneralName id type invalid",
            ))
        }
    }
}

// -----------------------------------------

#[cfg(test)]
mod test_general_name {
    use std::net::Ipv4Addr;

    use super::*;
    use asn1_rs::oid;

    #[test]
    fn test_encode_general_name_text() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let gn = GeneralName::new(GeneralNamesRegistry::DNSName, "example.com");
        gn.encode(&mut encoder, &mut ())
            .expect("Failed to encode GeneralName");
        // DNSName: 0x02
        // "example.com": 0x6b6578616d706c652e636f6d
        assert_eq!(hex::encode(buffer), "026b6578616d706c652e636f6d");
    }

    #[test]
    fn test_encode_general_name_hw_module_name() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let hw = OtherNameHardwareModuleName::new(
            oid!(2.16.840 .1 .101 .3 .4 .2 .1),
            vec![0x01, 0x02, 0x03, 0x04],
        );
        let gn = GeneralName::new(GeneralNamesRegistry::OtherNameHardwareModuleName, hw);
        gn.encode(&mut encoder, &mut ())
            .expect("Failed to encode GeneralName");
        // OtherNameHardwareModuleName: 0x20
        // [ ~oid, bytes ] = 0x82496086480165030402014401020304
        assert_eq!(hex::encode(buffer), "2082496086480165030402014401020304");
    }

    #[test]
    fn test_encode_general_name_ip() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let ipv4 = Ipv4Addr::new(192, 168, 1, 1);
        let gn = GeneralName::new(GeneralNamesRegistry::IPAddress, ipv4);
        gn.encode(&mut encoder, &mut ())
            .expect("Failed to encode GeneralName");
        // IPAddress: 0x07
        // 192.168.1.1 bytes: 0x44c0a8010
        assert_eq!(hex::encode(buffer), "0744c0a80101");
    }

    #[test]
    fn test_encode_general_name_oid() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let gn = GeneralName::new(
            GeneralNamesRegistry::RegisteredID,
            C509oid::new(oid!(2.16.840 .1 .101 .3 .4 .2 .1)),
        );
        gn.encode(&mut encoder, &mut ())
            .expect("Failed to encode GeneralName");
        // RegisteredID: 0x08
        // oid: 49608648016503040201
        assert_eq!(hex::encode(buffer), "0849608648016503040201");
    }
}
