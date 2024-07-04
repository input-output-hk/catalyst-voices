//! Extension data provides a necessary information for encoding and decoding of C509 Extension.
//! See [RFC9090](https://datatracker.ietf.org/doc/rfc9090/) Section 9.4 C509 Extensions Registry
//! for more information.

use std::collections::HashMap;

use crate::tables::IntegerToOidTable;
use asn1_rs::{oid, Oid};
use once_cell::sync::Lazy;

use super::ExtensionValueType;

/// Type of Extension data
/// Int | OID | Type | Name
type ExtensionDataTuple = (i16, Oid<'static>, ExtensionValueType, &'static str);

const EXTENSION_DATA: [ExtensionDataTuple; 25] = [
    (
        1,
        oid!(2.5.29 .14),
        ExtensionValueType::Bytes,
        "Subject Key Identifier",
    ),
    (2, oid!(2.5.29 .15), ExtensionValueType::Int, "Key Usage"),
    (
        3,
        oid!(2.5.29 .17),
        ExtensionValueType::AltName,
        "Subject Alternative Name",
    ),
    (
        4,
        oid!(2.5.29 .19),
        ExtensionValueType::Int,
        "Basic Constraints",
    ),
    (
        5,
        oid!(2.5.29 .31),
        ExtensionValueType::Unsupported,
        "CRL Distribution Points",
    ),
    (
        6,
        oid!(2.5.29 .32),
        ExtensionValueType::Unsupported,
        "Certificate Policies",
    ),
    (
        7,
        oid!(2.5.29 .35),
        ExtensionValueType::Unsupported,
        "Authority Key Identifier",
    ),
    (
        8,
        oid!(2.5.29 .37),
        ExtensionValueType::Unsupported,
        "Extended Key Usage",
    ),
    (
        9,
        oid!(1.3.6 .1 .5 .5 .7 .1 .1),
        ExtensionValueType::Unsupported,
        "Authority Information Access",
    ),
    (
        10,
        oid!(1.3.6 .1 .4 .1 .11129 .2 .4 .2),
        ExtensionValueType::Unsupported,
        "Signed Certificate Timestamp List",
    ),
    (
        24,
        oid!(2.5.29 .9),
        ExtensionValueType::Unsupported,
        "Subject Directory Attributes",
    ),
    (
        25,
        oid!(2.5.29 .18),
        ExtensionValueType::AltName,
        "Issuer Alternative Name",
    ),
    (
        26,
        oid!(2.5.29 .30),
        ExtensionValueType::Unsupported,
        "Name Constraints",
    ),
    (
        27,
        oid!(2.5.29 .33),
        ExtensionValueType::Unsupported,
        "Policy Mappings",
    ),
    (
        28,
        oid!(2.5.29 .36),
        ExtensionValueType::Unsupported,
        "Policy Constraints",
    ),
    (
        29,
        oid!(2.5.29 .46),
        ExtensionValueType::Unsupported,
        "Freshest CRL",
    ),
    (
        30,
        oid!(2.5.29 .54),
        ExtensionValueType::Int,
        "Inhibit anyPolicy",
    ),
    (
        31,
        oid!(1.3.6 .1 .5 .5 .7 .1 .11),
        ExtensionValueType::Unsupported,
        "Subject Information Access",
    ),
    (
        32,
        oid!(1.3.6 .1 .5 .5 .7 .1 .7),
        ExtensionValueType::Unsupported,
        "IP Resources",
    ),
    (
        33,
        oid!(1.3.6 .1 .5 .5 .7 .1 .7),
        ExtensionValueType::Unsupported,
        "AS Resource",
    ),
    (
        34,
        oid!(1.3.6 .1 .5 .5 .7 .1 .28),
        ExtensionValueType::Unsupported,
        "IP Resources v2",
    ),
    (
        35,
        oid!(1.3.6 .1 .5 .5 .7 .1 .29),
        ExtensionValueType::Unsupported,
        "AS Resources v2",
    ),
    (
        36,
        oid!(1.3.6 .1 .5 .5 .7 .1 .2),
        ExtensionValueType::Unsupported,
        "Biometric Information",
    ),
    (
        37,
        oid!(1.3.6 .1 .4 .1 .11129 .2 .4 .4),
        ExtensionValueType::Unsupported,
        "Precertificate Signing Certificate",
    ),
    (
        38,
        oid!(1.3.6 .1 .5 .5 .7 .48 .1 .5),
        ExtensionValueType::Unsupported,
        "OCSP No Check",
    ),
];

/// A struct of data that contains lookup tables for `Extension`.
///
/// # Fields
/// * `int_to_oid_table` - A table of integer to OID, provide a bidrectional lookup.
/// * `int_to_type_table` - A table of integer to `ExtensionValueType`, provide a lookup for `Extension` value type.
pub(crate) struct ExtensionData {
    int_to_oid_table: IntegerToOidTable,
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
pub(crate) static EXTENSIONS_TABLES: Lazy<ExtensionData> = Lazy::new(|| {
    let mut int_to_oid_table = IntegerToOidTable::new();
    let mut int_to_type_table = HashMap::<i16, ExtensionValueType>::new();

    for data in EXTENSION_DATA {
        int_to_oid_table.add(data.0, data.1);
        int_to_type_table.insert(data.0, data.2);
    }

    return ExtensionData {
        int_to_oid_table,
        int_to_type_table,
    };
});
