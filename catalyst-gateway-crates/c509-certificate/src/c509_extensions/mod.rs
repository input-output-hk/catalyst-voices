//! C509 Extension as a part of `TBSCertificate` used in C509 Certificate.
//! Extension fallback of C509 OID extension
//! Given OID if not found in the registered OID table, it will be encoded as a PEN OID.
//! If the OID is not a PEN OID, it will be encoded as an unwrapped OID.
//!
//! ```cddl
//! Extensions and Extension can be encoded as the following:
//! Extensions = [ * Extension ] / int
//! Extension = ( extensionID: int, extensionValue: any ) //
//! ( extensionID: ~oid, ? critical: true,
//!   extensionValue: bytes ) //
//! ( extensionID: pen, ? critical: true,
//!   extensionValue: bytes )
//! ```
//!
//! For more information about Extensions,
//! visit [C509 Certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/)

pub mod alt_name;
pub mod extension;

use std::fmt::Debug;

use asn1_rs::{oid, Oid};
use extension::{Extension, ExtensionValue};
use minicbor::{encode::Write, Decode, Decoder, Encode, Encoder};

/// OID of `KeyUsage` extension
static KEY_USAGE_OID: Oid<'static> = oid!(2.5.29 .15);

/// A struct of C509 Extensions
#[derive(Debug, Clone, PartialEq)]
pub struct Extensions {
    ///  A vector of `Extension`.
    extensions: Vec<Extension>,
}

impl Default for Extensions {
    fn default() -> Self {
        Self::new()
    }
}

impl Extensions {
    /// Create a new instance of `Extensions` as empty vector.
    #[must_use]
    pub fn new() -> Self {
        Self {
            extensions: Vec::new(),
        }
    }

    /// Add an `Extension` to the `Extensions`.
    #[must_use]
    pub fn add_ext(mut self, extension: Extension) -> Self {
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
        if let Some(extension) = self.extensions.first() {
            if self.extensions.len() == 1
                && extension.get_registered_oid().get_c509_oid().get_oid() == KEY_USAGE_OID
            {
                match extension.get_value() {
                    ExtensionValue::Int(value) => {
                        let ku_value = if extension.get_critical() {
                            -value
                        } else {
                            *value
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
        for extension in &self.extensions {
            extension.encode(e, ctx)?;
        }
        Ok(())
    }
}

impl Decode<'_, ()> for Extensions {
    fn decode(d: &mut Decoder<'_>, _ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
        // If only KeyUsage is in the extension -> will only contain an int
        if d.datatype()? == minicbor::data::Type::U8 || d.datatype()? == minicbor::data::Type::I8 {
            // Check if it's a negative number (critical extension)
            let critical = d.datatype()? == minicbor::data::Type::I8;
            // Note that 'KeyUsage' BIT STRING is interpreted as an unsigned integer,
            // so we can absolute the value
            let value = d.i64()?.abs();

            let extension_value = ExtensionValue::Int(value);
            let decoded_extension = Extension::new(KEY_USAGE_OID.clone(), extension_value);

            let extension = if critical {
                decoded_extension.set_critical()
            } else {
                decoded_extension
            };
            return Ok(Extensions::new().add_ext(extension));
        }
        // Handle array of extensions
        let len = d
            .array()?
            .ok_or_else(|| minicbor::decode::Error::message("Failed to get array length"))?;
        let mut extensions = Extensions::new();
        for _ in 0..len {
            let extension = Extension::decode(d, &mut ())?;
            extensions = extensions.add_ext(extension);
        }

        Ok(extensions)
    }
}

// ------------------Test----------------------

#[cfg(test)]
mod test_extensions {
    use super::*;

    #[test]
    fn one_extension_key_usage() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let exts =
            Extensions::new().add_ext(Extension::new(oid!(2.5.29 .15), ExtensionValue::Int(2)));
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

    #[test]
    fn one_extension_key_usage_set_critical() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let exts = Extensions::new()
            .add_ext(Extension::new(oid!(2.5.29 .15), ExtensionValue::Int(2)).set_critical());
        exts.encode(&mut encoder, &mut ())
            .expect("Failed to encode Extensions");
        // 1 extension
        // value -2 : 0x21
        assert_eq!(hex::encode(buffer.clone()), "21");

        let mut decoder = Decoder::new(&buffer);
        let decoded_exts =
            Extensions::decode(&mut decoder, &mut ()).expect("Failed to decode Extensions");
        assert_eq!(decoded_exts, exts);
    }

    #[test]
    fn multiple_extensions() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let exts = Extensions::new()
            .add_ext(Extension::new(oid!(2.5.29 .15), ExtensionValue::Int(2)))
            .add_ext(Extension::new(
                oid!(2.5.29 .14),
                ExtensionValue::Bytes([1, 2, 3, 4].to_vec()),
            ));
        exts.encode(&mut encoder, &mut ())
            .expect("Failed to encode Extensions");

        assert_eq!(hex::encode(buffer.clone()), "820202014401020304");

        let mut decoder = Decoder::new(&buffer);
        let decoded_exts =
            Extensions::decode(&mut decoder, &mut ()).expect("Failed to decode Extensions");
        assert_eq!(decoded_exts, exts);
    }
}
