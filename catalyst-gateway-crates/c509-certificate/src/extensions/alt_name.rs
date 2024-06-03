use crate::cbor_encoder::CborEncoder;
use minicbor::Encoder;
use oid::ObjectIdentifier;

use super::is_critical;

// Define the GeneralNamesRegistry enum
// Section 9.9 https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/
#[allow(unused)]
#[derive(Debug, PartialEq, Clone)]
pub enum GeneralNamesRegistry {
    OtherNameBundleEID = -3,          // eid-structure from RFC 9171
    OtherNameSmtpUTF8Mailbox = -2,    // text
    OtherNameHardwareModuleName = -1, // [ ~oid, bytes ]
    OtherName = 0,                    // [ ~oid, bytes ]
    Rfc822Name = 1,                   // text
    DNSName = 2,                      // text
    DirectoryName = 4,                // Name
    UniformResourceIdentifier = 6,    // text
    IPAddress = 7,                    // bytes
    RegisteredID = 8,                 // ~oid
}

// GeneralNamesRegistryType enum defines a type used in GeneralNamesRegistry
#[allow(unused)]
#[derive(Clone)]
pub(crate) enum GeneralNamesRegistryType {
    String(String),
    Bytes(Vec<u8>),
    Oid(String),
    OidAndBytes(Vec<OtherNameType>),
    Eid(Eid),
}

// Type othername mention in Section 3.3
// Struct of OtherNameType 'otherName + hardwareModuleName' is used in a form
// of [ ~oid, bytes ] which, contain the pair ( hwType, hwSerialNum )
#[derive(Clone)]
pub(crate) struct OtherNameType {
    hw_type: String,
    hw_serial_num: Vec<u8>,
}

impl CborEncoder for Vec<OtherNameType> {
    fn encode(&self, encoder: &mut Encoder<&mut Vec<u8>>) {
        let _unused = encoder.array(self.len() as u64);
        for item in self {
            let oid = match ObjectIdentifier::try_from(item.hw_type.as_str()) {
                Ok(oid) => oid,
                Err(_) => return,
            };
            let oid: Vec<u8> = (&oid).into();
            let _unused = encoder.bytes(&oid);
            let _unused = encoder.bytes(&item.hw_serial_num);
        }
    }
}

// BundleProtocolURISchemeTypes enum defines the type of URI scheme
// URI Scheme can be found in Section 9.7
// https://datatracker.ietf.org/doc/rfc9171/
//
// DTN scheme syntax
//  dtn-uri = "dtn:" ("none" / dtn-hier-part)
//  dtn-hier-part = "//" node-name name-delim demux ; a path-rootless
//  node-name = reg-name
//  name-delim = "/"
//  demux = *VCHAR
// Note that - *VCHAR consists of zero or more visible characters
// Example dtn://node1/service1/data

// IPN scheme syntax
//  ipn-uri = "ipn:" ipn-hier-part
//  ipn-hier-part = node-nbr nbr-delim service-nbr ; a path-rootless
//  node-nbr = 1*DIGIT
//  nbr-delim = "."
//  service-nbr = 1*DIGIT
// Note that 1*DIGIT consists of one or more digits
#[allow(unused)]
#[derive(Clone)]
pub(crate) enum BundleProtocolURISchemeTypes {
    Dtn = 1,
    Ipn = 2,
}

// EID structure define in https://datatracker.ietf.org/doc/rfc9171/
#[derive(Clone)]
pub(crate) struct Eid {
    uri_code: BundleProtocolURISchemeTypes,
    ssp: String,
}

impl CborEncoder for Eid {
    fn encode(&self, encoder: &mut Encoder<&mut Vec<u8>>) {
        let _unused = encoder.u8(self.uri_code.clone() as u8);
        let _unused = encoder.bytes(&self.ssp.as_bytes());
    }
}
// Define the GeneralName struct
#[derive(Clone)]
pub struct GeneralName {
    pub gn_name: GeneralNamesRegistry,
    pub gn_value: GeneralNamesRegistryType,
}

