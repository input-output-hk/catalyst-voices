#[allow(unused)]
/// C509 certificate type
/// Currently support Natively Signed c509 cert
pub enum C509CertificateType {
    // Natively Signed C509 cert
    SignedC509Cert,
}

#[allow(unused)]
#[derive(PartialEq, Copy, Clone)]
pub enum AttributesRegistry {
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
pub enum PubKeyAlgoRegistry {
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

// Section 9.10
#[allow(unused)]
#[derive(PartialEq)]
pub enum SignatureAlgoRegistry {
    RsassaPkcs1V15Sha1 = -256,
    EcdsaSha1 = -255,
    EcdsaSha256 = 0,
    EcdsaSha384 = 1,
    EcdsaSha512 = 2,
    EcdsaShake128 = 3,
    EcdsaShake256 = 4,
    Ed25519 = 12,
    Ed448 = 13,
    Sha256WithHmacSha256 = 14,
    Sha384WithHmacSha384 = 15,
    Sha512WithHmacSha512 = 16,
    RsassaPkcs1V15Sha256 = 23,
    RsassaPkcs1V15Sha384 = 24,
    RsassaPkcs1V15Sha512 = 25,
    RsassaPssSha256 = 26,
    RsassaPssSha384 = 27,
    RsassaPssSha512 = 28,
    RsassaPssShake128 = 29,
    RsassaPssShake256 = 30,
    HssLms = 42,
    Xmss = 43,
    XmssMt = 44,
    Sm2WithSm3 = 45,
}
