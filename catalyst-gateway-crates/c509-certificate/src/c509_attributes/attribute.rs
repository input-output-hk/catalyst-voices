//! C509 Attribute
//!
//! ```cddl
//! Attribute = ( attributeType: int, attributeValue: text ) //
//! ( attributeType: ~oid, attributeValue: bytes ) //
//! ( attributeType: pen, attributeValue: bytes )
//! ```
//!
//! For more information about Attribute,
//! visit [C509 Certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/)

use asn1_rs::Oid;
use minicbor::{encode::Write, Decode, Decoder, Encode, Encoder};

use super::data::ATTRIBUTES_TABLES;
use crate::c509_oid::{C509oid, C509oidRegistered};

/// A struct of C509 `Attribute`
#[derive(Debug, Clone, PartialEq)]
pub struct Attribute {
    /// A registered OID of C509 `Attribute`.
    registered_oid: C509oidRegistered,
    /// A flag to indicate whether the value can be has multiple value.
    multi_value: bool,
    /// A value of C509 `Attribute` can be a vector of text or bytes.
    value: Vec<TextOrBytes>,
}

impl Attribute {
    /// Create a new instance of `Attribute`.
    #[must_use]
    pub fn new(oid: Oid<'static>) -> Self {
        Self {
            registered_oid: C509oidRegistered::new(oid, ATTRIBUTES_TABLES.get_int_to_oid_table()),
            multi_value: false,
            value: Vec::new(),
        }
    }

    /// Add a value to `Attribute`.
    pub fn add_value(&mut self, value: TextOrBytes) {
        self.value.push(value);
    }

    /// Get the registered OID of `Attribute`.
    pub(crate) fn get_registered_oid(&self) -> &C509oidRegistered {
        &self.registered_oid
    }

    /// Get the value of `Attribute`.
    pub(crate) fn get_value(&self) -> &Vec<TextOrBytes> {
        &self.value
    }

    /// Set whether `Attribute` can be PEN encoded.
    pub(crate) fn set_pen_supported(self) -> Self {
        // FIXME - ugly
        Self {
            registered_oid: self.registered_oid.pen_encoded(),
            multi_value: self.multi_value,
            value: self.value,
        }
    }

    /// Set whether `Attribute` can have multiple value.
    pub(crate) fn set_multi_value(mut self) -> Self {
        self.multi_value = true;
        self
    }
}

impl Encode<()> for Attribute {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        // Encode CBOR int if available
        if let Some(&oid) = self
            .registered_oid
            .get_table()
            .get_map()
            .get_by_right(&self.registered_oid.get_c509_oid().get_oid())
        {
            e.i16(oid)?;
        } else {
            // Encode unwrapped CBOR OID or CBOR PEN
            self.registered_oid.get_c509_oid().encode(e, ctx)?;
        }

        // Check if the attribute value is empty
        if self.value.is_empty() {
            return Err(minicbor::encode::Error::message("Attribute value is empty"));
        }

        // If multi-value attributes, encode it as array
        if self.multi_value {
            e.array(self.value.len() as u64)?;
        }

        // Encode each value in the attribute
        for value in &self.value {
            value.encode(e, ctx)?;
        }

        Ok(())
    }
}

impl Decode<'_, ()> for Attribute {
    fn decode(d: &mut Decoder<'_>, ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
        // Handle CBOR int
        let mut attr = if d.datatype()? == minicbor::data::Type::U8 {
            let oid_value = d.i16()?;
            let oid = ATTRIBUTES_TABLES
                .get_int_to_oid_table()
                .get_map()
                .get_by_left(&oid_value)
                .ok_or_else(|| {
                    minicbor::decode::Error::message(format!("OID int not found given {oid_value}"))
                })?;
            Attribute::new(oid.clone())
        } else {
            // Handle unwrapped CBOR OID or CBOR PEN
            let c509_oid: C509oid = d.decode()?;
            Attribute::new(c509_oid.get_oid())
        };

        // Handle attribute value
        if d.datatype()? == minicbor::data::Type::Array {
            let len = d.array()?.ok_or_else(|| {
                minicbor::decode::Error::message("Failed to get array length for attribute value")
            })?;

            if len == 0 {
                return Err(minicbor::decode::Error::message("Attribute value is empty"));
            }

            for _ in 0..len {
                attr.add_value(TextOrBytes::decode(d, ctx)?);
            }
            attr = attr.set_multi_value();
        } else {
            let value = TextOrBytes::decode(d, ctx)?;
            attr.add_value(value);
        }
        Ok(attr)
    }
}

// ------------------TextOrBytes----------------------

/// An enum of possible value types for `Attribute`.
#[derive(Debug, Clone, PartialEq)]
pub enum TextOrBytes {
    /// A text string.
    Text(String),
    /// A byte vector.
    Bytes(Vec<u8>),
}

impl Encode<()> for TextOrBytes {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, _ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        match self {
            TextOrBytes::Text(text) => e.str(text)?,
            TextOrBytes::Bytes(bytes) => e.bytes(bytes)?,
        };
        Ok(())
    }
}

impl Decode<'_, ()> for TextOrBytes {
    fn decode(d: &mut Decoder<'_>, _ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
        match d.datatype()? {
            minicbor::data::Type::String => Ok(TextOrBytes::Text(d.str()?.to_string())),
            minicbor::data::Type::Bytes => Ok(TextOrBytes::Bytes(d.bytes()?.to_vec())),
            _ => {
                Err(minicbor::decode::Error::message(
                    "Invalid TextOrBytes, value should be either String or Bytes",
                ))
            },
        }
    }
}

// ------------------Test----------------------

#[cfg(test)]
mod test_attribute {
    use asn1_rs::oid;

    use super::*;

    #[test]
    fn encode_decode_attribute_int() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        let mut attribute = Attribute::new(oid!(1.2.840 .113549 .1 .9 .1));
        attribute.add_value(TextOrBytes::Text("example@example.com".to_string()));
        attribute
            .encode(&mut encoder, &mut ())
            .expect("Failed to encode Attribute");
        assert_eq!(
            hex::encode(buffer.clone()),
            "00736578616d706c65406578616d706c652e636f6d"
        );

        let mut decoder = Decoder::new(&buffer);
        let attribute_decoded =
            Attribute::decode(&mut decoder, &mut ()).expect("Failed to decode Attribute");
        assert_eq!(attribute_decoded, attribute);
    }

    #[test]
    fn empty_attribute_value() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        let attribute = Attribute::new(oid!(1.2.840 .113549 .1 .9 .1));
        attribute
            .encode(&mut encoder, &mut ())
            .expect_err("Failed to encode Attribute");
    }
}
