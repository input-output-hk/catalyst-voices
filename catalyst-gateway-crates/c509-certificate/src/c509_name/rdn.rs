//! C509 Relative Distinguished Name
//!
//! For more information about `RelativeDistinguishedName`,
//! visit [C509 Certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/)

// cspell: words rdns

use minicbor::{encode::Write, Decode, Decoder, Encode, Encoder};
use serde::{Deserialize, Serialize};

use crate::c509_attributes::attribute::Attribute;

/// A struct represents a Relative Distinguished Name containing vector of `Attribute`.
///
/// ```cddl
/// RelativeDistinguishedName = Attribute / [ 2* Attribute ]
/// ```
#[derive(Debug, Clone, PartialEq, Deserialize, Serialize)]
pub struct RelativeDistinguishedName(Vec<Attribute>);

impl Default for RelativeDistinguishedName {
    fn default() -> Self {
        Self::new()
    }
}

impl RelativeDistinguishedName {
    /// Create a new instance of `RelativeDistinguishedName` as empty vector.
    #[must_use]
    pub fn new() -> Self {
        Self(Vec::new())
    }

    /// Add an `Attribute` to the `RelativeDistinguishedName`.
    pub fn add_attr(&mut self, attribute: Attribute) {
        // RelativeDistinguishedName support pen encoding
        self.0.push(attribute.set_pen_supported());
    }

    /// Get the a vector of `Attribute`.
    pub(crate) fn get_attributes(&self) -> &Vec<Attribute> {
        &self.0
    }
}

impl Encode<()> for RelativeDistinguishedName {
    // ```cddl
    // RelativeDistinguishedName = Attribute / [ 2* Attribute ]
    // ```
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        // Should contain >= 1 attribute
        if self.0.is_empty() {
            return Err(minicbor::encode::Error::message(
                "RelativeDistinguishedName should not be empty",
            ));
        }

        if self.0.len() == 1 {
            self.0.first().encode(e, ctx)?;
        } else {
            // The attribute type should be included in array too
            e.array(self.0.len() as u64 * 2)?;
            for attr in &self.0 {
                attr.encode(e, ctx)?;
            }
        }
        Ok(())
    }
}

impl Decode<'_, ()> for RelativeDistinguishedName {
    fn decode(d: &mut Decoder<'_>, ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
        let mut rdn = RelativeDistinguishedName::new();

        match d.datatype()? {
            minicbor::data::Type::Array => {
                let len = d.array()?.ok_or(minicbor::decode::Error::message(
                    "Failed to get array length for relative distinguished name",
                ))?;
                // Should contain >= 1 attribute
                if len == 0 {
                    return Err(minicbor::decode::Error::message(
                        "RelativeDistinguishedName should not be empty",
                    ));
                }
                // The attribute type is included in an array, so divide by 2
                for _ in 0..len / 2 {
                    rdn.add_attr(Attribute::decode(d, ctx)?);
                }
            },
            _ => rdn.add_attr(Attribute::decode(d, ctx)?),
        }
        Ok(rdn)
    }
}

// -------------------Test----------------------

#[cfg(test)]
mod test_relative_distinguished_name {

    use asn1_rs::oid;

    use super::*;
    use crate::c509_attributes::attribute::AttributeValue;

    #[test]
    fn encode_decode_rdn() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let mut attr = Attribute::new(oid!(1.2.840 .113549 .1 .9 .1));
        attr.add_value(AttributeValue::Text("example@example.com".to_string()));

        let mut rdn = RelativeDistinguishedName::new();
        rdn.add_attr(attr);
        rdn.encode(&mut encoder, &mut ())
            .expect("Failed to encode RDN");
        // Email Address: 0x00
        // "example@example.como": 736578616d706c65406578616d706c652e636f6d
        assert_eq!(
            hex::encode(buffer.clone()),
            "00736578616d706c65406578616d706c652e636f6d"
        );

        let mut decoder = Decoder::new(&buffer);
        let rdn_decoded = RelativeDistinguishedName::decode(&mut decoder, &mut ())
            .expect("Failed to decode RelativeDistinguishedName");
        assert_eq!(rdn_decoded, rdn);
    }

    #[test]
    fn encode_decode_rdns() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let mut attr1 = Attribute::new(oid!(1.2.840 .113549 .1 .9 .1));
        attr1.add_value(AttributeValue::Text("example@example.com".to_string()));
        let mut attr2 = Attribute::new(oid!(2.5.4 .3));
        attr2.add_value(AttributeValue::Text("example".to_string()));

        let mut rdns = RelativeDistinguishedName::new();
        rdns.add_attr(attr1);
        rdns.add_attr(attr2);

        rdns.encode(&mut encoder, &mut ())
            .expect("Failed to encode RDN");
        // Array of 2 attributes: 0x84
        // Email Address example@example.com: 0x00736578616d706c65406578616d706c652e636f6d
        // Common Name example: 0x01676578616d706c65
        assert_eq!(
            hex::encode(buffer.clone()),
            "8400736578616d706c65406578616d706c652e636f6d01676578616d706c65"
        );
        let mut decoder = Decoder::new(&buffer);
        let rdn_decoded = RelativeDistinguishedName::decode(&mut decoder, &mut ())
            .expect("Failed to decode RelativeDistinguishedName");
        assert_eq!(rdn_decoded, rdns);
    }

    #[test]
    fn empty_rdn() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        let rdn = RelativeDistinguishedName::new();
        rdn.encode(&mut encoder, &mut ())
            .expect_err("Failed to encode RDN");
    }
}
