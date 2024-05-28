use hex::FromHexError;
use minicbor::Encoder;
use regex::Regex;
use thiserror::Error;

use crate::c509_enum::AttributesRegistry;

#[allow(unused)]
/// Encode type ~biguint
pub(crate) fn cbor_encode_biguint(integer: u64, encoder: &mut Encoder<&mut Vec<u8>>) {
    // Convert the integer to bytes
    let bytes = integer.to_be_bytes();
    // Trim leading zeros
    let significant_bytes = bytes
        .iter()
        .skip_while(|&&b| b == 0)
        .cloned()
        .collect::<Vec<u8>>();

    // Encode the significant bytes as a byte string in CBOR format
    encoder.bytes(&significant_bytes);
}
// ---------------------------------------------------
#[allow(unused)]
pub(crate) fn cbor_encode_time(time: u32, encoder: &mut Encoder<&mut Vec<u8>>) {
    // The value "99991231235959Z" (no expiration date) is encoded as CBOR null
    // Make it easy to implemented using 0 instead
    if time == 0 {
        encoder.null();
    } else {
        encoder.u32(time);
    }
}

// ---------------------------------------------------
pub(crate) struct RelativeDistinguishedName {
    name: AttributesRegistry,
    value: AttributeRegistryValue,
}

#[allow(unused)]
#[derive(Debug)]
enum StringType {
    Utf8String,
    PrintableString,
    IA5String,
}
struct AttributeRegistryValue {
    str_type: StringType,
    str_value: String,
}

impl StringType {
    fn get_sign(&self) -> i8 {
        match self {
            // Negative for printable string
            StringType::PrintableString => -1,
            // Positive for Utf8
            StringType::Utf8String | StringType::IA5String => 1,
        }
    }
}

#[allow(unused)]
/// Encode type Name
pub(crate) fn cbor_encode_type_name(
    b: Vec<RelativeDistinguishedName>, encoder: &mut Encoder<&mut Vec<u8>>,
) {
    // If type Name contain single attribute common-name
    if b.len() == 1 && b[0].name == AttributesRegistry::CommonName {
        encode_common_name_cn(&b[0].value.str_value, encoder);
    } else {
        encoder.array(b.len() as u64 * 2);
        for data in b {
            let sign = data.value.str_type.get_sign();
            encoder.i8(data.name as i8 * sign);
            encoder.str(&data.value.str_value);
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
        let integer = 128269;
        cbor_encode_biguint(integer, &mut encoder);
        let result = hex::encode(buffer);
        assert_eq!(result, "4301f50d");
    }

    #[test]
    fn test_cbor_encode_type_name_cn() {
        let mut buffer: Vec<u8> = Vec::new();
        let mut encoder: Encoder<&mut Vec<u8>> = Encoder::new(&mut buffer);
        cbor_encode_type_name(
            vec![RelativeDistinguishedName {
                name: AttributesRegistry::CommonName,
                value: AttributeRegistryValue {
                    str_type: StringType::Utf8String,
                    str_value: "RFC test CA".to_string(),
                },
            }],
            &mut encoder,
        );

        cbor_encode_type_name(
            vec![RelativeDistinguishedName {
                name: AttributesRegistry::CommonName,
                value: AttributeRegistryValue {
                    str_type: StringType::Utf8String,
                    str_value: "01-23-45-FF-FE-67-89-AB".to_string(),
                },
            }],
            &mut encoder,
        );
        assert_eq!(
            hex::encode(buffer),
            "6b524643207465737420434147010123456789ab"
        );
    }

    #[test]
    fn test_cbor_encode_time() {
        let mut buffer: Vec<u8> = Vec::new();
        let mut encoder: Encoder<&mut Vec<u8>> = Encoder::new(&mut buffer);
        let time = 1672531200;
        cbor_encode_time(time, &mut encoder);
        cbor_encode_time(0, &mut encoder);
        assert_eq!(
            hex::encode(buffer),
            "1a63b0cd00f6"
        );
    }

    #[test]
    fn test_cbor_encode_type_name() {
        let mut buffer: Vec<u8> = Vec::new();
        let mut encoder: Encoder<&mut Vec<u8>> = Encoder::new(&mut buffer);

        // Issuer: C=US, ST=CA, O=Example Inc, OU=certification, CN=802.1AR CA
        cbor_encode_type_name(
            vec![
                RelativeDistinguishedName {
                    name: AttributesRegistry::Country,
                    value: AttributeRegistryValue {
                        str_type: StringType::PrintableString,
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
            ],
            &mut encoder,
        );
        assert_eq!(
            hex::encode(buffer),
            "8a2362555306624341086b4578616d706c6520496e63096d63657274696669636174696f6e016a3830322e314152204341"
        );
    }
}
