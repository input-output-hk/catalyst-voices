//! This module provides essential functions for encoding and generating C509
//! certificates. Please refer to the [c509-certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/) for more information.

use minicbor::Encoder;
use wasm_bindgen::prelude::wasm_bindgen;

use crate::{
    c509_enum::{C509CertificateType, PubKeyAlgoRegistry, SignatureAlgoRegistry},
    cbor_encoder::{CborEncoder, Name, Time, UnwrappedBiguint},
    extensions::{encode_extensions, Extensions},
};

// ---------------------------------------------------

/// Encodes the subject public key information.
///
/// # Arguments
///
/// * `pubk_type` - The type of the public key algorithm.
/// * `pubk` - The public key bytes.
/// * `encoder` - A mutable reference to a `minicbor::Encoder` to encode the extensions
///   into.
///
/// # Panics
///
/// Panics if the public key type is not supported (RSA and Elliptic curve in Weierstraß
/// public keys).
///
/// # References
///
/// Please refer to the [c509-certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/) Section 3.1. Message Fields -> subjectPublicKeyInfo for more information.
fn encode_subject_public_key(
    pubk_type: PubKeyAlgoRegistry, pubk: Vec<u8>, encoder: &mut Encoder<&mut Vec<u8>>,
) {
    // RSA public keys
    if pubk_type == PubKeyAlgoRegistry::RSA {
        panic!("Not support yet");
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
        panic!("Not support yet");
    } else {
        let _unused = encoder.i8(pubk_type as i8);
        let _unused = encoder.bytes(&pubk);
    }
}

// ---------------------------------------------------

/// Encodes the signature algorithm information.
///
/// # Arguments
///
/// * `sig_algo` - The signature algorithm.
/// * `encoder` - A mutable reference to a `minicbor::Encoder` to encode the extensions
///   into.
/// Please refer to the [c509-certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/) Section 3.1. Message Fields -> signatureAlgorithm for more information.
fn encode_signature_algorithm(
    sig_algo: SignatureAlgoRegistry, encoder: &mut Encoder<&mut Vec<u8>>,
) {
    let _unused = encoder.i8(sig_algo as i8);
}

// ---------------------------------------------------

/// Encodes the issuer signature value.
///
/// # Arguments
///
/// * `_sig_value` - The signature value (currently unused).
/// * `encoder` - A mutable reference to a `minicbor::Encoder` to encode the extensions
///   into.
///
/// # Remarks
/// This function will be implemented in the future.
/// Please refer to the [c509-certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/) Section 3.1. Message Fields -> signatureValue for more information.
fn encode_issuer_signature_value(_sig_value: Vec<u8>, encoder: &mut Encoder<&mut Vec<u8>>) {
    // Currently will generate an unsigned C509 certificates,
    // hence the value is null
    let _unused = encoder.null();
}

// ---------------------------------------------------

#[wasm_bindgen]
/// Represents the "To Be Signed" (TBS) part of a C509 certificate.
///
/// The TBS certificate contains all the information that will be signed by the
/// certificate issuer, including the certificate type, serial number, issuer name,
/// validity period, subject name, subject public key, extensions, and the signature
/// algorithm used by the issuer.
///
/// # Fields
///
/// * `certificate_type` - The type of the certificate.
/// * `certificate_serial_number` - The serial number of the certificate, uniquely
///   identifying it.
/// * `issuer` - The distinguished name of the certificate issuer.
/// * `validity_not_before` - The start time of the certificate's validity period.
/// * `validity_not_after` - The end time of the certificate's validity period.
/// * `subject` - The distinguished name of the certificate subject (the entity being
///   certified).
/// * `subject_public_key_algo` - The public key algorithm used by the subject.
/// * `subject_public_key` - The public key of the subject.
/// * `extensions` - Additional attributes associated with the certificate, such as
///   alternative names or key usage.
/// * `issuer_sig_algo` - The signature algorithm used by the issuer to sign the
///   certificate.
///
/// Please refer to the [c509-certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/) Figure 1: CDDL for C509Certificate for more information.
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

/// The number of elements in a C509 certificate.
///
/// A C509 certificate is composed of two elements:
/// 1. The `TbsCertificate` which contains all the information that will be signed.
/// 2. The `issuerSignatureValue` which is the signature of the `TbsCertificate`.
const C509_CERTIFICATE_ELEMENTS: u64 = 2;

