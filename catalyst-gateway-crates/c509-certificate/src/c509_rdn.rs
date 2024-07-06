use minicbor::{encode::Write, Decode, Decoder, Encode, Encoder};

use crate::c509_attributes::attribute::Attribute;

#[derive(Debug, Clone, PartialEq)]
pub(crate) struct RelativeDistinguishedName {
    attributes: Vec<Attribute>,
}

impl RelativeDistinguishedName {
    pub fn new() -> Self {
        Self {
            attributes: Vec::new(),
        }
    }

    pub fn add(&mut self, attribute: Attribute) {
        self.attributes.push(attribute);
    }

    pub fn get_attributes(&self) -> &Vec<Attribute> {
        &self.attributes
    }
}

impl Encode<()> for RelativeDistinguishedName {
    /// RelativeDistinguishedName = Attribute / [ 2* Attribute ]
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        if self.attributes.len() == 1 {
            self.attributes[0].encode(e, ctx)?;
        } else {
            // The attribute type should be included in array too
            e.array(self.attributes.len() as u64 * 2)?;
            for attr in &self.attributes {
                attr.encode(e, ctx)?;
            }
        }
        Ok(())
    }
}

impl Decode<'_, ()> for RelativeDistinguishedName {
    fn decode(d: &mut Decoder<'_>, ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
        let mut rdn = RelativeDistinguishedName::new();
        if minicbor::data::Type::Array == d.datatype()? {
            let len = d.array()?.ok_or(minicbor::decode::Error::message(
                "Failed to get array length for relative distinguished name",
            ))?;
            // The attribute type is included in an array, so divide by 2
            for _ in 0..len / 2 {
                rdn.add(Attribute::decode(d, ctx)?);
            }
        } else {
            rdn.add(Attribute::decode(d, ctx)?);
        }
        Ok(rdn)
    }
}

// -----------------------------------------

#[cfg(test)]
mod test_relative_distinguished_name {

    use crate::c509_attributes::attribute::TextOrBytes;

    use super::*;
    use asn1_rs::oid;

    #[test]
    fn encode_decode_rdn() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        let mut rdn = RelativeDistinguishedName::new();
        rdn.add(Attribute::new(
            oid!(1.2.840 .113549 .1 .9 .1),
            TextOrBytes::Text("example@example.com".to_string()),
        ));
        rdn.encode(&mut encoder, &mut ())
            .expect("Failed to encode RDN");
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
        let mut rdn = RelativeDistinguishedName::new();
        rdn.add(Attribute::new(
            oid!(1.2.840 .113549 .1 .9 .1),
            TextOrBytes::Text("example@example.com".to_string()),
        ));
        rdn.add(Attribute::new(
            oid!(2.5.4 .3),
            TextOrBytes::Text("example".to_string()),
        ));
        rdn.encode(&mut encoder, &mut ())
            .expect("Failed to encode RDN");
        assert_eq!(
            hex::encode(buffer.clone()),
            "8200736578616d706c65406578616d706c652e636f6d01676578616d706c65"
        );
        let mut decoder = Decoder::new(&buffer);
        let rdn_decoded = RelativeDistinguishedName::decode(&mut decoder, &mut ())
            .expect("Failed to decode RelativeDistinguishedName");
        assert_eq!(rdn_decoded, rdn);
    }
}
