use std::io;

use minicbor::{Encode, Encoder};
use regex::Regex;

use crate::c509_enum::StringType;

impl<'a> Encode<()> for StringType {
    fn encode<W: minicbor::encode::Write>(
        &self, e: &mut Encoder<W>, _: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        match self {
            StringType::Utf8String(text)
            | StringType::PrintableString(text)
            | StringType::Ia5String(text) => {
                // Convert the result from `Result<&mut Encoder<W>, _>` to `Result<(), _>`
                e.str(text).map(|_| ())
            },
            StringType::HexByteString(bytes) | StringType::Eui64ByteString(bytes) => {
                // Similarly, handle the return value correctly
                e.bytes(&bytes).map(|_| ())
            },
        }
    }
}

#[allow(unused)]
struct AttributeRegistry {
    name: String,
    value: String,
}

#[allow(unused)]
// If type Name contain single attribute common-name
fn type_name(
    b: Vec<AttributeRegistry>, encoder: &mut Encoder<&mut Vec<u8>>,
) -> Result<Vec<u8>, io::Error> {
    if b.len() == 1 {
        if b[0].name == "CN" {
            println!("common-name");
            encode_common_name(&b[0].value, encoder);
        }
    }
    Ok(Vec::new())
}

#[allow(unused)]
fn encode_common_name(name: &str, encoder: &mut Encoder<&mut Vec<u8>>) {
    // Compile Regex only once and handle errors gracefully
    let hex_regex = Regex::new(r"^[0-9a-fA-F]+$")
        .map_err(|e| io::Error::new(io::ErrorKind::InvalidData, e))
        .unwrap();
    let eui64_regex = Regex::new(r"^([0-9A-Fa-f]{2}-){7}[0-9A-Fa-f]{2}$")
        .map_err(|e| io::Error::new(io::ErrorKind::InvalidData, e))
        .unwrap();
    let mac_eui64_regex =
        Regex::new(r"^([0-9A-Fa-f]{2}-){3}FF-FE-([0-9A-Fa-f]{2}-){2}[0-9A-Fa-f]{2}$")
            .map_err(|e| io::Error::new(io::ErrorKind::InvalidData, e))
            .unwrap();

    if name.contains('-') {
        let clean_name = name.replace("-", "");
        let decoded_bytes = hex::decode(&clean_name)
            .map_err(|e| io::Error::new(io::ErrorKind::InvalidData, e))
            .unwrap();
        println!("{:?}", decoded_bytes);
        println!("name {}", name);
        println!("{:?}", hex_regex.is_match(name));
        if hex_regex.is_match(name) && name.len() % 2 == 0 {
            let data = [&[0x00], &decoded_bytes[..]].concat();
            encoder.bytes(&data).unwrap();
        } else if mac_eui64_regex.is_match(name) {
            let data: Vec<u8> = [&[0x01], &decoded_bytes[..3], &decoded_bytes[5..]].concat(); // Skip FF-FE bytes
            encoder.bytes(&data).unwrap();
        } else if eui64_regex.is_match(name) {
            let data = [&[0x01], &decoded_bytes[..]].concat();
            encoder.bytes(&data).unwrap();
        }
    } else {
        encoder.str(name).unwrap();
    }
}

#[cfg(test)]
#[allow(unused)]
mod tests {

    use crate::{c509_enum::PubKeyAlgoRegistry, cbor::cbor_encode_integer_as_bytestring};

    use super::*;

    #[test]
    fn test_generate_c509() {
        let version = 1;
        let serial_number = 128269;

        let not_before = 1672531200;
        let not_after = 1767225600;
        // Create a buffer to hold the CBOR data
        let mut buffer: Vec<u8> = Vec::new();

        // Create a new encoder, passing the buffer by mutable reference
        let mut encoder: Encoder<&mut Vec<u8>> = Encoder::new(&mut buffer);
        encoder.u8(version).unwrap();
        cbor_encode_integer_as_bytestring(serial_number, &mut encoder);
        type_name(
            vec![AttributeRegistry {
                name: "CN".to_string(),
                value: "RFC test CA".to_string(),
            }],
            &mut encoder,
        );
        encoder.u32(not_before).unwrap();
        encoder.u32(not_after).unwrap();
        type_name(
            vec![AttributeRegistry {
                name: "CN".to_string(),
                value: "01-23-45-FF-FE-67-89-AB".to_string(),
            }],
            &mut encoder,
        );
        encoder.u8(PubKeyAlgoRegistry::Secp256r1 as u8).unwrap();
        println!("Encoded: {:?}", buffer);
    }
}
