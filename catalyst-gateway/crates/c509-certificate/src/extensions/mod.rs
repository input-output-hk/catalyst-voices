pub mod alt_name;

#[allow(unused)]
pub(crate) enum Extensions {
    SubjectKeyIdentifier = 1,
    KeyUsage = 2,
    SubjectAltName = 3,
    BasicConstraints = 4,
    CRLDistributionPoints = 5,
    CertificatePolicies = 6,
    AuthorityKeyIdentifier = 7,
    ExtendedKeyUsage = 8,
    AuthorityInfoAccess = 9,
    SignedCertificateTimestampList = 10,
    SubjectDirectoryAttributes = 24,
    IssuerAltName = 25,
    NameConstraints = 26,
    PolicyMappings = 27,
    PolicyConstraints = 28,
    FreshestCRL = 29,
    InhibitAnyPolicy = 30,
    SubjectInfoAccess = 31,
    IPResources = 32,
    ASResources = 33,
    IPResourcesBlocksV2 = 34,
    ASResourcesV2 = 35,
    BiometricInfo = 36,
    PrecertificateSigningCert = 37,
    OCSPNoCheck = 38,
    QualifiedCertificateStatements = 39,
    SMIMECapabilities = 40,
    TLSFeatures = 41,
    ChallengePassword = 255,
}

pub(crate) fn is_critical(critical: bool) -> i16 {
    if critical {
        return -1;
    }
    1
}
