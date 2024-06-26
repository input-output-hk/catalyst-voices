//! C509 Extension
//! Extension fallback of C509 OID extension
//! Given OID if not found in the registered OID table, it will be encoded as a PEN OID.
//! If the OID is not a PEN OID, it will be encoded as an unwrapped OID.

use asn1_rs::{oid, Oid};
use minicbor::{decode, encode::Write, Decode, Decoder, Encode, Encoder};
use once_cell::sync::Lazy;

use crate::c509_oid::{C509oid, C509oidRegistered, OidToIntegerTable};

// Define static lookup for extensions table
/// Refernce Section - 9.4. C509 Extensions Registry.
/// Map of OID to Extension Registry integer value.
static EXTENSIONS_TABLE: Lazy<OidToIntegerTable> = Lazy::new(|| {
    OidToIntegerTable::new(vec![
        (1, oid!(2.5.29 .14)),                      // Subject Key Identifier
        (2, oid!(2.5.29 .15)),                      // Key Usage
        (3, oid!(2.5.29 .17)),                      // Subject Alternative Name
        (4, oid!(2.5.29 .19)),                      // Basic Constraints
        (5, oid!(2.5.29 .31)),                      // CRL Distribution Points
        (6, oid!(2.5.29 .32)),                      // Certificate Policies
        (7, oid!(2.5.29 .35)),                      // Authority Key Identifier
        (8, oid!(2.5.29 .37)),                      // Extended Key Usage
        (9, oid!(1.3.6 .1 .5 .5 .7 .1 .1)),         // Authority Information Access
        (10, oid!(1.3.6 .1 .4 .1 .11129 .2 .4 .2)), // Signed Certificate Timestamp List
        (24, oid!(2.5.29 .9)),                      // Subject Directory Attributes
        (25, oid!(2.5.29 .18)),                     // Issuer Alternative Name
        (26, oid!(2.5.29 .30)),                     // Name Constraints
        (27, oid!(2.5.29 .33)),                     // Policy Mappings
        (28, oid!(2.5.29 .36)),                     // Policy Constraints
        (29, oid!(2.5.29 .46)),                     // Freshest CRL
        (30, oid!(2.5.29 .54)),                     // Inhibit anyPolicy
        (31, oid!(1.3.6 .1 .5 .5 .7 .1 .11)),       // Subject Information Access
        (32, oid!(1.3.6 .1 .5 .5 .7 .1 .7)),        // AS Resource
        (34, oid!(1.3.6 .1 .5 .5 .7 .1 .28)),       // IP Resources v2
        (35, oid!(1.3.6 .1 .5 .5 .7 .1 .29)),       // AS Resources v2
        (36, oid!(1.3.6 .1 .5 .5 .7 .1 .2)),        // Biometric Information
        (37, oid!(1.3.6 .1 .4 .1 .11129 .2 .4 .4)), // Precertificate Signing Certificate
        (38, oid!(1.3.6 .1 .5 .5 .7 .48 .1 .5)),    // OCSP No Check
    ])
});

/* 
static KEY_USAGE_OID: Oid<'static> = oid!(2.5.29 .15);
// -----------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub(crate) struct Extensions<'a, T>
where
    T: Encode<()> + Decode<'a, ()>,
{
    extensions: Vec<C509Extension<'a, T>>,
}

#[allow(dead_code)]
impl<'a, T> Extensions<'a, T>
where
    T: Encode<()> + Decode<'a, ()>,
{
    pub fn new() -> Self {
        Extensions {
            extensions: Vec::new(),
        }
    }

    pub fn add_extension(mut self, extension: C509Extension<'a, T>) -> Self {
        self.extensions.push(extension);
        self
    }

    // pub fn get_extensions(&self) -> Vec<C509Extension<'a, T>> {
    //     self.extensions.clone()
    // }
}

impl<'a, T, C> Encode<C> for Extensions<'a, T>
where
    T: Encode<()> + Decode<'a, ()> + AsPrimitive<i16>,
{
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut C,
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        if self.extensions.len() == 1
            && self.extensions[0].registered_oid.get_oid() == KEY_USAGE_OID
        {
            // Gaurantee that the extension value of KeyUsage is int
            // FIXME - Should be a better way to cast this
            let cast_value: i16 = convert_to_i16(*self.extensions[0].get_value());
            let value = if self.extensions[0].get_critical() {
                -cast_value
            } else {
                cast_value
            };
            e.i16(value)?.ok()
        } else {
            e.array(self.extensions.len() as u64)?;
            Ok(for extension in &self.extensions {
                extension.encode(e, ctx)?;
            })
        }
    }
}

impl<'a, T, C> Decode<'a, C> for Extensions<'a, T>
where
    T: Encode<()> + Decode<'a, ()>,
{
    fn decode(d: &mut Decoder<'a>, _ctx: &mut C) -> Result<Self, decode::Error> {
        // KeyUsage value is 2 so should be integer8
        // Gaurantee that the extension value of KeyUsage is int
        if minicbor::data::Type::U8 == d.datatype()? || minicbor::data::Type::I8 == d.datatype()? {
            // FIXME - Fix this int decoding
            // If it is a negative number, minicbor will interpret as Integer
            let critical = if minicbor::data::Type::I8 == d.datatype()? {
                true
            } else {
                false
            };
            let decoded_extension = C509Extension::new(KEY_USAGE_OID.clone(), d.decode()?);
            let extension = if critical {
                decoded_extension.critical()
            } else {
                decoded_extension
            };
            Ok(Extensions::new().add_extension(extension))
        } else {
            println!("{:?}", d.array()?);
            // d.decode()?.ok();
            Ok(Extensions::new())
        }
    }
}

fn convert_to_i16<T>(x: T) -> i16
where
    T: AsPrimitive<i16>,
{
    x.as_()
}
*/
// -----------------------------------------

