//! C509 Extension as a part of TBSCertificate used in C509 Certificate.
//! Extension fallback of C509 OID extension
//! Given OID if not found in the registered OID table, it will be encoded as a PEN OID.
//! If the OID is not a PEN OID, it will be encoded as an unwrapped OID.
//!
//! Extensions and Extension can be encoded as the following:
//! Extensions = [ * Extension ] / int
//! Extension = ( extensionID: int, extensionValue: any ) //
//! ( extensionID: ~oid, ? critical: true,
//!   extensionValue: bytes ) //
//! ( extensionID: pen, ? critical: true,
//!   extensionValue: bytes )
//!
//! For more information about Extension(s), visit [C509](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/)

// FIXME - revisit visibility
mod alt_name;

use std::fmt::Debug;

use alt_name::AltName;
use asn1_rs::{oid, Oid};
use minicbor::{encode::Write, Decode, Decoder, Encode, Encoder};
use once_cell::sync::Lazy;

use crate::{
    c509_oid::{C509oid, C509oidRegistered},
    tables::IntegerToOidTable,
};

/// Define static lookup for extensions table
/// Refernce Section - 9.4. C509 Extensions Registry.
/// Map of OID to Extension Registry integer value.
static EXTENSIONS_TABLE: Lazy<IntegerToOidTable> = Lazy::new(|| {
    // Int | OID | Extension Name | Type
    IntegerToOidTable::new(vec![
        (1, oid!(2.5.29 .14)),                      // Subject Key Identifier | bytes
        (2, oid!(2.5.29 .15)),                      // Key Usage | int
        (3, oid!(2.5.29 .17)),                      // Subject Alternative Name | AltName
        (4, oid!(2.5.29 .19)),                      // Basic Constraints | int
        (5, oid!(2.5.29 .31)), // CRL Distribution Points | CRLDistributionPoints
        (6, oid!(2.5.29 .32)), // Certificate Policies | CertificatePolicies
        (7, oid!(2.5.29 .35)), // Authority Key Identifier | KeyIdentifierArray
        (8, oid!(2.5.29 .37)), // Extended Key Usage | ExtKeyUsageSyntax
        (9, oid!(1.3.6 .1 .5 .5 .7 .1 .1)), // Authority Information Access | AuthorityInfoAccessSyntax
        (10, oid!(1.3.6 .1 .4 .1 .11129 .2 .4 .2)), // Signed Certificate Timestamp List | SignedCertificateTimestamps
        (24, oid!(2.5.29 .9)), // Subject Directory Attributes | SubjectDirectoryAttributes
        (25, oid!(2.5.29 .18)), // Issuer Alternative Name | AltName
        (26, oid!(2.5.29 .30)), // Name Constraints | NameConstraints
        (27, oid!(2.5.29 .33)), // Policy Mappings | PolicyMappings
        (28, oid!(2.5.29 .36)), // Policy Constraints | PolicyConstraints
        (29, oid!(2.5.29 .46)), // Freshest CRL | FreshestCRL
        (30, oid!(2.5.29 .54)), // Inhibit anyPolicy | uint
        (31, oid!(1.3.6 .1 .5 .5 .7 .1 .11)), // Subject Information Access | SubjectInfoAccessSyntax
        (32, oid!(1.3.6 .1 .5 .5 .7 .1 .7)),  // IP Resources | IPAddrBlocks
        (33, oid!(1.3.6 .1 .5 .5 .7 .1 .7)),  // AS Resource | ASIdentifiers
        (34, oid!(1.3.6 .1 .5 .5 .7 .1 .28)), // IP Resources v2 | IPAddrBlocks
        (35, oid!(1.3.6 .1 .5 .5 .7 .1 .29)), // AS Resources v2 | ASIdentifiers
        (36, oid!(1.3.6 .1 .5 .5 .7 .1 .2)),  // Biometric Information
        (37, oid!(1.3.6 .1 .4 .1 .11129 .2 .4 .4)), // Precertificate Signing Certificate
        (38, oid!(1.3.6 .1 .5 .5 .7 .48 .1 .5)), // OCSP No Check
    ])
});

// -----------------------------------------

