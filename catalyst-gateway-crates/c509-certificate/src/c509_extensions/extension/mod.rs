//! C509 Extension use to construct an Extensions message field for C509 Certificate.

mod data;
use std::{fmt::Debug, str::FromStr};

use asn1_rs::Oid;
use data::{get_extension_type_from_int, get_oid_from_int, EXTENSIONS_LOOKUP};
use minicbor::{encode::Write, Decode, Decoder, Encode, Encoder};
use serde::{Deserialize, Deserializer, Serialize};
use strum_macros::EnumDiscriminants;

use super::alt_name::AlternativeName;
use crate::c509_oid::{C509oid, C509oidRegistered};

/// A struct of C509 `Extension`
#[derive(Debug, Clone, PartialEq)]
pub struct Extension {
    /// The registered OID of the `Extension`.
    registered_oid: C509oidRegistered,
    /// The critical flag of the `Extension` negative if critical is true, otherwise
    /// positive.
    critical: bool,
    /// The value of the `Extension` in `ExtensionValue`.
    value: ExtensionValue,
}

impl Extension {
    /// Create a new instance of `Extension` using `OID` and value.
    #[must_use]
    pub fn new(oid: Oid<'static>, value: ExtensionValue, critical: bool) -> Self {
        Self {
            registered_oid: C509oidRegistered::new(oid, EXTENSIONS_LOOKUP.get_int_to_oid_table())
                .pen_encoded(),
            critical,
            value,
        }
    }

    /// Get the value of the `Extension` in `ExtensionValue`.
    #[must_use]
    pub fn get_value(&self) -> &ExtensionValue {
        &self.value
    }

    /// Get the critical flag of the `Extension`.
    #[must_use]
    pub fn get_critical(&self) -> bool {
        self.critical
    }

    /// Get the registered OID of the `Extension`.
    #[must_use]
    pub fn get_registered_oid(&self) -> &C509oidRegistered {
        &self.registered_oid
    }
}

impl<'de> Deserialize<'de> for Extension {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where D: Deserializer<'de> {
        /// A helper struct to deserialize.
        #[derive(Debug, Deserialize)]
        struct Helper {
            /// OID string value
            oid: String,
            /// Extension value
            value: ExtensionValue,
            /// Flag to indicate whether the extension is critical
            critical: bool,
        }

        let helper = Helper::deserialize(deserializer)?;
        let oid =
            Oid::from_str(&helper.oid).map_err(|e| serde::de::Error::custom(format!("{e:?}")))?;

        Ok(Extension::new(oid, helper.value, helper.critical))
    }
}

impl Serialize for Extension {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where S: serde::Serializer {
        /// Helper struct for serialization.
        #[derive(Serialize)]
        struct Helper {
            /// OID string.
            oid: String,
            /// Extension value.
            value: ExtensionValue,
            /// Flag to indicate whether the extension is critical.
            critical: bool,
        }

        let helper = Helper {
            oid: self.registered_oid.get_c509_oid().get_oid().to_string(),
            value: self.value.clone(),
            critical: self.critical,
        };
        helper.serialize(serializer)
    }
}

impl Encode<()> for Extension {
    // Extension can be encoded as:
    // - (extensionID: int, extensionValue: any)
    // - (extensionID: ~oid, ? critical: true, extensionValue: bytes)
    // - (extensionID: pen, ? critical: true, extensionValue: bytes)
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        // Handle CBOR int based on OID mapping
        if let Some(&mapped_oid) = self
            .registered_oid
            .get_table()
            .get_map()
            .get_by_right(&self.registered_oid.get_c509_oid().get_oid())
        {
            // Determine encoded OID value based on critical flag
            let encoded_oid = if self.critical {
                -mapped_oid
            } else {
                mapped_oid
            };
            e.i16(encoded_oid)?;
        } else {
            // Handle unwrapped CBOR OID or CBOR PEN
            self.registered_oid.get_c509_oid().encode(e, ctx)?;
            if self.critical {
                e.bool(self.critical)?;
            }
        }
        // Encode the extension value
        self.value.encode(e, ctx)?;
        Ok(())
    }
}

impl Decode<'_, ()> for Extension {
    fn decode(d: &mut Decoder<'_>, ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
        match d.datatype()? {
            // Check whether OID is an int
            // Even the encoding is i16, the minicbor decoder doesn't know what type we encoded,
            // so need to check every possible type.
            minicbor::data::Type::U8
            | minicbor::data::Type::U16
            | minicbor::data::Type::I8
            | minicbor::data::Type::I16 => {
                let int_value = d.i16()?;
                // OID can be negative due to critical flag, so need absolute the value
                let abs_int_value = int_value.abs();
                let oid =
                    get_oid_from_int(abs_int_value).map_err(minicbor::decode::Error::message)?;
                let value_type = get_extension_type_from_int(abs_int_value)
                    .map_err(minicbor::decode::Error::message)?;

                // Decode extension value
                let extension_value = ExtensionValue::decode(d, &mut value_type.get_type())?;
                Ok(Extension::new(
                    oid.to_owned(),
                    extension_value,
                    int_value.is_negative(),
                ))
            },
            _ => {
                // Handle unwrapped CBOR OID or CBOR PEN
                let c509_oid = C509oid::decode(d, ctx)?;
                // Critical flag is optional, so if exist, this mean we have to decode it
                let critical = if d.datatype()? == minicbor::data::Type::Bool {
                    d.bool()?
                } else {
                    false
                };

                // Decode bytes for extension value
                let extension_value = ExtensionValue::Bytes(d.bytes()?.to_vec());

                Ok(Extension::new(
                    c509_oid.get_oid(),
                    extension_value,
                    critical,
                ))
            },
        }
    }
}

