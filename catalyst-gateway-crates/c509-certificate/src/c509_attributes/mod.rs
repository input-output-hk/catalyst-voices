//! C509 Attributes containing Attribute

use attribute::Attribute;
use minicbor::{encode::Write, Decode, Decoder, Encode, Encoder};

pub mod attribute;
mod data;

/// A struct of C509 Attributes.
///
/// # Fields
/// * `attributes` - The vector of `Attribute`.
#[derive(Debug, Clone, PartialEq)]
pub struct Attributes {
    attributes: Vec<Attribute>,
}

impl Attributes {
    /// Create a new instance of `Attributes` as empty vector.
    pub fn new() -> Self {
        Self {
            attributes: Vec::new(),
        }
    }

    /// Add an `Attribute` to the `Attributes`.
    pub fn add(&mut self, attribute: Attribute) {
        self.attributes.push(attribute);
    }
}

impl Encode<()> for Attributes {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        e.array(self.attributes.len() as u64)?;
        Ok(for attribute in &self.attributes {
            attribute.encode(e, ctx)?;
        })
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
            attributes.add(attribute);
        }

        Ok(attributes)
    }
}
