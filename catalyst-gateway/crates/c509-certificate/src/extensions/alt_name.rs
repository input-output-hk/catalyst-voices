use minicbor::Encoder;
use oid::prelude::*;

use super::is_critical;

// Define the GeneralNames enum
#[allow(unused)]
#[derive(Debug, PartialEq, Clone)]
enum GeneralNames {
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

#[allow(unused)]
#[derive(Clone)]
pub(crate) enum GeneralNamesType {
    String(String),
    Bytes(Vec<u8>),
    Oid(String),
    OidAndBytes(Vec<OtherNameType>),
}

#[derive(Clone)]
// When 'otherName + hardwareModuleName' is used, then [ ~oid, bytes ] is
// used to contain the pair ( hwType, hwSerialNum )
pub(crate) struct OtherNameType {
    hw_type: String,
    hw_serial_num: Vec<u8>,
}

// Define the GeneralName struct
#[derive(Clone)]
pub(crate) struct GeneralName {
    gn_name: GeneralNames,
    gn_value: GeneralNamesType,
}

impl GeneralNamesType {
    fn encode(&self, encoder: &mut Encoder<&mut Vec<u8>>) {
        match self {
            GeneralNamesType::String(s) => {
                encoder.str(s).unwrap();
            },
            GeneralNamesType::Bytes(b) => {
                encoder.bytes(b).unwrap();
            },
            GeneralNamesType::Oid(s) => {
                let oid = ObjectIdentifier::try_from(s.as_str()).unwrap();
                let oid: Vec<u8> = (&oid).into();
                encoder.bytes(&oid).unwrap();
            },
            GeneralNamesType::OidAndBytes(b) => {
                encoder.array(b.len() as u64).unwrap();
                for x in b {
                    let oid = ObjectIdentifier::try_from(x.hw_type.clone()).unwrap();
                    let oid: Vec<u8> = (&oid).into();
                    encoder.bytes(&oid).unwrap();
                    encoder.bytes(&x.hw_serial_num).unwrap();
                }
            },
        }
    }
}

#[allow(unused)]
impl GeneralName {
    fn encode(&self, encoder: &mut Encoder<&mut Vec<u8>>) {
        self.gn_value.encode(encoder)
    }
}

#[allow(unused)]
// Implement the encode_alt_name function
fn encode_alt_name(b: Vec<GeneralName>, critical: bool, encoder: &mut Encoder<&mut Vec<u8>>) {
    // If subjectAltName contains exactly one dNSName, the array and the int
    // are omitted and extensionValue is the dNSName encoded as a CBOR text string.
    if b.len() == 1 && b[0].gn_name == GeneralNames::DNSName {
        let c = is_critical(critical);
        encoder.i16(b[0].gn_name.clone() as i16 * c);
        b[0].gn_value.encode(encoder);
    } else {
        encoder.array(b.len() as u64);
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
            gn_name: GeneralNames::DNSName,
            gn_value: GeneralNamesType::String("example.com".to_string()),
        };
        encode_alt_name(vec![general_name], false, &mut encoder);
        // FIXME - Recheck this section 3.3.1 https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/
        println!("{:?}", hex::encode(buffer));
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
            gn_name: GeneralNames::OtherNameHardwareModuleName,
            gn_value: GeneralNamesType::OidAndBytes(vec![OtherNameType {
                hw_type: "1.3.6.1.4.1.6175.10.1".to_string(),
                hw_serial_num: vec![0x01, 0x02, 0x03, 0x04],
            }]),
        };
        encode_alt_name(vec![general_name], false, &mut encoder);
        println!("{:?}", hex::encode(buffer));
    }
}
