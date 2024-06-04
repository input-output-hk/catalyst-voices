use alt_name::AltName;
use minicbor::Encoder;

use crate::cbor_encoder::CborEncoder;

pub mod alt_name;

// Extension struct represent each extension
// CBOR int (see Section 9.4), CBOR item of ExtensionValue, and critical flag
pub struct Extension {
    pub extension_type: ExtensionRegistry,
    pub extension_value: ExtensionValue,
    pub critical: bool,
}

// Extensions field is an array of Extension
pub type Extensions = Vec<Extension>;

// Extension possible values
#[allow(unused)]
pub enum ExtensionValue {
    IssuerAltName(AltName),
    SubjectAltName(AltName),
}

impl CborEncoder for ExtensionValue {
    fn encode(&self, encoder: &mut Encoder<&mut Vec<u8>>) {
        match self {
            ExtensionValue::IssuerAltName(alt_name) => alt_name.encode(encoder),
            ExtensionValue::SubjectAltName(alt_name) => alt_name.encode(encoder),
        }
    }
}

// Ref - 9.4. C509 Extensions Registry
#[allow(unused)]
pub enum ExtensionRegistry {
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

// Determine if the extension is critical or not
// return -1 if critical, 1 if not
pub(crate) fn is_critical(critical: bool) -> i16 {
    if critical {
        return -1;
    }
    1
}

// Encoding the extension
// Extension field is encoded as a CBOR array of Extension
pub(crate) fn encode_extensions(extensions: Extensions, encoder: &mut Encoder<&mut Vec<u8>>) {
    let _unused = encoder.array(extensions.len() as u64);
    for ext in extensions {
        let c = is_critical(ext.critical);
        let _unused = encoder.i16(ext.extension_type as i16 * c);
        ext.extension_value.encode(encoder);
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use alt_name::{GeneralName, GeneralNamesRegistry, GeneralNamesRegistryType, OtherNameType};
    use minicbor::Encoder;

    #[test]
    fn test_encode_extensions() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        let general_name_1 = GeneralName {
            gn_name: GeneralNamesRegistry::OtherNameHardwareModuleName,
            gn_value: GeneralNamesRegistryType::OidAndBytes(OtherNameType {
                hw_type: "1.3.6.1.4.1.6175.10.1".to_string(),
                hw_serial_num: vec![0x01, 0x02, 0x03, 0x04],
            }),
            critical: false,
        };
        let general_name_2 = GeneralName {
            gn_name: GeneralNamesRegistry::OtherNameHardwareModuleName,
            gn_value: GeneralNamesRegistryType::OidAndBytes(OtherNameType {
                hw_type: "1.3.6.1.4.1.6175.10.1".to_string(),
                hw_serial_num: vec![0x01, 0x02, 0x03, 0x04],
            }),
            critical: false,
        };
        let alt_name_1: AltName = vec![general_name_1];
        let alt_name_2: AltName = vec![general_name_2];

        let extensions: Extensions = vec![
            Extension {
                extension_type: ExtensionRegistry::IssuerAltName,
                extension_value: ExtensionValue::IssuerAltName(alt_name_1),
                critical: true,
            },
            Extension {
                extension_type: ExtensionRegistry::SubjectAltName,
                extension_value: ExtensionValue::SubjectAltName(alt_name_2),
                critical: false,
            },
        ];
        
        encode_extensions(extensions, &mut encoder);
        // 82 -> 2 extensions (2 item in array)
        // 38 18 -> IssuerAltName type 25 with critical flag true (-25)
        // 822082492b06010401b01f0a014401020304 -> general_name_1
        // 03 ->  SubjectAltName type 3 with critical flag false (3)
        // 822082492b06010401b01f0a014401020304 -> general_name_2
        assert_eq!(
            hex::encode(buffer),
            "823818822082492b06010401b01f0a01440102030403822082492b06010401b01f0a014401020304"
        );
    }
}