#[allow(dead_code)]
#[derive(Debug, Clone, PartialEq)]
pub enum ExtensionValue {
    // integer in the range [-2^64, 2^64-1]
    Int(i64),
    // unsigned integer in the range [0, 2^64-1]
    Uint(u64),
    Text(String),
    Bytes(Vec<u8>),
    AltName(AltName),
}

impl Encode<()> for ExtensionValue {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        match self {
            ExtensionValue::Int(value) => {
                e.i64(*value)?;
            },
            ExtensionValue::Uint(value) => {
                e.u64(*value)?;
            },
            ExtensionValue::Text(value) => {
                e.str(value)?;
            },
            ExtensionValue::Bytes(value) => {
                e.bytes(value)?;
            },
            ExtensionValue::AltName(value) => {
                value.encode(e, ctx)?;
            },
        }
        Ok(())
    }
}

impl<C> Decode<'_, C> for ExtensionValue
where
    C: std::convert::Into<i16> + Clone,
{
    fn decode(d: &mut Decoder<'_>, ctx: &mut C) -> Result<Self, minicbor::decode::Error> {
        let n: i16 = ctx.clone().into();
        // Need extension type to know what to decode
        match n {
            1 => Ok(ExtensionValue::Bytes(d.bytes()?.to_vec())),
            2 | 4 => Ok(ExtensionValue::Int(d.i64()?)),
            3 | 25 => Ok(ExtensionValue::AltName(AltName::decode(d, &mut ())?)),
            30 => Ok(ExtensionValue::Uint(d.u64()?)),
            _ => Err(minicbor::decode::Error::message("Not implemented yet")),
        }
    }
}

// -----------------------------------------

/// OID of KeyUsage extension
static KEY_USAGE_OID: Oid<'static> = oid!(2.5.29 .15);

/// A struct of C509 Extensions
///
/// # Fields
/// * `extensions` - A vector of C509Extension.
#[derive(Debug, Clone, PartialEq)]
pub(crate) struct Extensions {
    extensions: Vec<C509Extension>,
}

impl Extensions {
    /// Create a new instance of `Extensions` as empty vector.
    pub fn new() -> Self {
        Extensions {
            extensions: Vec::new(),
        }
    }

    /// Add an `Extension` to the `Extensions`.
    pub fn add_extension(mut self, extension: C509Extension) -> Self {
        self.extensions.push(extension);
        self
    }
}

impl Encode<()> for Extensions {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        // If there is only one extension and it is KeyUsage, encode as int
        // encoding as absolute value of the second int and the sign of the first int
        if let Some(extension) = self.extensions.get(0) {
            if self.extensions.len() == 1
                && extension.registered_oid.get_c509_oid().get_oid() == KEY_USAGE_OID
            {
                match extension.get_value() {
                    ExtensionValue::Int(value) => {
                        let ku_value = if extension.get_critical() {
                            -value
                        } else {
                            value
                        };
                        e.i64(ku_value)?;
                        return Ok(());
                    },
                    _ => {
                        return Err(minicbor::encode::Error::message(
                            "KeyUsage extension value should be an integer",
                        ));
                    },
                }
            }
        }
        // Else handle the array of `Extension`
        e.array(self.extensions.len() as u64)?;
        Ok(for extension in &self.extensions {
            extension.encode(e, ctx)?;
        })
    }
}

impl Decode<'_, ()> for Extensions {
    fn decode(d: &mut Decoder<'_>, _ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
        // If only KeyUsage is in the extension -> will only contain an int
        if d.datatype()? == minicbor::data::Type::U8 || d.datatype()? == minicbor::data::Type::I8 {
            // Check if it's a negative number (critical extension)
            let critical = d.datatype()? == minicbor::data::Type::I8;
            let value = d.i64()?;

            let extension_value = ExtensionValue::Int(value);
            let decoded_extension = C509Extension::new(KEY_USAGE_OID.clone(), extension_value);

            let extension = if critical {
                decoded_extension.set_critical()
            } else {
                decoded_extension
            };
            return Ok(Extensions::new().add_extension(extension));
        }
        // Handle array of extensions
        let len = d
            .array()?
            .ok_or_else(|| minicbor::decode::Error::message("Failed to get array length"))?;
        let mut extensions = Extensions::new();

        for _ in 0..len {
            let extension = C509Extension::decode(d, &mut ())?;
            extensions = extensions.add_extension(extension);
        }

        Ok(extensions)
    }
}

