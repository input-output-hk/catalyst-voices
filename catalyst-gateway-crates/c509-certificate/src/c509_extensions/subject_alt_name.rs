//! Subject Alternative Name
//!

use minicbor::{encode::Write, Encode, Encoder};

use crate::c509_general_name::GeneralNames;

/// SubjectAltName = GeneralNames / text
#[allow(dead_code)]
pub(crate) enum GeneralNamesOrText {
    GeneralNames(GeneralNames),
    Text(String),
}

#[allow(dead_code)]
pub(crate) struct AltName {
    value: GeneralNamesOrText,
}

impl AltName {
    fn new(value: GeneralNamesOrText) -> Self {
        Self { value }
    }
}

impl<C> Encode<C> for AltName {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, _ctx: &mut C,
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        match &self.value {
            GeneralNamesOrText::GeneralNames(gns) => {
                // FIXME - ugly
                // Check whether there is only 1 item in the array which is a DNSName
                if gns.get_gns().len() == 1 && gns.get_gns()[0].get_gn().get_int() == 2 {
                    Ok(gns.get_gns()[0].get_gn().encode(e, &mut ()))?
                } else {
                    Ok(gns.encode(e, &mut ()))?
                }
            },
            GeneralNamesOrText::Text(text) => {
                e.str(&text)?;
                Ok(())
            },
        }
    }
}

#[cfg(test)]
mod test_alt_name {
    use crate::c509_general_name::{GeneralName, GeneralNamesRegistry};

    use super::*;

    #[test]
    fn test_encode_decode_alt_name_only_dns() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        let mut gns = GeneralNames::new();
        gns.add(GeneralName::new(GeneralNamesRegistry::DNSName(
            "example.com".to_string(),
        )));
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
    }
}
