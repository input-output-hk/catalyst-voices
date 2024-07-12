//! Public key algorithm data provides a necessary information for encoding and decoding
//! of C509 `subjectPublicKeyAlgorithm`. See [C509 Certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/)
//! Section 9.11 C509 Public Key Algorithms Registry for more information.

// cspell: words Weierstraß secp XMSS brainpool

use anyhow::Error;
use asn1_rs::{oid, Oid};
use once_cell::sync::Lazy;

use crate::tables::IntegerToOidTable;

/// Type of algorithm data
/// INT | OID | Name
type AlgorithmDataTuple = (i16, Oid<'static>, &'static str);

/// Public key algorithm data table.
#[rustfmt::skip]
const PUB_KEY_ALGO_DATA: [AlgorithmDataTuple; 9] = [
    // Int  |               OID                |            Name    
    (0, oid!(1.2.840.113549.1.1.1),         "RSA"),
    (1, oid!(1.2.840.10045.2.1),            "EC Public Key (Weierstraß) with secp256r1"),
    // (2, oid!(1.2.840.10045.2.1),            "EC Public Key (Weierstraß) with secp384r1"),
    // (3, oid!(1.2.840.10045.2.1),            "EC Public Key (Weierstraß) with secp521r1"),
    (8, oid!(1.3.101.110),                  "X25519 (Montgomery)"),
    (9, oid!(1.3.101.111),                  "X448 (Montgomery)"),
    (10, oid!(1.3.101.112),                 "Ed25519 (Twisted Edwards)"),
    (11, oid!(1.3.101.113),                 "Ed448 (Edwards)"),
    (16, oid!(1.2.840.113549.1.9.16.3.17),  "HSS / LMS"),
    (17, oid!(0.4.0.127.0.15.1.1.13.0),     "XMSS"),
    (18, oid!(0.4.0.127.0.15.1.1.14.0),     "XMSS^MT"),
    // (24, oid!(1.2.840.10045.2.1),           "EC Public Key (Weierstraß) with brainpoolP256r1"),
    // (25, oid!(1.2.840.10045.2.1),           "EC Public Key (Weierstraß) with brainpoolP384r1"),
    // (26, oid!(1.2.840.10045.2.1),           "EC Public Key (Weierstraß) with brainpoolP512r1"),
    // (27, oid!(1.2.840.10045.2.1),           "EC Public Key (Weierstraß) with FRP256v1"),
    // (28, oid!(1.2.840.10045.2.1),           "EC Public Key (Weierstraß) with sm2p256v1"),
];

/// A struct of data that contains lookup table of integer to OID in
/// bidirectional way for `SubjectPublicKeyAlgorithm`.
pub(crate) struct SubjectPubKeyAlgoData(IntegerToOidTable);

impl SubjectPubKeyAlgoData {
    /// Get the `IntegerToOidTable`
    pub(crate) fn get_int_to_oid_table(&self) -> &IntegerToOidTable {
        &self.0
    }
}

/// Define static lookup for subject publickey table
static SUBJECT_PUB_KEY_ALGO_TABLE: Lazy<SubjectPubKeyAlgoData> = Lazy::new(|| {
    let mut int_to_oid_table = IntegerToOidTable::new();

    for data in PUB_KEY_ALGO_DATA {
        int_to_oid_table.add(data.0, data.1);
    }

    SubjectPubKeyAlgoData(int_to_oid_table)
});

/// Static reference to the `SubjectPubKeyAlgoData` lookup table.
pub(crate) static SUBJECT_PUB_KEY_ALGO_LOOKUP: &Lazy<SubjectPubKeyAlgoData> =
    &SUBJECT_PUB_KEY_ALGO_TABLE;

/// Get the OID from the int value.
pub(crate) fn get_oid_from_int(i: i16) -> Result<Oid<'static>, Error> {
    SUBJECT_PUB_KEY_ALGO_TABLE
        .get_int_to_oid_table()
        .get_map()
        .get_by_left(&i)
        .ok_or(Error::msg(format!(
            "OID not found in the public key algorithms registry table given int {i}"
        )))
        .cloned()
}
