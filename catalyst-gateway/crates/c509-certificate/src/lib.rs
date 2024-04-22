//! x509 Certificate library

use std::{fmt::Error};
use regex::Regex;


use wasm_bindgen::prelude::*;

#[wasm_bindgen]
extern "C" {
    pub fn alert(s: &str);
}

#[wasm_bindgen]
/// Sample function for test only
pub fn greet(name: &str) {
    alert(&format!("Hello, {name}!"));
}

// Function to create a CBOR re-encoding of X.509 v3 DER Certificate
struct TbsCertificate {
    certificate_type: C509CertificateType,
    serial_number: u64,
    issuer: String,
    validity_not_before: u64,
    validity_not_after: u64,
    subject: String,
    subject_public_key_algorithm: String,
    subject_public_key: String,
    extensions: Vec<String>,
    issuer_signature_algorithm: String,
}

fn create_c509_certificate(tbsCertificate: TbsCertificate ) {

}

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

struct Name {
    attribute: &str,
    value: &str,
}

fn cbor_name(names: Vec<Name>) {
    if names.len() == 1 {
        if names[0].attribute == "commonName" || names[0].attribute == "cn" {
            let pattern = Regex::new(r"^[0-9a-f]+$").unwrap();
            let eui_64_pattern = Regex::new(r"^[\p{XDigit}]{2}(?:-[\p{XDigit}]{2}){7}$").unwrap();
            
            if (names[0].value.len() >= 2 && names[0].value.len() % 2 == 0 && pattern.is_match(names[0].value)) {
                // encoded as a CBOR byte string, prefixed with an initial byte set to '00'.
            } else if (eui_64_pattern.is_match(names[0].value)) {
                // encoded as a CBOR byte string prefixed with an initial byte set to '01', for a total length of 7.
            } else {
                // encoded as a CBOR text string.
            }
        }
    } else {
        for name in names {
            // encoded as a CBOR array of CBOR arrays, where each inner array contains two elements: the attribute type and the attribute value.
            let attribute_type = get_attribute_registry_number(name.attribute);
        }
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

// ASN.1 PrintableString type supports upper case letters "A" through "Z", lower case letters "a" through "z", the digits "0" through "9", space, and common punctuation marks. Note that PrintableString does not support the "@", "&", and "*" characters.// CBOR encode a DER encoded Name field
const PRINTABLESTRINGREGEX = "^[A-Za-z0-9 '()+,-./:=?]*$";

fn check_serial_number(serial_number: u8) -> Result<u8, Error> {
    if serial_number == 0 {
        Ok(serial_number)
    } else {
        Err(Error)
    }
}
