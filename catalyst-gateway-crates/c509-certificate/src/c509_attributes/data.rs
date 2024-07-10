//! Attribute data provides a necessary information for encoding and decoding of C509
//! Attribute. See [C509 Certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/)
//! Section 9.3 C509 Attributes Registry for more information.

use anyhow::Error;
use asn1_rs::{oid, Oid};
use once_cell::sync::Lazy;

use crate::tables::IntegerToOidTable;

/// Type of `Attribute` data
/// Int | OID | Name
type AttributeDataTuple = (i16, Oid<'static>, &'static str);

/// `Attribute` data table
#[rustfmt::skip]
const ATTRIBUTE_DATA: [AttributeDataTuple; 30] = [
    // Int |           OID               |       Name
    (0, oid!(1.2.840.113549.1.9.1),         "Email Address"),
    (1, oid!(2.5.4.3),                      "Common Name"),
    (2, oid!(2.5.4.4),                      "Surname"),
    (3, oid!(2.5.4.5),                      "Serial Number"),
    (4, oid!(2.5.4.6),                      "Country"),
    (5, oid!(2.5.4.7),                      "Locality"),
    (6, oid!(2.5.4.8),                      "State or Province"),
    (7, oid!(2.5.4.9),                      "Street Address"),
    (8, oid!(2.5.4.10),                     "Organization"),
    (9, oid!(2.5.4.11),                     "Organizational Unit"),
    (10, oid!(2.5.4.12),                    "Title"),
    (11, oid!(2.5.4.15),                    "Business Category"),
    (12, oid!(2.5.4.17),                    "Postal Code"),
    (13, oid!(2.5.4.42),                    "Given Name"),
    (14, oid!(2.5.4.43),                    "Initials"),
    (15, oid!(2.5.4.44),                    "Generation Qualifier"),
    (16, oid!(2.5.4.46),                    "DN Qualifier"),
    (17, oid!(2.5.4.65),                    "Pseudonym"),
    (18, oid!(2.5.4.97),                    "Organization Identifier"),
    (19, oid!(1.3.6.1.4.1.311.60.2.1.1),    "Inc. Locality"),
    (20, oid!(1.3.6.1.4.1.311.60.2.1.2),    "Inc. State or Province"),
    (21, oid!(1.3.6.1.4.1.311.60.2.1.3),    "Inc. Country"),
    (22, oid!(0.9.2342.19200300.100.1.25),  "Domain Component"),
    (23, oid!(2.5.4.16),                    "Postal Address"),
    (24, oid!(2.5.4.41),                    "Name"),
    (25, oid!(2.5.4.20),                    "Telephone Number"),
    (26, oid!(2.5.4.54),                    "Directory Management Domain Name"),
    (27, oid!(0.9.2342.19200300.100.1.1),   "userid"),
    (28, oid!(1.2.840.113549.1.9.2),        "Unstructured Name"),
    (29, oid!(1.2.840.113549.1.9.8),        "Unstructured Address"),
];

/// A struct of data that contains lookup tables for `Attribute`.
pub(crate) struct AttributeData {
    /// A table of integer to OID, provide a bidirectional lookup.
    int_to_oid_table: IntegerToOidTable,
}

impl AttributeData {
    /// Get the `IntegerToOidTable`.
    pub(crate) fn get_int_to_oid_table(&self) -> &IntegerToOidTable {
        &self.int_to_oid_table
    }
}

/// Define static lookup for attributes table
static ATTRIBUTES_TABLES: Lazy<AttributeData> = Lazy::new(|| {
    let mut int_to_oid_table = IntegerToOidTable::new();

    for data in ATTRIBUTE_DATA {
        int_to_oid_table.add(data.0, data.1);
    }

    AttributeData { int_to_oid_table }
});

/// Static reference to the `AttributeData` lookup table.
pub(crate) static ATTRIBUTES_LOOKUP: &Lazy<AttributeData> = &ATTRIBUTES_TABLES;

/// Get the OID from the int value.
pub(crate) fn get_oid_from_int(i: i16) -> Result<Oid<'static>, Error> {
    ATTRIBUTES_TABLES
        .get_int_to_oid_table()
        .get_map()
        .get_by_left(&i)
        .ok_or(Error::msg(format!(
            "OID int not found in the attribute registry table given {i}"
        )))
        .cloned()
}
