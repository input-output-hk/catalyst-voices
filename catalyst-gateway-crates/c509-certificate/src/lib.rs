//! CBOR Encoded X.509 Certificate (C509 Certificate) library
//!
//! This crate provides a functionality for generating C509 Certificate.
//!
//! ## C509 certificate contains 2 parts
//! 1. `TBSCertificate`
//! 2. `issuerSignatureValue`
//!
//! In order to generate an unsigned C509 certificate, the TBS Certificate must be
//! provided. Then the unsigned C509 certificate will then be used to calculate the
//! issuerSignatureValue.
//!
//! # TBS Certificate
//!
//! The To Be Sign Certificate contains the following fields:
//!    * c509CertificateType: A certificate type, whether 0 a natively signed C509
//!      certificate following X.509 v3 or 1 a CBOR re-encoded X.509 v3 DER certificate.
//!    * certificateSerialNumber: A unique serial number for the certificate.
//!    * issuer: The entity that issued the certificate.
//!    * validityNotBefore: The duration for which the Certificate Authority (CA)
//!      guarantees it will retain information regarding the certificate's status on which
//!      the period begins.
//!    * validityNotAfter: The duration for which the Certificate Authority (CA)
//!      guarantees it will retain information regarding the certificate's status on which
//!      the period ends.
//!    * subject: The entity associated with the public key stored in the subject public
//!      key field.
//!    * subjectPublicKeyAlgorithm: The algorithm that the public key is used.
//!    * subjectPublicKey: The public key of the subject.
//!    * extensions: A list of extensions defined for X.509 v3 certificate, providing
//!      additional attributes for users or public keys, and for managing relationships
//!      between Certificate Authorities (CAs).
//!    * issuerSignatureAlgorithm: The algorithm used to sign the certificate (must be the
//!      algorithm uses to create `IssuerSignatureValue`).
//!
//! Please refer to the [C509 Certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/) for more information.

use anyhow::anyhow;
use c509::C509;
use minicbor::{Decode, Encode};
use signing::{PrivateKey, PublicKey};
use tbs_cert::TbsCert;
pub mod c509;
pub mod c509_algo_identifier;
pub mod c509_attributes;
pub mod c509_big_uint;
pub mod c509_extensions;
pub mod c509_general_names;
pub mod c509_issuer_sig_algo;
pub mod c509_name;
pub mod c509_oid;
pub mod c509_subject_pub_key_algo;
pub mod c509_time;
pub mod signing;
mod tables;
pub mod tbs_cert;
pub mod wasm_binding;

/// Generate a signed or unsigned C509 certificate.
///
/// # Arguments
/// - `tbs_cert` - A TBS certificate.
/// - `private_key` - An optional private key, if provided certificate is signed.
///
/// # Returns
/// Returns a signed or unsigned C509 certificate.
///
/// # Errors
///
/// Returns an error if tne data cannot be converted to CBOR bytes.

pub fn generate(tbs_cert: &TbsCert, private_key: Option<&PrivateKey>) -> anyhow::Result<Vec<u8>> {
    // Encode the TbsCert
    let encoded_tbs = {
        let mut buffer = Vec::new();
        let mut encoder = minicbor::Encoder::new(&mut buffer);
        tbs_cert.encode(&mut encoder, &mut ())?;
        buffer
    };
    let sign_data = private_key.map(|pk| pk.sign(&encoded_tbs));

    // Encode the whole C509 certificate including `TbSCert` and `issuerSignatureValue`
    let encoded_c509 = {
        let mut buffer = Vec::new();
        let mut encoder = minicbor::Encoder::new(&mut buffer);
        let c509 = C509::new(tbs_cert.clone(), sign_data);
        c509.encode(&mut encoder, &mut ())?;
        buffer
    };
    Ok(encoded_c509)
}

/// Verify the signature of a C509 certificate.
///
/// # Arguments
/// - `c509` - The cbor encoded C509 certificate to verify.
/// - `public_key` - The public key used to verify the certificate.
///
/// # Errors
/// Returns an error if the `issuer_signature_value` is invalid or the signature cannot be
/// verified.
pub fn verify(c509: &[u8], public_key: &PublicKey) -> anyhow::Result<()> {
    let mut d = minicbor::Decoder::new(c509);
    let c509 = C509::decode(&mut d, &mut ())?;
    let mut encoded_tbs = Vec::new();
    let mut encoder = minicbor::Encoder::new(&mut encoded_tbs);
    c509.get_tbs_cert().encode(&mut encoder, &mut ())?;
    let issuer_sig = c509
        .get_issuer_signature_value()
        .clone()
        .ok_or(anyhow!("No issuer signature"))?;
    public_key.verify(&encoded_tbs, &issuer_sig)
}

#[cfg(test)]
mod test {
    use std::str::FromStr;

    use signing::tests::private_key_str;
    use tbs_cert::test_tbs_cert::tbs;

    use super::*;

    #[test]
    fn test_generate_and_verify_signed_c509_cert() {
        let tbs_cert = tbs();

        let private_key = FromStr::from_str(&private_key_str()).expect("Cannot create private key");

        let signed_c509 = generate(&tbs_cert, Some(&private_key))
            .expect("Failed to generate signed C509 certificate");

        assert!(verify(&signed_c509, &private_key.public_key()).is_ok());
    }
}