/// Generates a C509 certificate.
///
/// This function takes a `TbsCertificate` as input and returns an unsigned C509
/// certificate as a vector of bytes. The C509 certificate consists of the
/// `TbsCertificate` information and an `issuerSignatureValue` which is currently set to
/// null (indicating an unsigned certificate).
///
/// # Parameters
///
/// * `tbs_cert` - The `TbsCertificate` containing all the information to be signed by the
///   issuer.
///
/// # Returns
///
/// A vector of bytes representing the C509 certificate.
///
/// # Example
///
/// ```rust
/// use crate::{
///     generate_unsigned_c509_cert, C509CertificateType, Extensions, Name, PubKeyAlgoRegistry,
///     SignatureAlgoRegistry, TbsCertificate, Time, UnwrappedBiguint,
/// };
///
/// let issuer: Name = vec![];
/// let subject: Name = vec![];
/// let pub_key: Vec<u8> = vec![0x01, 0x02, 0x03];
/// let extensions: Extensions = vec![];
///
/// let tbs_cert = TbsCertificate {
///     certificate_type: C509CertificateType::SignedC509Cert,
///     certificate_serial_number: UnwrappedBiguint::U64Value(123456),
///     issuer,
///     validity_not_before: 1672531200,
///     validity_not_after: 1767225600,
///     subject,
///     subject_public_key_algo: PubKeyAlgoRegistry::Ed25519,
///     subject_public_key: pub_key,
///     extensions,
///     issuer_sig_algo: SignatureAlgoRegistry::Ed25519,
/// };
///
/// let c509_cert = generate_unsigned_c509_cert(tbs_cert);
/// assert!(!c509_cert.is_empty());
/// ```
pub(crate) fn generate_unsigned_c509_cert(tbs_cert: TbsCertificate) -> Vec<u8> {
    let mut buffer: Vec<u8> = Vec::new();

    // Create a new encoder, passing the buffer by mutable reference
    let mut encoder: Encoder<&mut Vec<u8>> = Encoder::new(&mut buffer);

    let _unused = encoder.array(C509_CERTIFICATE_ELEMENTS);
    // Encode the certificate type
    let _unused = encoder.u8(tbs_cert.certificate_type as u8);
    tbs_cert.certificate_serial_number.encode(&mut encoder);
    tbs_cert.issuer.encode(&mut encoder);
    tbs_cert.validity_not_before.encode(&mut encoder);
    tbs_cert.validity_not_after.encode(&mut encoder);
    tbs_cert.subject.encode(&mut encoder);
    encode_subject_public_key(
        tbs_cert.subject_public_key_algo,
        tbs_cert.subject_public_key,
        &mut encoder,
    );
    encode_extensions(tbs_cert.extensions, &mut encoder);
    encode_signature_algorithm(tbs_cert.issuer_sig_algo, &mut encoder);
    encode_issuer_signature_value(vec![], &mut encoder);

    buffer
}

// ---------------------------------------------------

#[cfg(test)]
mod test_c509_cert {

    use super::*;
    use crate::{
        c509_enum::AttributesRegistry,
        cbor_encoder::{AttributeRegistryValue, RelativeDistinguishedName, StringType},
        extensions::{
            alt_name::{GeneralName, GeneralNamesRegistry, GeneralNamesRegistryType},
            Extension, ExtensionRegistry, ExtensionValue,
        },
    };

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
        let pub_key_ed25519 = vec![
            25, 191, 68, 9, 105, 84, 205, 254, 85, 41, 186, 193, 67, 220, 59, 150, 200, 80, 86,
            170, 48, 182, 182, 203, 12, 92, 56, 173, 112, 49, 102, 225,
        ];
        let extensions: Extensions = vec![Extension {
            extension_type: ExtensionRegistry::SubjectAltName,
            critical: true,
            extension_value: ExtensionValue::SubjectAltName(vec![GeneralName {
                gn_name: GeneralNamesRegistry::DNSName,
                gn_value: GeneralNamesRegistryType::Text("example.com".to_string()),
                critical: false,
            }]),
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
        let buffer = generate_unsigned_c509_cert(tbs_cert);
        assert_ne!(buffer.len(), 0);
        println!("{:?}", hex::encode(buffer));
    }
}