impl CborEncoder for GeneralNamesRegistryType {
    fn encode(&self, encoder: &mut Encoder<&mut Vec<u8>>) {
        match self {
            GeneralNamesRegistryType::String(s) => self.encode_string(encoder, s),
            GeneralNamesRegistryType::Bytes(b) => self.encode_bytes(encoder, b),
            GeneralNamesRegistryType::Oid(s) => self.encode_oid(encoder, s),
            GeneralNamesRegistryType::OidAndBytes(b) => b.encode(encoder),
            GeneralNamesRegistryType::Eid(e) => e.encode(encoder),
        }
    }
}
#[allow(unused)]
impl GeneralName {
    fn encode(&self, encoder: &mut Encoder<&mut Vec<u8>>) {
        self.gn_value.encode(encoder)
    }
}

pub struct AltName {
    pub general_names: Vec<GeneralName>,
    pub critical: bool,
}

impl CborEncoder for AltName {
    fn encode(&self, encoder: &mut Encoder<&mut Vec<u8>>) {
        encode_alt_name(self.general_names.clone(), self.critical, encoder)
    }
}

// Implement the encode_alt_name function
#[allow(unused)]
fn encode_alt_name(b: Vec<GeneralName>, critical: bool, encoder: &mut Encoder<&mut Vec<u8>>) {
    // If subjectAltName contains exactly one dNSName, the array and the int
    // are omitted and extensionValue is the dNSName encoded as a CBOR text string.
    if b.len() == 1 && b[0].gn_name == GeneralNamesRegistry::DNSName {
        let c = is_critical(critical);
        encoder.i16(b[0].gn_name.clone() as i16 * c);
        b[0].gn_value.encode(encoder);
    } else {
        // A pair of ( hwType, hwSerialNum ) is encoded as a CBOR array of two items.
        encoder.array(b.len() as u64 * 2);
        for gn in b {
            encoder.i8(gn.gn_name.clone() as i8).unwrap();
            gn.gn_value.encode(encoder);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use minicbor::Encoder;

    #[test]
    fn test_encode_general_name_only_one_dns() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        let general_name = GeneralName {
            gn_name: GeneralNamesRegistry::DNSName,
            gn_value: GeneralNamesRegistryType::String("example.com".to_string()),
        };
        let alt_name = AltName {
            general_names: vec![general_name],
            critical: false,
        };
        alt_name.encode(&mut encoder);
        assert_eq!(hex::encode(buffer), "026b6578616d706c652e636f6d");
    }

    // [ ~oid, bytes ]
    // }  X509v3 Subject Alternative Name:
    // otherName:
    //     type-id: 1.3.6.1.5.5.7.8.4 (id-on-hardwareModuleName)
    //     value:
    //         hwType: 1.3.6.1.4.1.6175.10.1
    //         hwSerialNum: 01:02:03:04
    // 3, [-1, [h'2B06010401B01F0A01', h'01020304']]
    // 03 82 20 82 49 2B 06 01 04 01 B0 1F 0A 01 44 01 02 03 04
    #[test]
    fn test_encode_general_name_hw_module_name() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        let general_name = GeneralName {
            gn_name: GeneralNamesRegistry::OtherNameHardwareModuleName,
            gn_value: GeneralNamesRegistryType::OidAndBytes(vec![OtherNameType {
                hw_type: "1.3.6.1.4.1.6175.10.1".to_string(),
                hw_serial_num: vec![0x01, 0x02, 0x03, 0x04],
            }]),
        };
        let alt_name = AltName {
            general_names: vec![general_name],
            critical: false,
        };
        alt_name.encode(&mut encoder);
        assert_eq!(hex::encode(buffer), "822081492b06010401b01f0a014401020304");
    }

    #[test]
    fn test_encode_general_name_eid() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        let general_name = GeneralName {
            gn_name: GeneralNamesRegistry::OtherNameBundleEID,
            gn_value: GeneralNamesRegistryType::Eid(Eid {
                uri_code: BundleProtocolURISchemeTypes::Dtn,
                ssp: "dtn://node1/service1/data".to_string(),
            }),
        };
        let alt_name = AltName {
            general_names: vec![general_name],
            critical: false,
        };
        alt_name.encode(&mut encoder);
        assert_eq!(
            hex::encode(buffer),
            "822201581964746e3a2f2f6e6f6465312f73657276696365312f64617461"
        );
    }
}
