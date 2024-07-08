//! C509 `Attributes` containing `Attribute`
//!
//! ```cddl
//! Attributes = ( attributeType: int, attributeValue: [+text] ) //
//! ( attributeType: ~oid, attributeValue: [+bytes] )
//!
//! Use case:
//! ```cddl
//! SubjectDirectoryAttributes = [+Attributes]
//! ```

use attribute::Attribute;
use minicbor::{encode::Write, Decode, Decoder, Encode, Encoder};

pub mod attribute;
mod data;

/// A struct of C509 `Attributes` containing a vector of `Attribute`.
#[derive(Debug, Clone, PartialEq)]
pub struct Attributes(Vec<Attribute>);

impl Default for Attributes {
    fn default() -> Self {
        Self::new()
    }
}

impl Attributes {
    /// Create a new instance of `Attributes` as empty vector.
    pub fn new() -> Self {
        Self(Vec::new())
    }

    /// Add an `Attribute` to the `Attributes`.
    /// and set `Attribute` value to support multiple value.
    pub fn add_attr(&mut self, attribute: Attribute) {
        self.0.push(attribute.set_multi_value());
    }
}

impl Encode<()> for Attributes {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        if self.0.is_empty() {
            return Err(minicbor::encode::Error::message(
                "Attributes should not be empty",
            ));
        }
        e.array(self.0.len() as u64)?;
        for attribute in &self.0 {
            attribute.encode(e, ctx)?;
        }
        Ok(())
    }
}

impl Decode<'_, ()> for Attributes {
    fn decode(d: &mut Decoder<'_>, _ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
        let len = d
            .array()?
            .ok_or_else(|| minicbor::decode::Error::message("Failed to get array length"))?;
        let mut attributes = Attributes::new();

        for _ in 0..len {
            let attribute = Attribute::decode(d, &mut ())?;
            attributes.add_attr(attribute);
        }

        Ok(attributes)
    }
}

// ------------------Test----------------------

#[cfg(test)]
mod test_attributes {
    use asn1_rs::oid;
    use attribute::TextOrBytes;

    use super::*;

    #[test]
    fn encode_decode_attributes_int() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        let mut attr = Attribute::new(oid!(1.2.840 .113549 .1 .9 .1));
        attr.add_value(TextOrBytes::Text("example@example.com".to_string()));
        attr.add_value(TextOrBytes::Text("example@example.com".to_string()));
        let mut attributes = Attributes::new();
        attributes.add_attr(attr);
        attributes
            .encode(&mut encoder, &mut ())
            .expect("Failed to encode Attributes");
        assert_eq!(
            hex::encode(buffer.clone()),
            "810082736578616d706c65406578616d706c652e636f6d736578616d706c65406578616d706c652e636f6d"
        );

        let mut decoder = Decoder::new(&buffer);
        let attribute_decoded =
            Attributes::decode(&mut decoder, &mut ()).expect("Failed to decode Attributes");
        assert_eq!(attribute_decoded, attributes);
    }

    #[test]
    fn empty_attributes() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        let attributes = Attributes::new();
        attributes
            .encode(&mut encoder, &mut ())
            .expect_err("Failed to encode Attributes");
    }
}
