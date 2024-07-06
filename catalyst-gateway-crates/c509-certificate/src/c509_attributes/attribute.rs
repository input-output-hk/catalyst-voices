//! C509 Attribute
//! Attribute fallback of C509 OID
//! Given OID is not found in the registered attribute table, it will be encoded as a PEN OID.
//! If the OID is not a PEN OID, it will be encoded as an unwrapped OID.
//!
//! Attribute = ( attributeType: int, attributeValue: text ) //
//! ( attributeType: ~oid, attributeValue: bytes ) //
//! ( attributeType: pen, attributeValue: bytes )

use asn1_rs::Oid;
use minicbor::{encode::Write, Decode, Decoder, Encode, Encoder};

use crate::c509_oid::{C509oid, C509oidRegistered};

use super::data::ATTRIBUTES_TABLES;

#[derive(Debug, Clone, PartialEq)]
pub struct Attribute {
    registered_oid: C509oidRegistered,
    value: TextOrBytes,
}

#[allow(dead_code)]
impl Attribute {
    pub(crate) fn new(oid: Oid<'static>, value: TextOrBytes) -> Self {
        Self {
            registered_oid: C509oidRegistered::new(oid, &ATTRIBUTES_TABLES.get_int_to_oid_table())
                .pen_encoded(),
            value,
        }
    }

    pub(crate) fn get_registered_oid(&self) -> &C509oidRegistered {
        &self.registered_oid
    }

    pub(crate) fn get_value(&self) -> &TextOrBytes {
        &self.value
    }
}

impl Encode<()> for Attribute {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        // Handle CBOR int
        if let Some(&oid) = self
            .registered_oid
            .get_table()
            .get_map()
            .get_by_right(&self.registered_oid.get_c509_oid().get_oid())
        {
            e.i16(oid)?;
        } else {
            // Handle unwrapped CBOR OID or CBOR PEN
            self.registered_oid.get_c509_oid().encode(e, ctx)?;
        }
        self.value.encode(e, ctx)?;
        Ok(())
    }
}

impl Decode<'_, ()> for Attribute {
    fn decode(d: &mut Decoder<'_>, ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
        // Range of attribute int is from 0 - 30
        if minicbor::data::Type::U8 == d.datatype()? {
            let oid_value = d.i16()?;
            let oid = ATTRIBUTES_TABLES
                .get_int_to_oid_table()
                .get_map()
                .get_by_left(&oid_value)
                .ok_or_else(|| minicbor::decode::Error::message("OID int not found"))?;
            let value = TextOrBytes::decode(d, ctx)?;
            Ok(Attribute::new(oid.to_owned(), value))
        } else {
            let c509_oid: C509oid = d.decode()?;
            let value = TextOrBytes::decode(d, ctx)?;
            Ok(Attribute::new(c509_oid.get_oid(), value))
        }
    }
}

// FIXME - Consider move this to other module
#[allow(dead_code)]
#[derive(Debug, Clone, PartialEq)]
pub(crate) enum TextOrBytes {
    Text(String),
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
            _ => Err(minicbor::decode::Error::message(
                "Invalid TextOrBytes, value should be either String or Bytes",
            )),
        }
    }
}

#[cfg(test)]
mod test_attribute {
    use super::*;
    use asn1_rs::oid;

    #[test]
    fn encode_decode_attribute_int() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        let attribute = Attribute::new(
            oid!(1.2.840 .113549 .1 .9 .1),
            TextOrBytes::Text("example@example.com".to_string()),
        );
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
}
