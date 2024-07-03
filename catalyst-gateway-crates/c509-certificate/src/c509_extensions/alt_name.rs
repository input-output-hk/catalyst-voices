//! C509 Alternative Name uses for Subject Alternative Name extension and
//! Issuer Alternative Name extension.

// FIXME - revisit visibility

use minicbor::{encode::Write, Decode, Decoder, Encode, Encoder};

use crate::c509_general_name::GeneralNames;


/// Enum for type that can be a `GeneralNames` or a text.
#[derive(Debug, Clone, PartialEq)]
pub(crate) enum GeneralNamesOrText {
    GeneralNames(GeneralNames),
    Text(String),
}

/// Alternative Name extension.
/// Can be interpreted as a GeneralNames / text
///
/// # Fields
/// * value - A value of alternative name that can be either a `GeneralNames` or a text.
#[derive(Debug, Clone, PartialEq)]
pub(crate) struct AltName {
    value: GeneralNamesOrText,
}

impl AltName {
    /// Create a new instance of AltName given value.
    fn new(value: GeneralNamesOrText) -> Self {
        Self { value }
    }
}

impl Encode<()> for AltName {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        match &self.value {
            GeneralNamesOrText::GeneralNames(gns) => {
                // Check whether there is only 1 item in the array which is a DNSName
                if gns.get_gns().len() == 1 && gns.get_gns()[0].get_gn().is_dns_name() {
                    gns.get_gns()[0].get_gn_value().encode(e, ctx)?
                } else {
                    gns.encode(e, ctx)?
                }
            },
            GeneralNamesOrText::Text(text) => {
                e.str(&text)?;
            },
        }
        Ok(())
    }
}

impl Decode<'_, ()> for AltName {
    fn decode(d: &mut Decoder<'_>, ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
        // FIXME - can't distinguish between GeneralNames(only DNSName) and Text
        match d.datatype()? {
            minicbor::data::Type::String => {
                let text = d.str()?;
                Ok(AltName::new(GeneralNamesOrText::Text(text.to_string())))
            },
            minicbor::data::Type::Array => {
                let gns = GeneralNames::decode(d, ctx)?;
                Ok(AltName::new(GeneralNamesOrText::GeneralNames(gns)))
            },
            _ => Err(minicbor::decode::Error::message("Invalid type for AltName")),
        }
    }
}

#[cfg(test)]
mod test_alt_name {
    use crate::c509_general_name::{GeneralName, GeneralNameRegistry, GeneralNameValue};

    use super::*;

    #[test]
    fn test_encode_alt_name_only_dns() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        let mut gns = GeneralNames::new();
        gns.add(GeneralName::new(
            GeneralNameRegistry::DNSName,
            GeneralNameValue::Text("example.com".to_string()),
        ));
        let alt_name = AltName::new(GeneralNamesOrText::GeneralNames(gns));
        alt_name
            .encode(&mut encoder, &mut ())
            .expect("Failed to encode AltName");
        // "example.com": 0x6b6578616d706c652e636f6d
        assert_eq!(hex::encode(buffer.clone()), "6b6578616d706c652e636f6d");
    }

    #[test]
    fn test_encode_decode_alt_name_text() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        let alt_name = AltName::new(GeneralNamesOrText::Text("example.com".to_string()));
        alt_name
            .encode(&mut encoder, &mut ())
            .expect("Failed to encode AltName");
        // "example.com": 0x6b6578616d706c652e636f6d
        assert_eq!(hex::encode(buffer.clone()), "6b6578616d706c652e636f6d");

        let mut decoder = Decoder::new(&buffer);
        let decoded_alt_name =
            AltName::decode(&mut decoder, &mut ()).expect("Failed to decode Alternative Name");
        assert_eq!(decoded_alt_name, alt_name);
    }
}
