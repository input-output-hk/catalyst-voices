use alt_name::AltName;
use minicbor::Encoder;

use crate::cbor_encoder::CborEncoder;

pub mod alt_name;

pub type Extensions = Vec<Extension>;

#[allow(unused)]
pub struct Extension {
    pub extension_type: ExtensionRegistry,
    pub extension_value: ExtensionValue,
}

#[allow(unused)]
pub enum ExtensionValue {
    IssuerAltName(AltName),
    SubjectAltName(AltName),
}

#[allow(unused)]
impl CborEncoder for ExtensionValue {
    fn encode(&self, encoder: &mut Encoder<&mut Vec<u8>>) {
        match self {
            ExtensionValue::IssuerAltName(alt_name) => alt_name.encode(encoder),
            ExtensionValue::SubjectAltName(alt_name) => alt_name.encode(encoder),
        }
    }
}

#[allow(unused)]
pub(crate) enum ExtensionRegistry {
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

#[allow(unused)]
pub(crate) fn encode_extensions(extensions: Extensions, encoder: &mut Encoder<&mut Vec<u8>>) {
    encoder.array(extensions.len() as u64);
    for ext in extensions {
        encoder.u8(ext.extension_type as u8);
        ext.extension_value.encode(encoder);
    }
}
