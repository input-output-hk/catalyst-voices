//! C509 Name
//!  Name = [ * RelativeDistinguishedName ] / text / bytes
//! RelativeDistinguishedName = Attribute / [ 2* Attribute ]
//! Attribute = ( attributeType: int, attributeValue: text ) //
//!             ( attributeType: ~oid, attributeValue: bytes ) //
//!             ( attributeType: pen, attributeValue: bytes )

use asn1_rs::{oid, Oid};
use minicbor::{encode::Write, Decode, Decoder, Encode, Encoder};
use regex::Regex;

use crate::{
    c509_attributes::attribute::{Attribute, TextOrBytes},
    c509_rdn::RelativeDistinguishedName,
};

const COMMON_NAME_OID: Oid<'static> = oid!(2.5.4 .3);

#[derive(Debug, Clone, PartialEq)]
pub enum NameValue {
    RelativeDistinguishedName(RelativeDistinguishedName),
    Text(String),
    Bytes(Vec<u8>),
}

#[derive(Debug, Clone, PartialEq)]
pub struct Name {
    value: NameValue,
}

impl Name {
    pub fn new(value: NameValue) -> Self {
        Self { value }
    }
}

impl Encode<()> for Name {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        match &self.value {
            NameValue::RelativeDistinguishedName(rdn) => {
                let attr = rdn.get_attributes();
                //  If Name contains a single Attribute of type CommonName
                if attr.len() == 1
                    && attr[0].get_registered_oid().get_c509_oid().get_oid() == COMMON_NAME_OID
                {
                    let cn_value = &attr[0].get_value();

                    encode_cn_value(e, cn_value)?;
                } else {
                    rdn.encode(e, ctx)?;
                }
            },
            NameValue::Text(text) => {
                e.str(&text)?;
            },
            NameValue::Bytes(bytes) => {
                e.bytes(&bytes)?;
            },
        }
        Ok(())
    }
}

fn encode_cn_value<W: Write>(
    e: &mut Encoder<W>, cn_value: &TextOrBytes,
) -> Result<(), minicbor::encode::Error<W::Error>> {
    let hex_regex = Regex::new(r"^[0-9a-fA-F]+$")
        .map_err(|e| minicbor::encode::Error::message(format!("{e}")))?;
    let eui64_regex = Regex::new(r"^([0-9A-Fa-f]{2}-){7}[0-9A-Fa-f]{2}$")
        .map_err(|e| minicbor::encode::Error::message(format!("{e}")))?;

    let mac_eui64_regex =
        Regex::new(r"^([0-9A-Fa-f]{2}-){3}FF-FE-([0-9A-Fa-f]{2}-){2}[0-9A-Fa-f]{2}$")
            .map_err(|e| minicbor::encode::Error::message(format!("{e}")))?;

    match cn_value {
        TextOrBytes::Text(s) => {
            if s.contains('-') {
                let clean_name = s.replace("-", "");
                let decoded_bytes = hex::decode(&clean_name)
                    .map_err(|e| minicbor::encode::Error::message(format!("{e}")))?;

                if hex_regex.is_match(s) && s.len() % 2 == 0 {
                    e.bytes(&[&[0x00], &decoded_bytes[..]].concat())?;
                } else if mac_eui64_regex.is_match(s) {
                    e.bytes(&[&[0x01], &decoded_bytes[..3], &decoded_bytes[5..]].concat())?;
                } else if eui64_regex.is_match(s) {
                    e.bytes(&[&[0x01], &decoded_bytes[..]].concat())?;
                }
            } else {
                e.str(s)?;
            }
        },
        TextOrBytes::Bytes(_) => {
            return Err(minicbor::encode::Error::message(
                "CommonName attribute value must be a text string",
            ));
        },
    }
    Ok(())
}

fn formatted_eui_bytes(data: &[u8]) -> String {
    data.iter()
        .map(|b| format!("{:02X}", b))
        .collect::<Vec<_>>()
        .join("-")
}

fn create_rdn(text: String) -> Result<Name, minicbor::decode::Error> {
    let mut rdn = RelativeDistinguishedName::new();
    rdn.add(Attribute::new(COMMON_NAME_OID, TextOrBytes::Text(text)));
    Ok(Name::new(NameValue::RelativeDistinguishedName(rdn)))
}

impl Decode<'_, ()> for Name {
    fn decode(d: &mut Decoder<'_>, ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
        // FIXME - can't distinguish between Name CommonName and Text
        match d.datatype()? {
            minicbor::data::Type::Array => Ok(Name::new(NameValue::RelativeDistinguishedName(
                RelativeDistinguishedName::decode(d, ctx)?,
            ))),
            minicbor::data::Type::String => Ok(Name::new(NameValue::Text(d.str()?.to_string()))),
            minicbor::data::Type::Bytes => decode_bytes(d),
            _ => {
                return Err(minicbor::decode::Error::message(
                    "Name must be an array, text or bytes",
                ))
            },
        }
    }
}

fn decode_bytes(d: &mut Decoder<'_>) -> Result<Name, minicbor::decode::Error> {
    let bytes = d.bytes()?;

    // Bytes prefix
    match bytes[0] {
        // 0x00 for hex
        0 => decode_hex_cn_bytes(bytes),
        // 0x01 for EUI
        1 => decode_eui_cn_bytes(bytes),
        _ => Ok(Name::new(NameValue::Bytes(bytes.to_vec()))),
    }
}

