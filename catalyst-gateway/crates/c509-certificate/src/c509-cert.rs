use std::{fmt::Error};
use regex::Regex;

enum C509CertificateType {
    SignedC509Cert,
    C509Cert,
}

enum AttributesRegistry {
    Email,
    CommonName,             // CN
    SurName,                // SN
    SerialNumber,
    Country,                // C
    Locality,               // L
    StateOrProvince,        // ST
    StreetAddress,
    Organization,           // O
    OrganizationUnit,       // OU
    Title,                  // T
    Business,
    PostalCode,             // PC
    GivenName,
    Initials,
    GenerationQualifier,
    DNQualifier,
    Pseudonym,
    OrganizationIdentifier,
    IncLocality,
    IncState,
    IncCountry,
    DomainComponent,        // DC
    PostalAddress,          // postalAddress
    Name,                   // name
    TelephoneNumber,        // telephoneNumber
    DirManDomainName,       // dmdName
    UserID,                 // uid
    UnstructuredName,       // unstructuredName
    UnstructuredAddress,    // unstructuredAddress
}

enum PubKeyAlgoRegistry {
    RSA = 0,
    Secp256r1 = 1 ,
    Secp384r1 = 2,
    Secp521r1 = 3,
    X25519 = 8,
    X448 = 9,
    Ed25519 = 10,
    Ed448 = 11,
    HSSLMS = 16,
    XMSS = 17,
    XMSSMT = 18,
    Brainpool256r1 = 24,
    Brainpool384r1 = 25,
    Brainpool512r1 = 26,
    Frp256v1 = 27,
    SM2P256v1 = 28,
}

enum StringType {
    UTF8String,
    PrintableString,
    IA5String
}

struct Name {
    attribute: &str,
    value: &str,
}

struct TbsCertificate {
    certificate_type: C509CertificateType,
    serial_number: u64,
    issuer: Name,
    validity_not_before: u64,
    validity_not_after: u64,
    subject: Name,
    subject_public_key_algorithm: String,
    subject_public_key: String,
    extensions: Vec<String>,
    issuer_signature_algorithm: String,
}

// ASN.1 PrintableString type supports upper case letters "A" through "Z",
// lowercase letters "a" through "z", the digits "0" through "9", space, and
// common punctuation marks. Note that PrintableString does not support
// the "@", "&", and "*" characters.
const PRINTABLESTRINGREGEX = "^[A-Za-z0-9 '()+,-./:=?]*$";

// Parse a DER x509 certificate and encode to CBOR
fn parse_x509_cert(input: Vec<u8>) {
    // x509 certificate fields (sequence of 3 required fields)
}

// Handle c509 type Name
fn cbor_c509_type_name(names: Vec<Name>) {
    // Single attribute name with commonName or cn
    if names.len() == 1 && (names[0].attribute == "commonName" || names[0].attribute == "cn") {
        let pattern = Regex::new(r"^[0-9a-f]+$").unwrap();
        let eui_64_pattern = Regex::new(r"^[\p{XDigit}]{2}(?:-[\p{XDigit}]{2}){7}$").unwrap();
            
        if (names[0].value.len() >= 2 && names[0].value.len() % 2 == 0 && pattern.is_match(names[0].value)) {
            // encoded as a CBOR byte string, prefixed with an initial byte set to '00'.
        } else if (eui_64_pattern.is_match(names[0].value)) {
            // encoded as a CBOR byte string prefixed with an initial byte set to '01', for a total length of 7.
        } else {
            // encoded as a CBOR text string.
        }
    } else {
        for name in names {
            // Get the number of the attribute registry
            let attribute_type = get_attribute_registry_number(name.attribute);
            // Identify the character string type.
            // + for UTF8String - for PrintableString
            let string_type = get_string_type(name.value);
            if string_type == StringType::UTF8String {
                // Positive integer
            } else {
                // Negative integer
            }
        }
    }
}

fn get_string_type(value: &str) -> StringType {
    let pattern = Regex::new(r`$PRINTABLESTRINGREGEX`).unwrap(); 
    // FIXME - Check for Ia5String
    if pattern.is_match(value) {
        StringType::PrintableString
    } else {
        StringType::UTF8String
    }
}
fn get_attribute_registry_number(text: &str) -> u32{
    match text {
        "emailAddress" | "e-mailAddress" => AttributesRegistry::Email as u32,
        "commonName" | "cn" => AttributesRegistry::CommonName as u32,
        "surname" | "sn" => AttributesRegistry::SurName as u32,
        "serialNumber" => AttributesRegistry::SerialNumber as u32,
        "countryName" | "c" => AttributesRegistry::Country as u32,
        "localityName" | "locality" | "l" => AttributesRegistry::Locality as u32,
        "stateOrProvinceName" | "st" => AttributesRegistry::StateOrProvince as u32,
        "streetAddress" | "street" => AttributesRegistry::StreetAddress as u32,
        "organizationName" | "o" => AttributesRegistry::Organization as u32,
        "title" => AttributesRegistry::Title as u32,
        "businessCategory" => AttributesRegistry::Business as u32,
        "postalCode" => AttributesRegistry::PostalCode as u32,
        "givenName" => AttributesRegistry::GivenName as u32,
        "initials" => AttributesRegistry::Initials as u32,
        "generationQualifier" => AttributesRegistry::GenerationQualifier as u32,
        "dnQualifier" => AttributesRegistry::DNQualifier as u32,
        "pseudoNym" => AttributesRegistry::Pseudonym as u32,
        "organizationIdentifier" => AttributesRegistry::OrganizationIdentifier as u32,
        "jurisdictionOfIncorporationLocalityName" => AttributesRegistry::IncLocality as u32,
        "jurisdictionOfIncorporation" => AttributesRegistry::IncState as u32,
        "jurisdictionOfIncorporationCountryName" => AttributesRegistry::IncCountry as u32,
        "domainComponent" | "dc" => AttributesRegistry::DomainComponent as u32,
        "postalAddress" => AttributesRegistry::PostalAddress as u32,
        "name" => AttributesRegistry::Name as u32,
        "telephoneNumber" => AttributesRegistry::TelephoneNumber as u32,
        "dmdName" => AttributesRegistry::DirManDomainName as u32,
        "uid" => AttributesRegistry::UserID as u32,
        "unstructuredName" => AttributesRegistry::UnstructuredName as u32,
        "unstructuredAddress" => AttributesRegistry::UnstructuredAddress as u32,
        _ => 0,
    }
}

fn check_version(version: u8) -> Result<C509CertificateType, Error> {
    match version {
        0 => Ok(C509CertificateType::C509Cert),
        1 => Ok(C509CertificateType::SignedC509Cert),
        _ => Err(Error),
    }
}