// -----------------------------------------

/// A struct of C509 Extension
///
/// # Fields
/// * `registered_oid` - The registered OID of the extension.
/// * `critical` - The critical flag of the extension negative if critical is true, otherwise positive.
/// * `value` - The value of the extension in `ExtensionValue`.
#[derive(Debug, Clone, PartialEq)]
pub struct C509Extension {
    registered_oid: C509oidRegistered,
    critical: bool,
    value: ExtensionValue,
}

#[allow(dead_code)]
impl C509Extension {
    /// Create a new instance of `C509Extension` using `OID` and value.
    /// Critical flag is originally set to false.
    fn new(oid: Oid<'static>, value: ExtensionValue) -> Self {
        C509Extension {
            registered_oid: C509oidRegistered::new(oid, &EXTENSIONS_TABLE).pen_encoded(),
            critical: false,
            value,
        }
    }

    /// Get the value of the C509Extension.
    pub(crate) fn get_value(&self) -> ExtensionValue {
        self.value.clone()
    }

    /// Get the critical flag of the C509Extension.
    pub(crate) fn get_critical(&self) -> bool {
        self.critical
    }

    /// Set the critical flag of the C509Extension.
    pub(crate) fn set_critical(mut self) -> Self {
        self.critical = true;
        self
    }

    /// Set the value of the C509Extension.
    pub fn set_value(mut self, value: ExtensionValue) -> Self {
        self.value = value;
        self
    }
}

impl Encode<()> for C509Extension {
    /// Extension can be encoded as:
    /// - (extensionID: int, extensionValue: any)
    /// - (extensionID: ~oid, ? critical: true, extensionValue: bytes)
    /// - (extensionID: pen, ? critical: true, extensionValue: bytes)
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

// FIXME - Revisit
#[derive(Clone)]
struct IntContext {
    value: i16,
}

impl IntContext {
    fn new(value: i16) -> Self {
        IntContext { value }
    }
}

impl std::convert::Into<i16> for IntContext {
    fn into(self) -> i16 {
        self.value
    }
}

impl<'a> Decode<'a, ()> for C509Extension {
    fn decode(d: &mut Decoder<'a>, ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
        match d.datatype()? {
            // Check whether OID is an int
            // Even the encoding is i16, the minicbor decoder doesn't know what type we encoded,
            // so need to check every possible type.
            minicbor::data::Type::U8
            | minicbor::data::Type::U16
            | minicbor::data::Type::I8
            | minicbor::data::Type::I16 => {
                let oid_value = d.i16()?;
                // OID can be negative due to critical flag, so need absolute the value
                let abs_oid_value = oid_value.abs();
                // Get the OID associated with the int value
                let oid = EXTENSIONS_TABLE
                    .get_map()
                    .get_by_left(&abs_oid_value)
                    .ok_or_else(|| minicbor::decode::Error::message("OID int not found"))?;
                // Decode extension value
                let extension_value = ExtensionValue::decode(d, &mut IntContext::new(abs_oid_value))?;

                // Set the critical flag to true if the OID is negative
                let extension = if oid_value.is_positive() {
                    C509Extension::new(oid.to_owned(), extension_value)
                } else {
                    C509Extension::new(oid.to_owned(), extension_value).set_critical()
                };
                Ok(extension)
            },
            _ => {
                // Handle unwrapped CBOR OID or CBOR PEN
                let c509_oid = C509oid::decode(d, ctx)?;
                // Citical flag is optional, so if exist, this mean we have to decode it
                let critical = if d.datatype()? == minicbor::data::Type::Bool {
                    d.bool()?
                } else {
                    false
                };

                // Decode bytes for extension value
                let extension_value = ExtensionValue::Bytes(d.bytes()?.to_vec());

                // Create extension with or without critical flag
                let extension = if critical {
                    C509Extension::new(c509_oid.get_oid(), extension_value).set_critical()
                } else {
                    C509Extension::new(c509_oid.get_oid(), extension_value)
                };
                Ok(extension)
            },
        }
    }
}

// -----------------------------------------

#[cfg(test)]
mod test_c509_extension {
    use super::*;

