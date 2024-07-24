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

use anyhow::Error;
use c509::C509;
use signing::{PrivateKey, PublicKey};
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

/// Generate a signed C509 certificate.
///
/// # Arguments
/// - `tbs_cert` - A cbor encoded TBS certificate.
/// - `private_key` - The private key used to sign the certificate.
///
/// # Returns
/// Returns a signed C509 certificate.
///
/// # Errors
///
/// Returns an error if tne sign data cannot be converted to CBOR bytes.
pub fn generate_signed_c509_cert(
    tbs_cert: Vec<u8>, private_key: &PrivateKey,
) -> Result<C509, Error> {
    let mut buffer = Vec::new();
    let mut encoder = minicbor::Encoder::new(&mut buffer);
    let sign_data = private_key.sign(&tbs_cert);
    encoder.bytes(&sign_data)?;
    Ok(C509::new(tbs_cert, buffer))
}

/// Verify the signature of a C509 certificate.
///
/// # Arguments
/// - `c509` - The C509 certificate to verify.
/// - `public_key` - The public key used to verify the certificate.
///
/// # Errors
/// Returns an error if the `issuer_signature_value` is invalid or the signature cannot be
/// verified.
pub fn verify_c509_signature(c509: &C509, public_key: &PublicKey) -> Result<(), Error> {
    let mut decoder = minicbor::Decoder::new(c509.get_issuer_signature_value());
    let signature = decoder.bytes()?;
    public_key.verify(c509.get_tbs_cert(), signature)
}

#[cfg(test)]
mod test {
    use minicbor::Encode;
    use signing::tests::private_key_str;
    use tbs_cert::test_tbs_cert::tbs;

    use super::*;

    #[test]
    fn test_generate_and_verify_signed_c509_cert() {
        let tbs_cert = tbs();
        let mut buffer = Vec::new();
        let mut encoder = minicbor::Encoder::new(&mut buffer);

        tbs_cert
            .encode(&mut encoder, &mut ())
            .expect("Failed to encode TbsCertificate");

        let private_key =
            PrivateKey::from_str(&private_key_str()).expect("Cannot create private key");

        let c509 = generate_signed_c509_cert(buffer, &private_key)
            .expect("Failed to generate signed C509 certificate");

        assert!(verify_c509_signature(&c509, &private_key.public_key()).is_ok());
    }
}
