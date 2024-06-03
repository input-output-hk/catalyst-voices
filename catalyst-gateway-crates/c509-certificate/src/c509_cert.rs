use minicbor::Encoder;
use wasm_bindgen::prelude::wasm_bindgen;

use crate::{
    c509_enum::{C509CertificateType, PubKeyAlgoRegistry, SignatureAlgoRegistry},
    cbor_encoder::{CborEncoder, Name, Time, UnwrappedBiguint},
    extensions::{encode_extensions, Extensions},
};

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

#[allow(unused)]
fn encode_signature_algorithm(
    sig_algo: SignatureAlgoRegistry, encoder: &mut Encoder<&mut Vec<u8>>,
) {
    let _unused = encoder.i8(sig_algo as i8);
}

#[allow(unused)]
fn encode_signature_value(sig_value: Vec<u8>, encoder: &mut Encoder<&mut Vec<u8>>) {
    // For natively signed C509 certificates
    todo!()
}

#[wasm_bindgen]
pub struct TbsCertificate {
    certificate_type: C509CertificateType,
    certificate_serial_number: UnwrappedBiguint,
    issuer: Name,
    validity_not_before: Time,
    validity_not_after: Time,
    subject: Name,
    subject_public_key_algo: PubKeyAlgoRegistry,
    subject_public_key: Vec<u8>,
    extensions: Extensions,
    issuer_sig_algo: SignatureAlgoRegistry,
}

#[allow(unused)]
pub(crate) fn generate_c509_cert(tbs_cert: TbsCertificate) -> Vec<u8>{
    let mut buffer: Vec<u8> = Vec::new();

    // Create a new encoder, passing the buffer by mutable reference
    let mut encoder: Encoder<&mut Vec<u8>> = Encoder::new(&mut buffer);
    // Encode the certificate type
    encoder.u8(tbs_cert.certificate_type as u8).unwrap();
    // Encode the certificate serial number
    tbs_cert.certificate_serial_number.encode(&mut encoder);
    // Encode issuer
    tbs_cert.issuer.encode(&mut encoder);
    // Encode validity_not_before
    tbs_cert.validity_not_before.encode(&mut encoder);
    // Encode validity_not_after
    tbs_cert.validity_not_after.encode(&mut encoder);
    // Encode subject
    tbs_cert.subject.encode(&mut encoder);
    // Encode subject public key
    encode_subject_public_key(
        tbs_cert.subject_public_key_algo,
        tbs_cert.subject_public_key,
        &mut encoder,
    );
    // Encode extensions
    encode_extensions(tbs_cert.extensions, &mut encoder);
    // Encode issuer signature algorithm
    encode_signature_algorithm(tbs_cert.issuer_sig_algo, &mut encoder);
    buffer
}
#[cfg(test)]
#[allow(unused)]
mod tests {

    use std::ops::Sub;

    use crate::c509_enum::AttributesRegistry;
    use crate::cbor_encoder::{AttributeRegistryValue, RelativeDistinguishedName, StringType};
    use crate::extensions::alt_name::{AltName, GeneralName, GeneralNamesRegistry, GeneralNamesRegistryType};
    use crate::extensions::{Extension, ExtensionRegistry, ExtensionValue};

    use super::*;

    #[test]
    fn test_generate_c509() {
        let issuer: Name = vec![RelativeDistinguishedName {
            name: AttributesRegistry::CommonName,
            value: AttributeRegistryValue {
                str_type: StringType::Utf8String,
                str_value: "RFC test CA".to_string(),
            },
        }];
        let subject: Name = vec![RelativeDistinguishedName {
            name: AttributesRegistry::CommonName,
            value: AttributeRegistryValue {
                str_type: StringType::Utf8String,
                str_value: "01-23-45-FF-FE-67-89-AB".to_string(),
            },
        }];
        // FIXME - Recheck
        let pub_key_ed25519 = vec![
            25, 191, 68, 9, 105, 84, 205, 254, 85, 41, 186, 193, 67, 220, 59, 150, 200, 80, 86,
            170, 48, 182, 182, 203, 12, 92, 56, 173, 112, 49, 102, 225,
        ];
        // FIXME - Recheck
        let extensions: Extensions = vec![Extension {
            extension_type: ExtensionRegistry::SubjectAltName,
            extension_value: ExtensionValue::SubjectAltName(AltName {
                general_names: vec![GeneralName {
                    gn_name: GeneralNamesRegistry::DNSName,
                    gn_value: GeneralNamesRegistryType::String("example.com".to_string()),
                }],
                critical: false,
            }),
        }];

        let tbs_cert = TbsCertificate {
            certificate_type: C509CertificateType::SignedC509Cert,
            certificate_serial_number: UnwrappedBiguint::U64Value(128269),
            issuer,
            validity_not_before: 1672531200,
            validity_not_after: 1767225600,
            subject,
            subject_public_key_algo: PubKeyAlgoRegistry::Ed25519,
            subject_public_key: pub_key_ed25519,
            extensions,
            issuer_sig_algo: SignatureAlgoRegistry::Ed25519,
        };
        let buffer = generate_c509_cert(tbs_cert);
        println!("{:?}", buffer);
    }
}
