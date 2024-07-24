//! C509 Certificate

/// A struct represents the `C509` Certificate.
pub struct C509 {
    /// An encoded value of `TBSCertificate`
    tbs_cert: Vec<u8>,
    /// A encoded value of `IssuerSignatureValue`
    issuer_signature_value: Vec<u8>,
}

impl C509 {
    /// Create a new instance of C509 Certificate .
    #[must_use]
    pub fn new(tbs_cert: Vec<u8>, issuer_signature_value: Vec<u8>) -> Self {
        Self {
            tbs_cert,
            issuer_signature_value,
        }
    }

    /// Get the `TBSCertificate` of the C509 Certificate.
    #[must_use]
    pub fn get_tbs_cert(&self) -> &Vec<u8> {
        &self.tbs_cert
    }

    /// Get the `IssuerSignatureValue` of the C509 Certificate.
    #[must_use]
    pub fn get_issuer_signature_value(&self) -> &Vec<u8> {
        &self.issuer_signature_value
    }
}
