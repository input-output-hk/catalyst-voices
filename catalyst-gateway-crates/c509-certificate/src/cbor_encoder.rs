use hex::FromHexError;
use minicbor::Encoder;
use oid::ObjectIdentifier;
use regex::Regex;
use thiserror::Error;

use crate::c509_enum::AttributesRegistry;

pub(crate) trait CborEncoder {
    fn encode(&self, encoder: &mut Encoder<&mut Vec<u8>>);

    fn encode_string(&self, encoder: &mut Encoder<&mut Vec<u8>>, s: &str) {
        let _unused = encoder.str(s);
    }

    fn encode_bytes(&self, encoder: &mut Encoder<&mut Vec<u8>>, b: &[u8]) {
        let _unused = encoder.bytes(b);
    }

    fn encode_oid(&self, encoder: &mut Encoder<&mut Vec<u8>>, s: &str) {
        let oid = match ObjectIdentifier::try_from(s) {
            Ok(oid) => oid,
            Err(_) => return,
        };
        let oid: Vec<u8> = (&oid).into();
        let _unused = encoder.bytes(&oid);
    }
}

// ---------------------------------------------------

#[allow(unused)]
pub enum UnwrappedBiguint {
    U64Value(u64),
}

impl CborEncoder for UnwrappedBiguint {
    fn encode(&self, encoder: &mut Encoder<&mut Vec<u8>>) {
        match self {
            UnwrappedBiguint::U64Value(u) => {
                // Convert the integer to bytes
                let bytes = u.to_be_bytes();
                // Trim leading zeros
                let significant_bytes = bytes
                    .iter()
                    .skip_while(|&&b| b == 0)
                    .cloned()
                    .collect::<Vec<u8>>();

                // Encode the significant bytes as a byte string in CBOR format
                // FIXME - Is it better to just use encoder.bytes(&significant_bytes)?
                self.encode_bytes(encoder, &significant_bytes);
            },
        }
    }
}

// ---------------------------------------------------

const NOEXPDATE: u64 = 99991231235959;
pub type Time = u64;

impl CborEncoder for Time {
    fn encode(&self, encoder: &mut Encoder<&mut Vec<u8>>) {
        // The value "99991231235959Z" (no expiration date) is encoded as CBOR null
        // Also add an option for using 0 as no expiration date
        if *self == 0 || *self == NOEXPDATE {
            let _unused = encoder.null();
        } else {
            let _unused = encoder.u64(*self);
        }
    }
}

// ---------------------------------------------------

type Name = Vec<RelativeDistinguishedName>;

pub(crate) struct RelativeDistinguishedName {
    name: AttributesRegistry,
    value: AttributeRegistryValue,
}

#[allow(unused)]
#[derive(Debug)]
enum StringType {
    Utf8String,
}

#[allow(unused)]
struct AttributeRegistryValue {
    str_type: StringType,
    str_value: String,
}

impl CborEncoder for Name {
    /// Encode type Name
    /// Since it is currently support only natively signed C509 certificates,
    /// all text strings are UTF-8 encoded and all attributeType SHALL be non-negative
    fn encode(&self, encoder: &mut Encoder<&mut Vec<u8>>) {
        // If type Name contain single attribute common-name
        if self.len() == 1 && self[0].name == AttributesRegistry::CommonName {
            let _unused = encode_common_name_cn(&self[0].value.str_value, encoder);
        } else {
            let _unused = encoder.array(self.len() as u64 * 2);
            // a (CBOR int, CBOR text string) pair,
            for data in self {
                let _unused = encoder.u8(data.name as u8);
                let _unused = encoder.str(&data.value.str_value);
            }
        }
    }
}

