//! Signature algorithm data provides a necessary information for encoding and decoding of
//! C509 `issuerSignatureAlgorithm`. See [C509 Certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/)
//! Section 9.10 C509 Signature Algorithms Registry for more information.

// cspell: words RSASSA XMSS

use anyhow::Error;
use asn1_rs::{oid, Oid};
use once_cell::sync::Lazy;

use crate::tables::IntegerToOidTable;

/// Type of algorithm data
/// INT | OID | Name
type AlgorithmDataTuple = (i16, Oid<'static>, &'static str);

/// Signature algorithm data table.
#[rustfmt::skip]
const SIG_ALGO_DATA: [AlgorithmDataTuple; 22] = [
    // Int  |               OID                |            Name    
    (-256,  oid!(1.2.840.113549.1.1.5),          "RSASSA-PKCS1-v1_5 with SHA-1"),
    (-255,  oid!(1.2.840.10045.4.1),             "ECDSA with SHA-1"),
    (0,     oid!(1.2.840.10045.4.3.2),           "ECDSA with SHA-256"),
    (1,     oid!(1.2.840.10045.4.3.3),           "ECDSA with SHA-384"),
    (2,     oid!(1.2.840.10045.4.3.4),           "ECDSA with SHA-512"),
    (3,     oid!(1.3.6.1.5.5.7.6.32),            "ECDSA with SHAKE128"),
    (4,     oid!(1.3.6.1.5.5.7.6.33),            "ECDSA with SHAKE256"),
    (12,    oid!(1.3.101.112),                   "Ed25519"),
    (13,    oid!(1.3.101.113),                   "Ed448"),
    (14,    oid!(1.3.6.1.5.5.7.6.26),            "SHA-256 with HMAC-SHA256"),
    (15,    oid!(1.3.6.1.5.5.7.6.27),            "SHA-384 with HMAC-SHA384"),
    (16,    oid!(1.3.6.1.5.5.7.6.28),            "SHA-512 with HMAC-SHA512"),
    (23,    oid!(1.2.840.113549.1.1.11),         "RSASSA-PKCS1-v1_5 with SHA-256"),
    (24,    oid!(1.2.840.113549.1.1.12),         "RSASSA-PKCS1-v1_5 with SHA-384"),
    (25,    oid!(1.2.840.113549.1.1.13),         "RSASSA-PKCS1-v1_5 with SHA-512"),
    (26,    oid!(1.2.840.113549.1.1.10),         "RSASSA-PSS with SHA-256"),
    // (27,    oid!(1.2.840.113549.1.1.10),         "RSASSA-PSS with SHA-384"),
    // (28,    oid!(1.2.840.113549.1.1.10),         "RSASSA-PSS with SHA-512"),
    (29,    oid!(1.3.6.1.5.5.7.6.30),            "RSASSA-PSS with SHAKE128"),
    (30,    oid!(1.3.6.1.5.5.7.6.3),             "RSASSA-PSS with SHAKE256"),
    (42,    oid!(1.2.840.113549.1.9.16.3.17),    "HSS / LMS"),
    (43,    oid!(0.4.0.127.0.15.1.1.13.0),       "XMSS"),
    (44,    oid!(0.4.0.127.0.15.1.1.14.0),       "XMSS^MT"),
    (45,    oid!(1.2.156.10197.1.501),           "SM2 with SM3"),    
];

/// A struct of data that contains lookup table of integer to OID in
/// bidirectional way for `IssuerSignatureAlgorithm`.
pub(crate) struct IssuerSigAlgoData(IntegerToOidTable);

impl IssuerSigAlgoData {
    /// Get the `IntegerToOidTable`
    pub(crate) fn get_int_to_oid_table(&self) -> &IntegerToOidTable {
        &self.0
    }
}

/// Define static lookup for issuer signature algorithm table
static ISSUER_SIG_ALGO_TABLE: Lazy<IssuerSigAlgoData> = Lazy::new(|| {
    let mut int_to_oid_table = IntegerToOidTable::new();

    for data in SIG_ALGO_DATA {
        int_to_oid_table.add(data.0, data.1);
    }

    IssuerSigAlgoData(int_to_oid_table)
});

/// Static reference to the `IssuerSigAlgoData` lookup table.
pub(crate) static ISSUER_SIG_ALGO_LOOKUP: &Lazy<IssuerSigAlgoData> = &ISSUER_SIG_ALGO_TABLE;

/// Get the OID from the int value.
pub(crate) fn get_oid_from_int(i: i16) -> Result<Oid<'static>, Error> {
    ISSUER_SIG_ALGO_TABLE
        .get_int_to_oid_table()
        .get_map()
        .get_by_left(&i)
        .ok_or(Error::msg(format!(
            "OID not found in the signature algorithms registry table given int {i}"
        )))
        .cloned()
}