    #[test]
    fn test_c509_extension_int_oid_with_int_value() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        // Key Usage
        let ext = C509Extension::new(oid!(2.5.29 .54), ExtensionValue::Uint(2));
        ext.encode(&mut encoder, &mut ())
            .expect("Failed to encode Extension");
        // Inhibit anyPolicy : 0x181e
        // 2 : 0x02
        assert_eq!(hex::encode(buffer.clone()), "181e02");

        let mut decoder = Decoder::new(&buffer);
        let decoded_ext =
            C509Extension::decode(&mut decoder, &mut ()).expect("Failed to decode Extension");
        assert_eq!(decoded_ext, ext);
    }

    #[test]
    fn test_c509_extension_unwrapped_oid_critical_with_int_value() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let ext = C509Extension::new(oid!(2.5.29 .15), ExtensionValue::Int(-1)).set_critical();
        ext.encode(&mut encoder, &mut ())
            .expect("Failed to encode Extension");
        // Key Usage with critical true: 0x21
        // -1 : 0x20
        assert_eq!(hex::encode(buffer.clone()), "2120");

        let mut decoder = Decoder::new(&buffer);
        let decoded_ext =
            C509Extension::decode(&mut decoder, &mut ()).expect("Failed to decode Extension");
        assert_eq!(decoded_ext, ext);
    }

    #[test]
    fn test_c509_extension_oid_unwrapped_with_bytes_string_value() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        // Not PEN OID and not in the registry table
        // Value should be bytes
        let ext = C509Extension::new(
            oid!(2.16.840 .1 .101 .3 .4 .2 .1),
            ExtensionValue::Bytes("test".as_bytes().to_vec()),
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
            C509Extension::decode(&mut decoder, &mut ()).expect("Failed to decode Extension");
        assert_eq!(decoded_ext, ext);
    }

    #[test]
    fn test_extensions_one_extension_key_usage() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let exts = Extensions::new()
            .add_extension(C509Extension::new(oid!(2.5.29 .15), ExtensionValue::Int(2)));
        exts.encode(&mut encoder, &mut ())
            .expect("Failed to encode Extensions");
        // 1 extension
        // value 2 : 0x02
        assert_eq!(hex::encode(buffer.clone()), "02");

        let mut decoder = Decoder::new(&buffer);
        let decoded_exts =
            Extensions::decode(&mut decoder, &mut ()).expect("Failed to decode Extensions");
        assert_eq!(decoded_exts, exts);
    }

    // #[test]
    // fn test_extensions_one_extension_key_usage_set_critical() {
    //     let mut buffer = Vec::new();
    //     let mut encoder = Encoder::new(&mut buffer);

    //     let exts =
    //         Extensions::new().add_extension(C509Extension::new(oid!(2.5.29 .15),ExtensionValue::Int(2)).set_critical());
    //     exts.encode(&mut encoder, &mut ())
    //         .expect("Failed to encode Extensions");
    //     // 1 extension
    //     // value -2 : 0x21
    //     assert_eq!(hex::encode(buffer.clone()), "21");

    //     let mut decoder = Decoder::new(&buffer);
    //     let decoded_exts =
    //         Extensions::decode(&mut decoder, &mut ()).expect("Failed to decode Extensions");
    //     assert_eq!(decoded_exts, exts);
    // }

    // #[test]
    // fn test_extensions_multiple_extensions() {
    //     let mut buffer = Vec::new();
    //     let mut encoder = Encoder::new(&mut buffer);

    //     let exts =
    //         Extensions::new().add_extension(C509Extension::new(oid!(2.5.29 .15), 2));
    //         exts.add_extension(C509Extension::new(oid!(2.16.840 .1 .101 .3 .4 .2 .1), 1.5));
    //     exts.encode(&mut encoder, &mut ())
    //         .expect("Failed to encode Extensions");

    //     assert_eq!(hex::encode(buffer.clone()), "21");

    //     let mut decoder = Decoder::new(&buffer);
    //     let decoded_exts =
    //         Extensions::decode(&mut decoder, &mut ()).expect("Failed to decode Extensions");
    //     assert_eq!(decoded_exts, exts);
    // }
}
