//! CBOR Encoded X.509 Certificate (C509 Certificate) library
//!
//! This crate provides a library for generating C509 Certificates.
//! The function is exposed to Javascript through wasm-bindgen.
//!
//! Please refer to the [C509 Certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/) for more information.

use wasm_bindgen::prelude::wasm_bindgen;
pub mod c509_algo_iden;
pub mod c509_extensions;
pub mod c509_general_names;
pub mod c509_oid;
pub mod c509_issuer_sig_algo;
pub mod c509_subject_pub_key_algo;
mod tables;

/// Generates an unsigned C509 certificate from the provided `TbsCertificate`.
///
/// C509 certificate contains 2 parts
/// 1. TBSCertificate
/// 2. issuerSignatureValue
/// In order to generate an unsigned C509 certificate, the TBS Certificate must be
/// provided. Then the unsigned C509 certificate will then be used to calculate the
/// issuerSignatureValue.
///
/// # Arguments
///
/// * `tbs_cert` - The `TbsCertificate` is the TBS Certificate containing
///    * c509CertificateType: A certificate type, whether 0 a natively signed C509
///      certificate following X.509 v3 or 1 a CBOR re-encoded X.509 v3 DER certificate.
///    * certificateSerialNumber: A unique serial number for the certificate.
///    * issuer: The entity that issued the certificate.
///    * validityNotBefore: The duration for which the Certificate Authority (CA)
///      guarantees it will retain information regarding the certificate's status on which
///      the period begins.
///    * validityNotAfter: The duration for which the Certificate Authority (CA)
///      guarantees it will retain information regarding the certificate's status on which
///      the period ends.
///    * subject: The entity associated with the public key stored in the subject public
///      key field.
///    * subjectPublicKeyAlgorithm: The algorithm that the public key is used,
///    * subjectPublicKey: The public key of the subject.
///    * extensions: A list of extensions defined for X.509 v3 certificate, providing
///      additional attributes for users or public keys, and for managing relationships
///      between Certificate Authorities (CAs).
///    * issuerSignatureAlgorithm: The algorithm used to sign the certificate (must be the
///      algorithm uses to create IssuerSignatureValue).
///
/// # Returns
///
/// A `Vec<u8>` containing the generated unsigned C509 certificate.
///
/// # Remarks
///
/// This function relies on the `c509_cert` module's `generate_unsigned_c509_cert`
/// function for the actual generation process.
#[wasm_bindgen]
#[must_use]
pub fn generate_unsigned_c509_cert() -> Vec<u8> {
    // c509_cert::generate_unsigned_c509_cert(tbs_cert)
    todo!()
}
