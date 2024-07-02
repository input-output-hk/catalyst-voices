//! C509 General Name

use asn1_rs::Oid;
use minicbor::{
    encode::{self, Write},
    Decode, Decoder, Encode, Encoder,
};

use crate::c509_oid::C509oid;

// FIXME - Revisit visibility

/// Enum of GeneralName and its type in GeneralNamesRegistry table in C509 Section 9.9.
#[allow(dead_code)]
#[derive(Debug, PartialEq, Clone, Eq, Hash)]
pub enum GeneralNamesRegistry {
    // FIXME - Implement the rest of the GeneralNamesRegistry
    OtherNameBundleEID, // EID
    OtherNameSmtpUTF8Mailbox(String),
    OtherNameHardwareModuleName(OtherNameHardwareModuleName),
    OtherName(OtherNameHardwareModuleName),
    Rfc822Name(String),
    DNSName(String),
    DirectoryName, // Name
    UniformResourceIdentifier(String),
    IPAddress(Vec<u8>),
    RegisteredID(C509oid),
}

impl GeneralNamesRegistry {
    /// Get the value integer associated with the GeneralName.
    pub(crate) fn get_int(&self) -> i8 {
        match self {
            GeneralNamesRegistry::OtherNameBundleEID => -3,
            GeneralNamesRegistry::OtherNameSmtpUTF8Mailbox(_) => -2,
            GeneralNamesRegistry::OtherNameHardwareModuleName(_) => -1,
            GeneralNamesRegistry::OtherName(_) => 0,
            GeneralNamesRegistry::Rfc822Name(_) => 1,
            GeneralNamesRegistry::DNSName(_) => 2,
            GeneralNamesRegistry::DirectoryName => 4,
            GeneralNamesRegistry::UniformResourceIdentifier(_) => 6,
            GeneralNamesRegistry::IPAddress(_) => 7,
            GeneralNamesRegistry::RegisteredID(_) => 8,
        }
    }
}
impl Encode<()> for GeneralNamesRegistry {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        match self {
            GeneralNamesRegistry::OtherNameHardwareModuleName(hm) => {
                OtherNameHardwareModuleName::encode(hm, e, ctx)?;
            },
            GeneralNamesRegistry::OtherName(hm) => {
                OtherNameHardwareModuleName::encode(hm, e, ctx)?;
            },
            GeneralNamesRegistry::IPAddress(ip) => {
                e.bytes(ip)?;
            },
            GeneralNamesRegistry::RegisteredID(id) => {
                C509oid::encode(id, e, ctx)?;
            },
            GeneralNamesRegistry::OtherNameSmtpUTF8Mailbox(s)
            | GeneralNamesRegistry::UniformResourceIdentifier(s)
            | GeneralNamesRegistry::Rfc822Name(s)
            | GeneralNamesRegistry::DNSName(s) => {
                s.encode(e, ctx)?;
            },
            _ => {},
        };
        Ok(())
    }
}

