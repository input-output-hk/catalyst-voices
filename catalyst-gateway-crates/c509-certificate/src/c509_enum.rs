//! This module provides essential enumerators used in C509 certificates.
//! Please refer to the [c509-certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/) for more information.

#[allow(unused)]
/// Represents the types of C509 certificates.
///
/// Currently, only natively signed C509 certificates are supported.
pub enum C509CertificateType {
    // Natively Signed C509 cert
    SignedC509Cert,
}

#[allow(unused)]
#[derive(PartialEq, Copy, Clone)]
/// Enum of C509 Attributes Registry used in certificates.
///
/// Each attribute is assigned a unique integer value.
/// Please refer to the [C509 Certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/) Section 9.3 C509 Attributes Registry for more information.
pub enum AttributesRegistry {
    /// Email address (emailAddress, e-mailAddress).
    Email = 0,
    /// Common Name (commonName, cn)
    CommonName = 1,
    /// Surname (surname, sn)
    SurName = 2,
    /// Serial number (serialNumber)
    SerialNumber = 3,
    /// Country (countryName, c)
    Country = 4,
    /// Locality (localityName, locality, l)
    Locality = 5,
    /// State or Province (stateOrProvinceName, st)
    StateOrProvince = 6,
    /// Street address (streetAddress, street)
    StreetAddress = 7,
    /// Organization (organizationName, o)
    Organization = 8,
    /// Organizational Unit (organizationalUnitName, ou)
    OrganizationUnit = 9,
    /// Title (title)
    Title = 10,
    /// Business Category (businessCategory)
    BusinessCategory = 11,
    /// Postal Code (postalCode)
    PostalCode = 12,
    /// Given name (givenName)
    GivenName = 13,
    /// Initials (initials)
    Initials = 14,
    /// Generation qualifier (generationQualifier)
    GenerationQualifier = 15,
    /// Distinguished Name qualifier (dnQualifier)
    DNQualifier = 16,
    /// Pseudonym (pseudonym)
    Pseudonym = 17,
    /// Organization identifier (organizationIdentifier)
    OrganizationIdentifier = 18,
    /// Incorporated locality (jurisdictionOfIncorporationLocalityName)
    IncLocality = 19,
    /// Incorporated state or province (jurisdictionOfIncorporationStateOrProvinceName)
    IncStateOrProvince = 20,
    /// Incorporated country (jurisdictionOfIncorporationCountryName)
    IncCountry = 21,
    /// Domain Component (domainComponent, dc)
    DomainComponent = 22,
    /// Postal address (postalAddress)
    PostalAddress = 23,
    /// Name (name)
    Name = 24,
    /// Telephone number (telephoneNumber)
    TelephoneNumber = 25,
    /// Directory management domain name (dmdName)
    DirManDomainName = 26,
    /// User ID (uid)
    UserID = 27,
    /// Unstructured name (unstructuredName)
    UnstructuredName = 28,
    /// Unstructured address (unstructuredAddress)
    UnstructuredAddress = 29,
}

#[allow(unused)]
#[derive(PartialEq)]
/// Enum of registry of public key algorithms.
///
/// Each algorithm is assigned a unique integer value.
/// Please refer to the [C509 Certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/) 9.11 C509 Public Key Algorithms Registry for more information.
pub enum PubKeyAlgoRegistry {
    /// RSA public key algorithm
    RSA = 0,
    /// secp256r1 elliptic curve algorithm
    Secp256r1 = 1,
    /// secp384r1 elliptic curve algorithm
    Secp384r1 = 2,
    /// secp521r1 elliptic curve algorithm
    Secp521r1 = 3,
    /// X25519 elliptic curve algorithm
    X25519 = 8,
    /// X448 elliptic curve algorithm
    X448 = 9,
    /// Ed25519 elliptic curve algorithm
    Ed25519 = 10,
    /// Ed448 elliptic curve algorithm
    Ed448 = 11,
    /// HSSLMS public key algorithm
    HSSLMS = 16,
    /// XMSS public key algorithm
    XMSS = 17,
    /// XMSS-MT public key algorithm
    XMSSMT = 18,
    /// brainpoolP256r1 elliptic curve algorithm
    Brainpool256r1 = 24,
    /// brainpoolP384r1 elliptic curve algorithm
    Brainpool384r1 = 25,
    /// brainpoolP512r1 elliptic curve algorithm
    Brainpool512r1 = 26,
    /// FRP256v1 elliptic curve algorithm
    Frp256v1 = 27,
    /// SM2P256v1 elliptic curve algorithm
    SM2P256v1 = 28,
}

#[allow(unused)]
#[derive(PartialEq)]
/// Enum of registry of signature algorithms.
///
/// Each algorithm is assigned a unique integer value.
/// Please refer to the [C509 Certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/) 9.10 C509 Signature Algorithms Registry for more information.
pub enum SignatureAlgoRegistry {
    /// RSASSA-PKCS1-v1_5 with SHA-1
    RsassaPkcs1V15Sha1 = -256,
    /// ECDSA with SHA-1
    EcdsaSha1 = -255,
    /// ECDSA with SHA-256
    EcdsaSha256 = 0,
    /// ECDSA with SHA-384
    EcdsaSha384 = 1,
    /// ECDSA with SHA-512
    EcdsaSha512 = 2,
    /// ECDSA with SHAKE128
    EcdsaShake128 = 3,
    /// ECDSA with SHAKE256
    EcdsaShake256 = 4,
    /// Ed25519
    Ed25519 = 12,
    /// Ed448
    Ed448 = 13,
    /// SHA-256 with HMAC-SHA-256
    Sha256WithHmacSha256 = 14,
    /// SHA-384 with HMAC-SHA-384
    Sha384WithHmacSha384 = 15,
    /// SHA-512 with HMAC-SHA-512
    Sha512WithHmacSha512 = 16,
    /// RSASSA-PKCS1-v1_5 with SHA-256
    RsassaPkcs1V15Sha256 = 23,
    /// RSASSA-PKCS1-v1_5 with SHA-384
    RsassaPkcs1V15Sha384 = 24,
    /// RSASSA-PKCS1-v1_5 with SHA-512
    RsassaPkcs1V15Sha512 = 25,
    /// RSASSA-PSS with SHA-256
    RsassaPssSha256 = 26,
    /// RSASSA-PSS with SHA-384
    RsassaPssSha384 = 27,
    /// RSASSA-PSS with SHA-512
    RsassaPssSha512 = 28,
    /// RSASSA-PSS with SHAKE128
    RsassaPssShake128 = 29,
    /// RSASSA-PSS with SHAKE256
    RsassaPssShake256 = 30,
    /// HSS/LMS
    HssLms = 42,
    /// XMSS
    Xmss = 43,
    /// XMSS-MT
    XmssMt = 44,
    /// SM2 with SM3
    Sm2WithSm3 = 45,
}
