use minicbor::Encoder;

use crate::c509_enum::PubKeyAlgoRegistry;

#[allow(unused)]
fn encode_subject_public_key(
    pubk_type: PubKeyAlgoRegistry, pubk: Vec<u8>, encoder: &mut Encoder<&mut Vec<u8>>,
) {
    // RSA public keys
    if pubk_type == PubKeyAlgoRegistry::RSA {
        println!("Not support yet");
    // Elliptic curve public keys in Weierstraß
    } else if [
        PubKeyAlgoRegistry::Secp256r1,
        PubKeyAlgoRegistry::Secp384r1,
        PubKeyAlgoRegistry::Secp521r1,
        PubKeyAlgoRegistry::Brainpool256r1,
        PubKeyAlgoRegistry::Brainpool384r1,
        PubKeyAlgoRegistry::Brainpool512r1,
        PubKeyAlgoRegistry::Frp256v1,
        PubKeyAlgoRegistry::SM2P256v1,
    ]
    .contains(&pubk_type)
    {
        println!("Not support yet");
    } else {
        encoder.bytes(&pubk);
    }
}

// #[cfg(test)]
// #[allow(unused)]
// mod tests {

//     use crate::{c509_enum::PubKeyAlgoRegistry, cbor::cbor_encode_integer_as_bytestring};

//     use super::*;

//     #[test]
//     fn test_generate_c509() {
//         let version = 1;
//         let serial_number = 128269;

//         let not_before = 1672531200;
//         let not_after = 1767225600;
//         // Create a buffer to hold the CBOR data
//         let mut buffer: Vec<u8> = Vec::new();

//         // Create a new encoder, passing the buffer by mutable reference
//         let mut encoder: Encoder<&mut Vec<u8>> = Encoder::new(&mut buffer);
//         encoder.u8(version).unwrap();
//         cbor_encode_integer_as_bytestring(serial_number, &mut encoder);
//         type_name(
//             vec![AttributeRegistry {
//                 name: "CN".to_string(),
//                 value: "RFC test CA".to_string(),
//             }],
//             &mut encoder,
//         );
//         encoder.u32(not_before).unwrap();
//         encoder.u32(not_after).unwrap();
//         type_name(
//             vec![AttributeRegistry {
//                 name: "CN".to_string(),
//                 value: "01-23-45-FF-FE-67-89-AB".to_string(),
//             }],
//             &mut encoder,
//         );
//         encoder.u8(PubKeyAlgoRegistry::Secp256r1 as u8).unwrap();
//         println!("Encoded: {:?}", buffer);
//     }
// }