fn decode_hex_cn_bytes(bytes: &[u8]) -> Result<Name, minicbor::decode::Error> {
    let text = hex::encode(&bytes[1..]);
    Ok(Name::new(NameValue::Text(text)))
}

fn decode_eui_cn_bytes(bytes: &[u8]) -> Result<Name, minicbor::decode::Error> {
    // Check the lenght of the bytes to determine what EUI type it is
    match bytes.len() {
        // EUI-64 mapped from a 48-bit MAC address
        7 => {
            let data = [&bytes[1..4], &[0xFF], &[0xFE], &bytes[4..]].concat();
            let text = formatted_eui_bytes(&data);
            create_rdn(text)
        },
        // EUI-64
        9 => {
            let text = formatted_eui_bytes(&bytes[1..]);
            create_rdn(text)
        },
        _ => Err(minicbor::decode::Error::message(
            "EUI-64 or MAC address must be 7 or 9 bytes",
        )),
    }
}

// ------------------Test----------------------

#[cfg(test)]
mod test_name {
    use crate::c509_attributes::attribute::Attribute;

    use super::*;

    #[test]
    fn encode_type_name_cn() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let mut rdn = RelativeDistinguishedName::new();
        let cn_attr = Attribute::new(oid!(2.5.4 .3), TextOrBytes::Text("RFC test CA".to_string()));
        rdn.add(cn_attr);
        let name = Name::new(NameValue::RelativeDistinguishedName(rdn));

        name.encode(&mut encoder, &mut ())
            .expect("Failed to encode Name");

        // Test data from https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/
        // A.1.1.  Example C509 Certificate Encoding
        assert_eq!(hex::encode(buffer), "6b5246432074657374204341");
    }

    #[test]
    fn encode_decode_type_name_cn_eui_mac() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let mut rdn = RelativeDistinguishedName::new();
        let cn_attr = Attribute::new(
            oid!(2.5.4 .3),
            TextOrBytes::Text("01-23-45-FF-FE-67-89-AB".to_string()),
        );
        rdn.add(cn_attr);
        let name = Name::new(NameValue::RelativeDistinguishedName(rdn));

        name.encode(&mut encoder, &mut ())
            .expect("Failed to encode Name");

        // Test data from https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/
        // A.1.  Example RFC 7925 profiled X.509 Certificate
        assert_eq!(hex::encode(buffer.clone()), "47010123456789ab");

        let mut decoder = Decoder::new(&buffer);
        let name_decoded = Name::decode(&mut decoder, &mut ()).expect("Failed to decode Name");
        assert_eq!(name_decoded, name);
    }

    #[test]
    fn encode_decode_type_name_cn_eui() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let mut rdn = RelativeDistinguishedName::new();
        let cn_attr = Attribute::new(
            oid!(2.5.4 .3),
            TextOrBytes::Text("01-23-45-67-89-AB-00-01".to_string()),
        );
        rdn.add(cn_attr);
        let name = Name::new(NameValue::RelativeDistinguishedName(rdn));

        name.encode(&mut encoder, &mut ())
            .expect("Failed to encode Name");

        assert_eq!(hex::encode(buffer.clone()), "49010123456789ab0001");

        let mut decoder = Decoder::new(&buffer);
        let name_decoded = Name::decode(&mut decoder, &mut ()).expect("Failed to decode Name");
        assert_eq!(name_decoded, name);
    }

    #[test]
    fn encode_decode_type_name_rdns() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        // Test data from https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/
        // A.2.  Example IEEE 802.1AR profiled X.509 Certificate
        // Issuer: C=US, ST=CA, O=Example Inc, OU=certification, CN=802.1AR CA
        let mut rdn = RelativeDistinguishedName::new();
        rdn.add(Attribute::new(
            oid!(2.5.4 .6),
            TextOrBytes::Text("US".to_string()),
        ));
        rdn.add(Attribute::new(
            oid!(2.5.4 .8),
            TextOrBytes::Text("CA".to_string()),
        ));
        rdn.add(Attribute::new(
            oid!(2.5.4 .10),
            TextOrBytes::Text("Example Inc".to_string()),
        ));
        rdn.add(Attribute::new(
            oid!(2.5.4 .11),
            TextOrBytes::Text("certification".to_string()),
        ));
        rdn.add(Attribute::new(
            oid!(2.5.4 .3),
            TextOrBytes::Text("802.1AR CA".to_string()),
        ));

        let name = Name::new(NameValue::RelativeDistinguishedName(rdn));

        name.encode(&mut encoder, &mut ())
            .expect("Failed to encode Name");
        assert_eq!(
            hex::encode(buffer.clone()),
            "8a0462555306624341086b4578616d706c6520496e63096d63657274696669636174696f6e016a3830322e314152204341"
        );

        let mut decoder = Decoder::new(&buffer);
        let name_decoded = Name::decode(&mut decoder, &mut ()).expect("Failed to decode Name");
        assert_eq!(name_decoded, name);
    }
}