impl<'a> Decode<'a, ()> for GeneralNamesRegistry {
    fn decode(d: &mut Decoder<'a>, ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
        match d.i8()? {
            -2 => Ok(GeneralNamesRegistry::OtherNameSmtpUTF8Mailbox(
                d.str()?.to_string(),
            )),
            -1 => Ok(GeneralNamesRegistry::OtherNameHardwareModuleName(
                OtherNameHardwareModuleName::decode(d, ctx)?,
            )),
            0 => Ok(GeneralNamesRegistry::OtherName(
                OtherNameHardwareModuleName::decode(d, ctx)?,
            )),
            1 => Ok(GeneralNamesRegistry::Rfc822Name(d.str()?.to_string())),
            2 => Ok(GeneralNamesRegistry::DNSName(d.str()?.to_string())),
            6 => Ok(GeneralNamesRegistry::UniformResourceIdentifier(
                d.str()?.to_string(),
            )),
            7 => Ok(GeneralNamesRegistry::IPAddress(d.bytes()?.to_vec())),
            8 => Ok(GeneralNamesRegistry::RegisteredID(C509oid::decode(d, ctx)?)),
            _ => Err(minicbor::decode::Error::message(
                "GeneralName not supported",
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

// -----------------------------------------

/// Represent the hardwareModuleName type of otherName.
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

// -----------------------------------------

/// A struct represents an array of GeneralName.
/// GeneralNames = [ + GeneralName ]
///
/// # Fields
/// * `names` - The array of GeneralName.
#[derive(Debug, Clone, PartialEq)]
pub struct GeneralNames {
    general_names: Vec<GeneralName>,
}

#[allow(dead_code)]
impl GeneralNames {
    /// Create a new empty instance of GeneralNames.
    pub(crate) fn new() -> Self {
        Self {
            general_names: Vec::new(),
        }
    }

    /// Add a new GeneralName to the GeneralNames instance.
    pub(crate) fn add(&mut self, gn: GeneralName) {
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
        e.array(self.general_names.len() as u64)?;
        for gn in &self.general_names {
            gn.encode(e, ctx)?;
        }
        Ok(())
    }
}

impl<'a> Decode<'a, ()> for GeneralNames {
    fn decode(d: &mut Decoder<'a>, ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
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

// -----------------------------------------

/// A struct represents a GeneralName.
/// GeneralName = ( GeneralNameType : int, GeneralNameValue : any )
///
/// # Fields
/// * `gn` - The enum of registered GeneralName and its value.
#[derive(Debug, Clone, PartialEq)]
pub struct GeneralName {
    gn: GeneralNamesRegistry,
}

impl GeneralName {
    /// Create a new instance of GeneralName.
    pub(crate) fn new(gn: GeneralNamesRegistry) -> Self {
        Self { gn }
    }

    #[allow(dead_code)]
    pub(crate) fn get_gn(&self) -> &GeneralNamesRegistry {
        &self.gn
    }
}

impl Encode<()> for GeneralName {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        e.i8(self.gn.get_int())?;
        self.gn.encode(e, ctx)?;
        Ok(())
    }
}

impl<'a> Decode<'a, ()> for GeneralName {
    fn decode(d: &mut Decoder<'a>, ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
        if minicbor::data::Type::U8 == d.datatype()? || minicbor::data::Type::I8 == d.datatype()? {
            Ok(GeneralName::new(GeneralNamesRegistry::decode(d, ctx)?))
        } else {
            // GeneralName is not type int
            Err(minicbor::decode::Error::message(
                "GeneralName id type invalid, expected int",
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
    fn test_encode_decode_gn_text() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let gn = GeneralName::new(GeneralNamesRegistry::DNSName("example.com".to_string()));
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
        let gn = GeneralName::new(GeneralNamesRegistry::OtherNameHardwareModuleName(hw));
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
        let gn = GeneralName::new(GeneralNamesRegistry::IPAddress(ipv4.octets().to_vec()));

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

        let gn = GeneralName::new(GeneralNamesRegistry::RegisteredID(C509oid::new(oid!(
            2.16.840 .1 .101 .3 .4 .2 .1
        ))));
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
    fn test_encode_decode_gns() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let mut gns = GeneralNames::new();
        gns.add(GeneralName::new(GeneralNamesRegistry::DNSName(
            "example.com".to_string(),
        )));
        gns.add(GeneralName::new(
            GeneralNamesRegistry::OtherNameHardwareModuleName(OtherNameHardwareModuleName::new(
                oid!(2.16.840 .1 .101 .3 .4 .2 .1),
                vec![0x01, 0x02, 0x03, 0x04],
            )),
        ));
        gns.add(GeneralName::new(GeneralNamesRegistry::IPAddress(
            Ipv4Addr::new(192, 168, 1, 1).octets().to_vec(),
        )));
        gns.add(GeneralName::new(GeneralNamesRegistry::RegisteredID(
            C509oid::new(oid!(2.16.840 .1 .101 .3 .4 .2 .1)),
        )));
        gns.encode(&mut encoder, &mut ())
            .expect("Failed to encode GeneralNames");
        assert_eq!(hex::encode(buffer.clone()), "84026b6578616d706c652e636f6d20824960864801650304020144010203040744c0a801010849608648016503040201");

        let mut decoder = Decoder::new(&buffer);
        let gns_decoded =
            GeneralNames::decode(&mut decoder, &mut ()).expect("Failed to decode GeneralName");
        assert_eq!(gns_decoded, gns);
    }
}