#[allow(dead_code)]
#[derive(Debug, Clone, PartialEq)]
pub struct C509Extension<'a, T>
where
    T: Encode<()> + Decode<'a, ()>,
{
    registered_oid: C509oidRegistered<'a>,
    critical: bool,
    value: T,
}

#[allow(dead_code)]
impl<'a, T> C509Extension<'a, T>
where
    T: Encode<()> + Decode<'a, ()>,
{
    fn new(oid: Oid<'a>, value: T) -> Self {
        C509Extension {
            registered_oid: C509oidRegistered::new(oid, &EXTENSIONS_TABLE).pen_encoded(),
            critical: false,
            value,
        }
    }

    pub fn get_value(&self) -> &T {
        &self.value
    }

    pub fn get_critical(&self) -> bool {
        self.critical
    }

    pub fn critical(mut self) -> Self {
        self.critical = true;
        self
    }

    pub fn set_value(mut self, value: T) -> Self {
        self.value = value;
        self
    }
}

impl<'a, T, C> Encode<C> for C509Extension<'a, T>
where
    T: Encode<()> + Decode<'a, ()>,
{
    /// Extension can be encoded as:
    /// - (extensionID: int, extensionValue: any)
    /// - (extensionID: ~oid, ? critical: true, extensionValue: bytes)
    /// - (extensionID: pen, ? critical: true, extensionValue: bytes)
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut C,
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        // Handle CBOR int
        if let Some(&oid) = self
            .registered_oid
            .get_table()
            .get_map()
            .get_by_right(&self.registered_oid.get_oid())
        {
            // Handle critical flag
            let encoded_oid = if self.critical { -oid } else { oid };
            e.i16(encoded_oid)?;
        // Handle unwrapped CBOR OID or CBOR PEN
        } else {
            self.registered_oid.get_c509_oid().encode(e, ctx)?;
            if self.critical {
                e.bool(true)?;
            }
        }
        self.value.encode(e, &mut ())?;
        Ok(())
    }
}

impl<'a, T, C> Decode<'a, C> for C509Extension<'a, T>
where
    T: Encode<()> + Decode<'a, ()>,
{
    fn decode(d: &mut Decoder<'a>, _ctx: &mut C) -> Result<Self, decode::Error> {
        // Check whether OID is an int
        // Even the encoding is i16, the minicbor decoder doesn't know what type we encoded,
        // so need to check every possible type.
        if minicbor::data::Type::U8 == d.datatype()?
            || minicbor::data::Type::U16 == d.datatype()?
            || minicbor::data::Type::I8 == d.datatype()?
            || minicbor::data::Type::I16 == d.datatype()?
        {
            let oid_value = d.i16()?;
            let abs_oid_value = oid_value.abs();
            let oid = EXTENSIONS_TABLE
                .get_map()
                .get_by_left(&abs_oid_value)
                .ok_or_else(|| decode::Error::message("OID int not found"))?;
            let extension = if oid_value.is_positive() {
                C509Extension::new(oid.to_owned(), d.decode()?)
            } else {
                C509Extension::new(oid.to_owned(), d.decode()?).critical()
            };
            Ok(extension)
        // Handle unwrapped CBOR OID or CBOR PEN
        } else {
            let c509_oid: C509oid = d.decode()?;
            let extension = if minicbor::data::Type::Bool == d.datatype()? && d.bool()? {
                C509Extension::new(c509_oid.get_oid(), d.decode()?).critical()
            } else {
                C509Extension::new(c509_oid.get_oid(), d.decode()?)
            };
            Ok(extension)
        }
    }
}

// -----------------------------------------

#[cfg(test)]
mod test_c509_extension {
    use super::*;

    #[test]
    fn test_c509_extension_int_with_uint_value() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        // Precertificate Signing Certificate
        let ext = C509Extension::new(oid!(1.3.6 .1 .4 .1 .11129 .2 .4 .4), 2);
        ext.encode(&mut encoder, &mut ())
            .expect("Failed to encode Extension");
        // OID : 0x1825
        // 2 : 0x02
        assert_eq!(hex::encode(buffer.clone()), "182502");

