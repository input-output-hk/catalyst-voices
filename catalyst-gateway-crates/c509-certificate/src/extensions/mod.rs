//! This module contains the implementation of the Extensions field in the c509
//! certificate. Please refer to the [c509-certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/) for more information.

use alt_name::AltName;
use minicbor::Encoder;

use crate::cbor_encoder::CborEncoder;

pub mod alt_name;

/// Extensions field is an array of `Extension`, representing multiple extensions in a
/// C509 certificate.
pub type Extensions = Vec<Extension>;

/// Represents an Extension in a C509 certificate.
/// Each Extension includes its type, value, and a critical flag.
///
/// # Fields
/// * `extension_type` - The type of the extension as defined in the `ExtensionRegistry`.
/// * `extension_value` - The value of the extension, which can be different types of
///   extension values.
/// * `critical` - A boolean indicating whether the extension is critical.
pub struct Extension {
    pub extension_type: ExtensionRegistry,
    pub extension_value: ExtensionValue,
    pub critical: bool,
}

/// Currently implemented values for an extension.
#[allow(unused)]
pub enum ExtensionValue {
    /// Alternative names for the issuer.
    IssuerAltName(AltName),
    /// Alternative names for the subject.
    SubjectAltName(AltName),
}

impl CborEncoder for ExtensionValue {
    /// Encodes a `ExtensionValue` using the provided CBOR encoder.
    ///
    /// # Arguments
    ///
    /// * `encoder` - A mutable reference to a `minicbor::Encoder` to encode the
    ///   extensions into.
    fn encode(&self, encoder: &mut Encoder<&mut Vec<u8>>) {
        match self {
            ExtensionValue::IssuerAltName(alt_name) => alt_name.encode(encoder),
            ExtensionValue::SubjectAltName(alt_name) => alt_name.encode(encoder),
        }
    }
}

/// Enum of possible C509 extension types.
/// Please refer to the [c509-certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/) Section 9.4 C509 Extensions Registry for more information.
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

/// Determines if an Extension is critical or not.
///
/// # Parameters
///
/// * `critical` - A boolean indicating if the extension is critical.
///
/// # Returns
///
/// Returns `-1` if the Extension is critical, `1` otherwise.
pub(crate) fn is_critical(critical: bool) -> i16 {
    if critical {
        return -1;
    }
    1
}

/// Encodes a list of Extensions into CBOR format.
/// This function iterates over each `Extension` in the provided `extensions` vector and
/// encodes
///
/// # Parameters
///
/// * `extensions` - A vector of `Extension` objects to be encoded.
/// * `encoder` - A mutable reference to a `minicbor::Encoder` to encode the extensions
///   into.
pub(crate) fn encode_extensions(extensions: Extensions, encoder: &mut Encoder<&mut Vec<u8>>) {
    let _unused = encoder.array(extensions.len() as u64);
    for ext in extensions {
        let c = is_critical(ext.critical);
        let _unused = encoder.i16(ext.extension_type as i16 * c);
        ext.extension_value.encode(encoder);
    }
}

#[cfg(test)]
mod test_extensions {
    use alt_name::{GeneralName, GeneralNamesRegistry, GeneralNamesRegistryType, OtherNameType};
    use minicbor::Encoder;

    use super::*;

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
