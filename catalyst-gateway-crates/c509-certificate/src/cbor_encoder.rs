//! This module provides CBOR encoding functionalities for various types.
//!
//! The main trait [`CborEncoder`] defines methods for encoding data into CBOR format.
//! The module also includes implementations for different special types such as
//! `UnwrappedBiguint`, `Name`, and `Time` that is used in C509 certificate.
//!
//! Please refer to the [c509-certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/) for more information.
//! Please refer to the [CDDL Wrapping](https://datatracker.ietf.org/doc/html/rfc8610#section-3.7) for unwrapped types.
use hex::FromHexError;
use minicbor::Encoder;
use oid::ObjectIdentifier;
use regex::Regex;
use thiserror::Error;

use crate::c509_enum::AttributesRegistry;

pub(crate) trait CborEncoder {
    /// Encodes the current instance using the provided CBOR encoder.
    ///
    /// # Arguments
    ///
    /// * `encoder` - A mutable reference to a `minicbor::Encoder` to encode the
    ///   extensions into.
    fn encode(&self, encoder: &mut Encoder<&mut Vec<u8>>);

    /// Encodes an Object Identifier (OID) using the provided CBOR encoder.
    ///
    /// # Arguments
    ///
    /// * `encoder` - A mutable reference to a `minicbor::Encoder` to encode the
    ///   extensions into.
    /// * `s` - The string representation of the OID to encode.
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

/// Represents an unwrapped unsigned 64-bit integer.
#[allow(unused)]
pub enum UnwrappedBiguint {
    U64Value(u64),
}

/// Encodes the `UnwrappedBiguint` using the provided CBOR encoder.
///
/// # Arguments
///
/// * `encoder` - The CBOR encoder to use for encoding the data.
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
                let _unused = encoder.bytes(&significant_bytes);
            },
        }
    }
}

// ---------------------------------------------------

/// A constant representing no expiration date in the format `99991231235959`.
const NOEXPDATE: u64 = 99991231235959;
/// Represents time as a 64-bit unsigned integer.
pub type Time = u64;

impl CborEncoder for Time {
    /// Encodes the `Time` using the provided CBOR encoder.
    /// The value `99991231235959` (no expiration date) or 0 are encoded as CBOR null.
    ///
    /// # Arguments
    ///
    /// * `encoder` - A mutable reference to a `minicbor::Encoder` to encode the
    ///   extensions into.
    fn encode(&self, encoder: &mut Encoder<&mut Vec<u8>>) {
        if *self == 0 || *self == NOEXPDATE {
            let _unused = encoder.null();
        } else {
            let _unused = encoder.u64(*self);
        }
    }
}

// ---------------------------------------------------
/// Represents a special type Name, which is a vector of `RelativeDistinguishedName`.
pub type Name = Vec<RelativeDistinguishedName>;

/// Represents a relative distinguished name.
/// A relative distinguished name is a set of attributes that uniquely identify an entity.
///
/// # Fields
///
/// * `name` - The attribute type, represented as an `AttributesRegistry`.
/// * `value` - The value of the attribute, represented as an `AttributeRegistryValue`.
pub struct RelativeDistinguishedName {
    pub name: AttributesRegistry,
    pub value: AttributeRegistryValue,
}

/// Represents the value of an attribute in the registry.
///
/// # Fields
///
/// * `str_type` - The type of the string, represented as a `StringType`.
/// * `str_value` - The value of the string.
#[allow(unused)]
pub struct AttributeRegistryValue {
    pub str_type: StringType,
    pub str_value: String,
}

/// Enum of string types that are used in C509 certificate.
#[allow(unused)]
#[derive(Debug)]
pub enum StringType {
    Utf8String,
}

impl CborEncoder for Name {
    /// Encodes a `Name` using the provided CBOR encoder.
    ///
    /// Since it currently supports only natively signed C509 certificates,
    /// all text strings are UTF-8 encoded and all attribute types SHALL be non-negative.
    ///
    /// # Arguments
    ///
    /// * `encoder` - A mutable reference to a `minicbor::Encoder` to encode the
    ///   extensions into.
    fn encode(&self, encoder: &mut Encoder<&mut Vec<u8>>) {
        // If type Name contain single attribute equal to common-name
        if self.len() == 1 && self[0].name == AttributesRegistry::CommonName {
            let _unused = encode_common_name_cn(&self[0].value.str_value, encoder);
        } else {
            let _unused = encoder.array(self.len() as u64 * 2);
            // A (CBOR int, CBOR text string) pair,
            for data in self {
                let _unused = encoder.u8(data.name as u8);
                let _unused = encoder.str(&data.value.str_value);
            }
        }
    }
}

/// Represents possible errors during encoding.
#[derive(Error, Debug)]
enum Error {
    #[error("Regex creation error: {0}")]
    RegexCreationError(#[from] regex::Error),
    #[error("Hex decoding error: {0}")]
    HexDecodingError(#[from] FromHexError),
}

/// Encodes a common name (CN) using the provided CBOR encoder.
/// Please refer to the [C509 Certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/) Section 3.1 Message Fields for more information.
///
/// # Arguments
///
/// * `name` - The common name to encode.
/// * `encoder` - A mutable reference to a `minicbor::Encoder` to encode the extensions
///   into.
///
/// # Errors
///
/// Returns an `Error` if the regex creation or hex decoding fails.
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
        assert_eq!(hex::encode(buffer), "4301f50d");
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