// -----------------ExtensionValue------------------------

/// Trait for `ExtensionValueType`
trait ExtensionValueTypeTrait {
    /// Get the type of the `ExtensionValueType`.
    fn get_type(&self) -> ExtensionValueType;
}

/// An enum of possible value types for `Extension`.
#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, EnumDiscriminants, Deserialize, Serialize)]
#[strum_discriminants(name(ExtensionValueType))]
pub enum ExtensionValue {
    /// An Integer in the range [-2^64, 2^64-1]
    Int(i64),
    /// A bytes.
    Bytes(Vec<u8>),
    /// An Alternative Name.
    AlternativeName(AlternativeName),
    /// An unsupported value.
    Unsupported,
}

impl ExtensionValueTypeTrait for ExtensionValueType {
    fn get_type(&self) -> ExtensionValueType {
        *self
    }
}

impl Encode<()> for ExtensionValue {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        match self {
            ExtensionValue::Int(value) => {
                e.i64(*value)?;
            },
            ExtensionValue::Bytes(value) => {
                e.bytes(value)?;
            },
            ExtensionValue::AlternativeName(value) => {
                value.encode(e, ctx)?;
            },
            ExtensionValue::Unsupported => {
                return Err(minicbor::encode::Error::message(
                    "Cannot encode unsupported Extension value",
                ));
            },
        }
        Ok(())
    }
}

impl<C> Decode<'_, C> for ExtensionValue
where C: ExtensionValueTypeTrait + Debug
{
    fn decode(d: &mut Decoder<'_>, ctx: &mut C) -> Result<Self, minicbor::decode::Error> {
        match ctx.get_type() {
            ExtensionValueType::Int => {
                let value = d.i64()?;
                Ok(ExtensionValue::Int(value))
            },
            ExtensionValueType::Bytes => {
                let value = d.bytes()?.to_vec();
                Ok(ExtensionValue::Bytes(value))
            },
            ExtensionValueType::AlternativeName => {
                let value = AlternativeName::decode(d, &mut ())?;
                Ok(ExtensionValue::AlternativeName(value))
            },
            ExtensionValueType::Unsupported => {
                Err(minicbor::decode::Error::message(
                    "Cannot decode Unsupported extension value",
                ))
            },
        }
    }
}

// ------------------Test----------------------

#[cfg(test)]
mod test_extension {
    use asn1_rs::oid;

    use super::*;

    #[test]
    fn int_oid_inhibit_anypolicy_value_unsigned_int() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let ext = Extension::new(oid!(2.5.29 .54), ExtensionValue::Int(2), false);
        ext.encode(&mut encoder, &mut ())
            .expect("Failed to encode Extension");
        // Inhibit anyPolicy : 0x181e
        // 2 : 0x02
        assert_eq!(hex::encode(buffer.clone()), "181e02");

        let mut decoder = Decoder::new(&buffer);
        let decoded_ext =
            Extension::decode(&mut decoder, &mut ()).expect("Failed to decode Extension");
        assert_eq!(decoded_ext, ext);
    }

    #[test]
    fn unwrapped_oid_critical_key_usage_value_int() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let ext = Extension::new(oid!(2.5.29 .15), ExtensionValue::Int(-1), true);
        ext.encode(&mut encoder, &mut ())
            .expect("Failed to encode Extension");
        // Key Usage with critical true: 0x21
        // -1 : 0x20
        assert_eq!(hex::encode(buffer.clone()), "2120");

        let mut decoder = Decoder::new(&buffer);
        let decoded_ext =
            Extension::decode(&mut decoder, &mut ()).expect("Failed to decode Extension");
        assert_eq!(decoded_ext, ext);
    }

    #[test]
    fn oid_unwrapped_value_bytes_string() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        // Not PEN OID and not in the registry table
        // Value should be bytes
        let ext = Extension::new(
            oid!(2.16.840 .1 .101 .3 .4 .2 .1),
            ExtensionValue::Bytes("test".as_bytes().to_vec()),
            false,
        );
        ext.encode(&mut encoder, &mut ())
            .expect("Failed to encode Extension");
        // OID : 0x49608648016503040201
        // "test".as_bytes() : 0x4474657374
        assert_eq!(
            hex::encode(buffer.clone()),
            "496086480165030402014474657374"
        );

        let mut decoder = Decoder::new(&buffer);
        let decoded_ext =
            Extension::decode(&mut decoder, &mut ()).expect("Failed to decode Extension");
        assert_eq!(decoded_ext, ext);
    }

    #[test]
    fn encode_decode_mismatch_type() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        // Subject Key Identifier should be bytes
        let ext = Extension::new(oid!(2.5.29 .14), ExtensionValue::Int(2), false);
        ext.encode(&mut encoder, &mut ())
            .expect("Failed to encode Extension");
        // SubjectKeyIdentifier : 0x01
        // 2 : 0x02
        assert_eq!(hex::encode(buffer.clone()), "0102");

        let mut decoder = Decoder::new(&buffer);
        // Decode should fail, because rely on the int value
        Extension::decode(&mut decoder, &mut ()).expect_err("Failed to decode Extension");
    }
}
