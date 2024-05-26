#[allow(unused)]
pub(crate) enum C509CertificateType {
    SignedC509Cert,
    C509Cert,
}
#[allow(unused)]
pub(crate) enum AttributesRegistry {
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

#[allow(unused)]
#[derive(PartialEq)]
pub(crate) enum PubKeyAlgoRegistry {
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

#[allow(unused)]
#[derive(Debug)]
pub(crate) enum StringType {    
    Utf8String(String),
    PrintableString(String),
    Ia5String(String),
    HexByteString(Vec<u8>),
    Eui64ByteString(Vec<u8>),
}