#[derive(Error, Debug)]
enum Error {
    #[error("Regex creation error: {0}")]
    RegexCreationError(#[from] regex::Error),
    #[error("Hex decoding error: {0}")]
    HexDecodingError(#[from] FromHexError),
}

#[allow(unused)]
fn encode_common_name_cn(
    name: &str, encoder: &mut minicbor::Encoder<&mut Vec<u8>>,
) -> Result<(), Error> {
    let hex_regex = Regex::new(r"^[0-9a-fA-F]+$").map_err(Error::from)?;
    let eui64_regex = Regex::new(r"^([0-9A-Fa-f]{2}-){7}[0-9A-Fa-f]{2}$").map_err(Error::from)?;
    let mac_eui64_regex =
        Regex::new(r"^([0-9A-Fa-f]{2}-){3}FF-FE-([0-9A-Fa-f]{2}-){2}[0-9A-Fa-f]{2}$")
            .map_err(Error::from)?;

    if name.contains('-') {
        let clean_name = name.replace("-", "");
        let decoded_bytes = hex::decode(&clean_name).map_err(|e| Error::HexDecodingError(e))?;

        if hex_regex.is_match(name) && name.len() % 2 == 0 {
            let data = [&[0x00], &decoded_bytes[..]].concat();
            encoder.bytes(&data);
        } else if mac_eui64_regex.is_match(name) {
            let data: Vec<u8> = [&[0x01], &decoded_bytes[..3], &decoded_bytes[5..]].concat(); // Skip FF-FE bytes
            encoder.bytes(&data);
        } else if eui64_regex.is_match(name) {
            let data = [&[0x01], &decoded_bytes[..]].concat();
            encoder.bytes(&data);
        }
    } else {
        encoder.str(name);
    }

    Ok(())
}

#[cfg(test)]
mod test_cbor_encoder {
    use super::*;

    // Test reference https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/
    #[test]
    fn test_cbor_encode_biguint() {
        let mut buffer: Vec<u8> = Vec::new();
        let mut encoder: Encoder<&mut Vec<u8>> = Encoder::new(&mut buffer);
        let number = UnwrappedBiguint::U64Value(128269);
        number.encode(&mut encoder);
        let result = hex::encode(buffer);
        assert_eq!(result, "4301f50d");
    }

    #[test]
    fn test_cbor_encode_time() {
        let mut buffer: Vec<u8> = Vec::new();
        let mut encoder: Encoder<&mut Vec<u8>> = Encoder::new(&mut buffer);
        let time: Time = 1672531200;
        time.encode(&mut encoder);
        let exp_time: Time = 99991231235959;
        exp_time.encode(&mut encoder);
        assert_eq!(hex::encode(buffer), "1a63b0cd00f6");
    }

    #[test]
    fn test_cbor_encode_type_name_cn() {
        let mut buffer: Vec<u8> = Vec::new();
        let mut encoder: Encoder<&mut Vec<u8>> = Encoder::new(&mut buffer);
        let name1: Name = vec![RelativeDistinguishedName {
            name: AttributesRegistry::CommonName,
            value: AttributeRegistryValue {
                str_type: StringType::Utf8String,
                str_value: "RFC test CA".to_string(),
            },
        }];
        name1.encode(&mut encoder);

        let name2: Name = vec![RelativeDistinguishedName {
            name: AttributesRegistry::CommonName,
            value: AttributeRegistryValue {
                str_type: StringType::Utf8String,
                str_value: "01-23-45-FF-FE-67-89-AB".to_string(),
            },
        }];
        name2.encode(&mut encoder);

        assert_eq!(
            hex::encode(buffer),
            "6b524643207465737420434147010123456789ab"
        );
    }

    #[test]
    fn test_cbor_encode_type_name() {
        let mut buffer: Vec<u8> = Vec::new();
        let mut encoder: Encoder<&mut Vec<u8>> = Encoder::new(&mut buffer);

        // Issuer: C=US, ST=CA, O=Example Inc, OU=certification, CN=802.1AR CA
        let name: Name = vec![
            RelativeDistinguishedName {
                name: AttributesRegistry::Country,
                value: AttributeRegistryValue {
                    str_type: StringType::Utf8String,
                    str_value: "US".to_string(),
                },
            },
            RelativeDistinguishedName {
                name: AttributesRegistry::StateOrProvince,
                value: AttributeRegistryValue {
                    str_type: StringType::Utf8String,
                    str_value: "CA".to_string(),
                },
            },
            RelativeDistinguishedName {
                name: AttributesRegistry::Organization,
                value: AttributeRegistryValue {
                    str_type: StringType::Utf8String,
                    str_value: "Example Inc".to_string(),
                },
            },
            RelativeDistinguishedName {
                name: AttributesRegistry::OrganizationUnit,
                value: AttributeRegistryValue {
                    str_type: StringType::Utf8String,
                    str_value: "certification".to_string(),
                },
            },
            RelativeDistinguishedName {
                name: AttributesRegistry::CommonName,
                value: AttributeRegistryValue {
                    str_type: StringType::Utf8String,
                    str_value: "802.1AR CA".to_string(),
                },
            },
        ];
        name.encode(&mut encoder);
        assert_eq!(
            hex::encode(buffer),
            "8a0462555306624341086b4578616d706c6520496e63096d63657274696669636174696f6e016a3830322e314152204341"
        );
    }
}
