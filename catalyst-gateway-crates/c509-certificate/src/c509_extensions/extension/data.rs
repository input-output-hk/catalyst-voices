//! Extension data provides a necessary information for encoding and decoding of C509
//! Extension. See [C509 Certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/)
//! Section 9.4 C509 Extensions Registry for more information.

// cspell: words Evt

use std::collections::HashMap;

use anyhow::Error;
use asn1_rs::{oid, Oid};
use once_cell::sync::Lazy;

use super::ExtensionValueType;
use crate::tables::IntegerToOidTable;

/// Type of `Extension` data
/// Int | OID | Type | Name
type ExtensionDataTuple = (i16, Oid<'static>, ExtensionValueType, &'static str);

/// Create a type alias for `ExtensionValueType`
type Evt = ExtensionValueType;

/// `Extension` data table
#[rustfmt::skip]
const EXTENSION_DATA: [ExtensionDataTuple; 25] = [
    // Int |    OID     |                   Type                    |           Name
    ( 1, oid!(2.5.29 .14),                     Evt::Bytes,           "Subject Key Identifier"),
    ( 2, oid!(2.5.29 .15),                     Evt::Int,             "Key Usage"),
    ( 3, oid!(2.5.29 .17),                     Evt::AlternativeName, "Subject Alternative Name"),
    ( 4, oid!(2.5.29 .19),                     Evt::Int,             "Basic Constraints"),
    ( 5, oid!(2.5.29 .31),                     Evt::Unsupported,     "CRL Distribution Points"),
    ( 6, oid!(2.5.29 .32),                     Evt::Unsupported,     "Certificate Policies"),
    ( 7, oid!(2.5.29 .35),                     Evt::Unsupported,     "Authority Key Identifier"),
    ( 8, oid!(2.5.29 .37),                     Evt::Unsupported,     "Extended Key Usage"),
    ( 9, oid!(1.3.6 .1 .5 .5 .7 .1 .1),        Evt::Unsupported,     "Authority Information Access"),
    (10, oid!(1.3.6 .1 .4 .1 .11129 .2 .4 .2), Evt::Unsupported,   "Signed Certificate Timestamp List"),
    (24, oid!(2.5.29 .9),                      Evt::Unsupported,     "Subject Directory Attributes"),
    (25, oid!(2.5.29 .18),                     Evt::AlternativeName, "Issuer Alternative Name"),
    (26, oid!(2.5.29 .30),                     Evt::Unsupported,     "Name Constraints"),
    (27, oid!(2.5.29 .33),                     Evt::Unsupported,     "Policy Mappings"),
    (28, oid!(2.5.29 .36),                     Evt::Unsupported,     "Policy Constraints"),
    (29, oid!(2.5.29 .46),                     Evt::Unsupported,     "Freshest CRL"),
    (30, oid!(2.5.29 .54),                     Evt::Int,             "Inhibit anyPolicy"),
    (31, oid!(1.3.6 .1 .5 .5 .7 .1 .11),       Evt::Unsupported,     "Subject Information Access"),
    (32, oid!(1.3.6 .1 .5 .5 .7 .1 .7),        Evt::Unsupported,     "IP Resources"),
    (33, oid!(1.3.6 .1 .5 .5 .7 .1 .7),        Evt::Unsupported,     "AS Resource"),
    (34, oid!(1.3.6 .1 .5 .5 .7 .1 .28),       Evt::Unsupported,     "IP Resources v2"),
    (35, oid!(1.3.6 .1 .5 .5 .7 .1 .29),       Evt::Unsupported,     "AS Resources v2"),
    (36, oid!(1.3.6 .1 .5 .5 .7 .1 .2),        Evt::Unsupported,     "Biometric Information"),
    (37, oid!(1.3.6 .1 .4 .1 .11129 .2 .4 .4), Evt::Unsupported,   "Precertificate Signing Certificate"),
    (38, oid!(1.3.6 .1 .5 .5 .7 .48 .1 .5),    Evt::Unsupported,     "OCSP No Check"),
];

/// A struct of data that contains lookup tables for `Extension`.
pub(crate) struct ExtensionData {
    /// A table of integer to OID, provide a bidirectional lookup.
    int_to_oid_table: IntegerToOidTable,
    /// A table of integer to `ExtensionValueType`, provide a lookup for `Extension` value
    /// type.
    int_to_type_table: HashMap<i16, ExtensionValueType>,
}

impl ExtensionData {
    /// Get the `IntegerToOidTable`.
    pub(crate) fn get_int_to_oid_table(&self) -> &IntegerToOidTable {
        &self.int_to_oid_table
    }

    /// Get the `int_to_type_table`
    pub(crate) fn get_int_to_type_table(&self) -> &HashMap<i16, ExtensionValueType> {
        &self.int_to_type_table
    }
}

/// Define static lookup for extensions table
static EXTENSIONS_TABLES: Lazy<ExtensionData> = Lazy::new(|| {
    let mut int_to_oid_table = IntegerToOidTable::new();
    let mut int_to_type_table = HashMap::<i16, ExtensionValueType>::new();

    for data in EXTENSION_DATA {
        int_to_oid_table.add(data.0, data.1);
        int_to_type_table.insert(data.0, data.2);
    }

    ExtensionData {
        int_to_oid_table,
        int_to_type_table,
    }
});

/// Static reference to the `ExtensionData` lookup table.
pub(crate) static EXTENSIONS_LOOKUP: &Lazy<ExtensionData> = &EXTENSIONS_TABLES;

/// Get the OID from the int value.
pub(crate) fn get_oid_from_int(i: i16) -> Result<Oid<'static>, Error> {
    EXTENSIONS_TABLES
        .get_int_to_oid_table()
        .get_map()
        .get_by_left(&i)
        .ok_or(Error::msg(format!(
            "OID not found in the extension registry table given int {i}"
        )))
        .cloned()
}

/// Get the extension value type from the int value.
pub(crate) fn get_extension_type_from_int(i: i16) -> Result<ExtensionValueType, Error> {
    EXTENSIONS_TABLES
        .get_int_to_type_table()
        .get(&i)
        .ok_or(Error::msg(format!(
            "Extension value type not found in the extension registry table given int {i}"
        )))
        .cloned()
}