        let mut decoder = Decoder::new(&buffer);
        let decoded_ext =
            C509Extension::decode(&mut decoder, &mut ()).expect("Failed to decode Extension");
        assert_eq!(decoded_ext, ext);
    }

    #[test]
    fn test_c509_extension_oid_critical_with_str_value() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        // Precertificate Signing Certificate
        let ext = C509Extension::new(oid!(1.3.6 .1 .4 .1 .11129 .2 .4 .4), "test").critical();
        ext.encode(&mut encoder, &mut ())
            .expect("Failed to encode Extension");
        // OID : 0x3824
        // "test" : 0x6474657374
        assert_eq!(hex::encode(buffer.clone()), "38246474657374");

        let mut decoder = Decoder::new(&buffer);
        let decoded_ext =
            C509Extension::decode(&mut decoder, &mut ()).expect("Failed to decode Extension");
        assert_eq!(decoded_ext, ext);
    }

    #[test]
    fn test_c509_extension_oid_pen_with_arr_value() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        // Precertificate Signing Certificate
        let ext = C509Extension::new(oid!(1.3.6 .1 .4 .1 .1 .1 .29), [0, 1, 2, 3]);
        ext.encode(&mut encoder, &mut ())
            .expect("Failed to encode Extension");
        // OID : 0xd8704301011d
        // [0, 1, 2, 3] : 0x8400010203
        assert_eq!(hex::encode(buffer.clone()), "d8704301011d8400010203");

        let mut decoder = Decoder::new(&buffer);
        let decoded_ext =
            C509Extension::decode(&mut decoder, &mut ()).expect("Failed to decode Extension");
        assert_eq!(decoded_ext, ext);
    }

    #[test]
    fn test_c509_extension_oid_pen_critical_with_char_value() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        // Precertificate Signing Certificate
        // Critical should not work since the OID is not in the registry table
        let ext = C509Extension::new(oid!(1.3.6 .1 .4 .1 .1 .1 .29), 'a').critical();
        ext.encode(&mut encoder, &mut ())
            .expect("Failed to encode Extension");
        // OID : 0xd8704301011df5
        // 'a' : 0x1861
        assert_eq!(hex::encode(buffer.clone()), "d8704301011df51861");

        let mut decoder = Decoder::new(&buffer);
        let decoded_ext =
            C509Extension::decode(&mut decoder, &mut ()).expect("Failed to decode Extension");
        assert_eq!(decoded_ext, ext);
    }

    #[test]
    fn test_c509_extension_oid_unwrapped_with_i8_value() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        // Not PEN OID and not in the registry table
        let ext = C509Extension::new(oid!(2.16.840 .1 .101 .3 .4 .2 .1), -1);
        ext.encode(&mut encoder, &mut ())
            .expect("Failed to encode Extension");
        // OID : 0x49608648016503040201
        // -1 : 0x20
        assert_eq!(hex::encode(buffer.clone()), "4960864801650304020120");

        let mut decoder = Decoder::new(&buffer);
        let decoded_ext =
            C509Extension::decode(&mut decoder, &mut ()).expect("Failed to decode Extension");
        assert_eq!(decoded_ext, ext);
    }

    #[test]
    fn test_c509_extension_oid_unwrapped_critical_with_f8_value() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        // Not PEN OID and not in the registry table
        // Critical should not work since the OID is not in the registry table
        let ext = C509Extension::new(oid!(2.16.840 .1 .101 .3 .4 .2 .1), 1.5).critical();
        ext.encode(&mut encoder, &mut ())
            .expect("Failed to encode Extension");
        // OID : 0x49608648016503040201
        // True : 0xf5
        // 1.5 : 0xfb3ff8000000000000
        assert_eq!(
            hex::encode(buffer.clone()),
            "49608648016503040201f5fb3ff8000000000000"
        );

        let mut decoder = Decoder::new(&buffer);
        let decoded_ext =
            C509Extension::decode(&mut decoder, &mut ()).expect("Failed to decode Extension");
        assert_eq!(decoded_ext, ext);
    }

    // #[test]
    // fn test_extensions_one_extension_key_usage() {
    //     let mut buffer = Vec::new();
    //     let mut encoder = Encoder::new(&mut buffer);

    //     let exts = Extensions::new().add_extension(C509Extension::new(oid!(2.5.29 .15), 2));
    //     exts.encode(&mut encoder, &mut ())
    //         .expect("Failed to encode Extensions");
    //     // 1 extension
    //     // value 2 : 0x02
    //     assert_eq!(hex::encode(buffer.clone()), "02");

    //     let mut decoder = Decoder::new(&buffer);
    //     let decoded_exts =
    //         Extensions::decode(&mut decoder, &mut ()).expect("Failed to decode Extensions");
    //     assert_eq!(decoded_exts, exts);
    // }

    // #[test]
    // fn test_extensions_one_extension_key_usage_critical() {
    //     let mut buffer = Vec::new();
    //     let mut encoder = Encoder::new(&mut buffer);

    //     let exts =
    //         Extensions::new().add_extension(C509Extension::new(oid!(2.5.29 .15), 2).critical());
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
