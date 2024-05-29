#[allow(unused)]
/// C509 certificate type
/// Currently support Natively Signed c509 cert
pub(crate) enum C509CertificateType {
    // Natively Signed C509 cert
    SignedC509Cert,
}

#[allow(unused)]
#[derive(PartialEq, Copy, Clone)]
pub(crate) enum AttributesRegistry {
    Email = 0,
    CommonName = 1, // CN
    SurName = 2,    // SN
    SerialNumber = 3,
    Country = 4,         // C
    Locality = 5,        // L
    StateOrProvince = 6, // ST
    StreetAddress = 7,
    Organization = 8,     // O
    OrganizationUnit = 9, // OU
    Title = 10,           // T
    Business = 11,
    PostalCode = 12, // PC
    GivenName = 13,
    Initials = 14,
    GenerationQualifier = 15,
    DNQualifier = 16,
    Pseudonym = 17,
    OrganizationIdentifier = 18,
    IncLocality = 19,
    IncState = 20,
    IncCountry = 21,
    DomainComponent = 22,     // DC
    PostalAddress = 23,       // postalAddress
    Name = 24,                // name
    TelephoneNumber = 25,     // telephoneNumber
    DirManDomainName = 26,    // dmdName
    UserID = 27,              // uid
    UnstructuredName = 28,    // unstructuredName
    UnstructuredAddress = 29, // unstructuredAddress
}

#[allow(unused)]
#[derive(PartialEq)]
pub(crate) enum PubKeyAlgoRegistry {
    RSA = 0,
    Secp256r1 = 1,
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
