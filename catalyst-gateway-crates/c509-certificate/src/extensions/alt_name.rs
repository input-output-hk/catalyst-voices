use crate::cbor_encoder::CborEncoder;
use minicbor::Encoder;

use super::is_critical;

// ---------------------------------------------------

// Define the GeneralNamesRegistry enum
// Ref - Section 9.9 C509 General Names Registry
#[allow(unused)]
#[derive(Debug, PartialEq, Clone, Copy)]
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

// ---------------------------------------------------

// Type othername mention in Section 3.3
// Struct of OtherNameType 'otherName + hardwareModuleName' is used in a form
// of [ ~oid, bytes ] which, contain the pair ( hwType, hwSerialNum )
#[derive(Clone)]
pub struct OtherNameType {
    pub hw_type: String,
    pub hw_serial_num: Vec<u8>,
}

impl CborEncoder for OtherNameType {
    fn encode(&self, encoder: &mut Encoder<&mut Vec<u8>>) {
        // 2 items in OtherNameType
        let _unused = encoder.array(2);
        self.encode_oid(encoder, self.hw_type.as_str());
        let _unused = encoder.bytes(&self.hw_serial_num);
    }
}

// ---------------------------------------------------

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
pub struct Eid {
    pub uri_code: BundleProtocolURISchemeTypes,
    pub ssp: String,
}

impl CborEncoder for Eid {
    fn encode(&self, encoder: &mut Encoder<&mut Vec<u8>>) {
        // 2 items in Eid
        let _unused = encoder.array(2);
        let _unused = encoder.u8(self.uri_code.clone() as u8);
        let _unused = encoder.bytes(&self.ssp.as_bytes());
    }
}

// ---------------------------------------------------

// GeneralNamesRegistryType enum defines a type used in GeneralNamesRegistry
#[allow(unused)]
#[derive(Clone)]
pub(crate) enum GeneralNamesRegistryType {
    Text(String),
    Bytes(Vec<u8>),
    Oid(String),
    OidAndBytes(OtherNameType),
    Eid(Eid),
}

// Define the GeneralName struct
// ( GeneralNameType : int, GeneralNameValue : any )
#[derive(Clone)]
pub struct GeneralName {
    pub gn_name: GeneralNamesRegistry,
    pub gn_value: GeneralNamesRegistryType,
    pub critical: bool,
}

impl CborEncoder for GeneralNamesRegistryType {
    fn encode(&self, encoder: &mut Encoder<&mut Vec<u8>>) {
        match self {
            GeneralNamesRegistryType::Text(s) => {
                let _unused = encoder.str(s);
            }
            GeneralNamesRegistryType::Bytes(b) => {
                let _unused = encoder.bytes(b);
            }
            GeneralNamesRegistryType::Oid(s) => {
                self.encode_oid(encoder, s);
            }
            GeneralNamesRegistryType::OidAndBytes(b) => {
                b.encode(encoder);
            }
            GeneralNamesRegistryType::Eid(e) => {
                e.encode(encoder);
            }
        }
    }
}

impl CborEncoder for GeneralName {
    fn encode(&self, encoder: &mut Encoder<&mut Vec<u8>>) {
        let c = is_critical(self.critical);
        let _unused = encoder.i16(self.gn_name as i16 * c);
        self.gn_value.encode(encoder);
    }
}

// ---------------------------------------------------

// Define the AltName struct for Alternative Name
// GeneralName = ( GeneralNameType : int, GeneralNameValue : any )
// GeneralNames = [ + GeneralName ]
// SubjectAltName = GeneralNames / text
pub type AltName = Vec<GeneralName>;

impl CborEncoder for AltName {
    fn encode(&self, encoder: &mut Encoder<&mut Vec<u8>>) {
        encode_alt_name(self.clone(), encoder)
    }
}

// Implement the encoding for alternative name
fn encode_alt_name(alt_name: AltName, encoder: &mut Encoder<&mut Vec<u8>>) {
    // If subjectAltName contains exactly one dNSName, the array and the int
    // are omitted and extensionValue is the dNSName encoded as a CBOR text string.
    if alt_name.len() == 1 && alt_name[0].gn_name == GeneralNamesRegistry::DNSName {
        alt_name[0].encode(encoder);
    } else {
        // Each general name in alt name comes in pairs
        let _unused = encoder.array(alt_name.len() as u64 * 2);
        for gn in alt_name {
            gn.encode(encoder);
        }
    }
}

// ---------------------------------------------------

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
            gn_value: GeneralNamesRegistryType::Text("example.com".to_string()),
            critical: false,
        };
        let alt_name: AltName = vec![general_name];
        alt_name.encode(&mut encoder);
        // [2, example.com]
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
            gn_value: GeneralNamesRegistryType::OidAndBytes(OtherNameType {
                hw_type: "1.3.6.1.4.1.6175.10.1".to_string(),
                hw_serial_num: vec![0x01, 0x02, 0x03, 0x04],
            }),
            critical: false,
        };
        let alt_name: AltName = vec![general_name];
        alt_name.encode(&mut encoder);
        // [-1, ["1.3.6.1.4.1.6175.10.1, 0x01, 0x02, 0x03, 0x04]]
        // 82 -> 2 items in array
        // 20 -> OtherNameHardwareModuleName (-1)
        // 82 -> 2 items in array
        assert_eq!(hex::encode(buffer), "822082492b06010401b01f0a014401020304");
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
            critical: false,
        };
        let alt_name: AltName = vec![general_name];
        alt_name.encode(&mut encoder);
        // [-3, [1, dtn://node1/service1/data]]
        // 82 -> 2 items in array
        // 22 -> OtherNameBundleEID (-3)
        // 82 -> 2 items in array
        // 01 -> Dtn
        assert_eq!(
            hex::encode(buffer),
            "82228201581964746e3a2f2f6e6f6465312f73657276696365312f64617461"
        );
    }

    #[test]
    fn test_encode_multiple_general_names() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        let general_name_1 = GeneralName {
            gn_name: GeneralNamesRegistry::DNSName,
            gn_value: GeneralNamesRegistryType::Text("example.com".to_string()),
            critical: false,
        };
        let general_name_2 = GeneralName {
            gn_name: GeneralNamesRegistry::Rfc822Name,
            gn_value: GeneralNamesRegistryType::Text("test".to_string()),
            critical: false,
        };

        let alt_name: AltName = vec![general_name_1, general_name_2];
        alt_name.encode(&mut encoder);
        // [2, example.com, 1, test]
        // 84 -> 4 items in array
        // 02 -> DNSName
        // 6b 65 78 61 6d 70 6c 65 2e 63 6f 6d -> example.com
        // 01 -> Rfc822Name
        // 64 74 65 73 74 -> test
        assert_eq!(
            hex::encode(buffer),
            "84026b6578616d706c652e636f6d016474657374"
        );
    }
}
