//! General Name data provides a necessary information for encoding and decoding of C509
//! General Name. See [C509 Certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/)
//! Section 9.9 C509 General Names Registry for more information.

// cspell: words Gntr Gnvt

use std::collections::HashMap;

use anyhow::Error;
use bimap::BiMap;
use once_cell::sync::Lazy;

use super::general_name::{GeneralNameTypeRegistry, GeneralNameValueType};
use crate::tables::{IntTable, TableTrait};

/// Type of `GeneralName` data.
/// Int | Name | Type
type GeneralNameDataTuple = (i16, GeneralNameTypeRegistry, GeneralNameValueType);

/// Create a type alias for `GeneralNameTypeRegistry`
type Gntr = GeneralNameTypeRegistry;
/// Create a type alias for `GeneralNameValueType`
type Gnvt = GeneralNameValueType;

/// `GeneralName` data table.
#[rustfmt::skip]
const GENERAL_NAME_DATA: [GeneralNameDataTuple; 10] = [
    // Int |              Name              |       Type
    (-3,    Gntr::OtherNameBundleEID,           Gnvt::Unsupported),
    (-2,    Gntr::OtherNameSmtpUTF8Mailbox,     Gnvt::Text),
    (-1,    Gntr::OtherNameHardwareModuleName,  Gnvt::OtherNameHWModuleName),
    (0,     Gntr::OtherName,                    Gnvt::OtherNameHWModuleName),
    (1,     Gntr::Rfc822Name,                   Gnvt::Text),
    (2,     Gntr::DNSName,                      Gnvt::Text),
    (4,     Gntr::DirectoryName,                Gnvt::Name),
    (6,     Gntr::UniformResourceIdentifier,    Gnvt::Text),
    (7,     Gntr::IPAddress,                    Gnvt::Bytes),
    (8,     Gntr::RegisteredID,                 Gnvt::Oid),
];

/// A struct of data that contains lookup table for `GeneralName`.
pub(crate) struct GeneralNameData {
    /// A table of integer to `GeneralNameTypeRegistry`, provide a bidirectional lookup.
    int_to_name_table: IntegerToGNTable,
    /// A table of integer to `GeneralNameValueType`, provide a lookup for the type of
    /// `GeneralName` value.
    int_to_type_table: HashMap<i16, GeneralNameValueType>,
}

impl GeneralNameData {
    /// Get the `int_to_name_table`.
    pub(crate) fn get_int_to_name_table(&self) -> &IntegerToGNTable {
        &self.int_to_name_table
    }

    /// Get the `int_to_type_table`.
    pub(crate) fn get_int_to_type_table(&self) -> &HashMap<i16, GeneralNameValueType> {
        &self.int_to_type_table
    }
}

/// A struct of integer to `GeneralNameTypeRegistry` table.
#[derive(Debug, Clone, PartialEq)]
pub(crate) struct IntegerToGNTable(IntTable<GeneralNameTypeRegistry>);

impl IntegerToGNTable {
    /// Create a new instance of `IntegerToGNTable`.
    pub(crate) fn new() -> Self {
        Self(IntTable::<GeneralNameTypeRegistry>::new())
    }

    /// Add a new integer to `GeneralNameTypeRegistry` map table.
    pub(crate) fn add(&mut self, k: i16, v: GeneralNameTypeRegistry) {
        self.0.add(k, v);
    }

    /// Get the map table of integer to `GeneralNameTypeRegistry`.
    pub(crate) fn get_map(&self) -> &BiMap<i16, GeneralNameTypeRegistry> {
        self.0.get_map()
    }
}

/// Define static lookup for general names table
static GENERAL_NAME_TABLES: Lazy<GeneralNameData> = Lazy::new(|| {
    let mut int_to_name_table = IntegerToGNTable::new();
    let mut int_to_type_table = HashMap::new();

    for data in GENERAL_NAME_DATA {
        int_to_name_table.add(data.0, data.1);
        int_to_type_table.insert(data.0, data.2);
    }

    GeneralNameData {
        int_to_name_table,
        int_to_type_table,
    }
});

/// Get the general name from the int value.
pub(crate) fn get_gn_from_int(i: i16) -> Result<GeneralNameTypeRegistry, Error> {
    GENERAL_NAME_TABLES
        .get_int_to_name_table()
        .get_map()
        .get_by_left(&i)
        .ok_or(Error::msg(format!(
            "GeneralName not found in the general name registry table given int {i}"
        )))
        .cloned()
}

/// Get the int value from the general name.
pub(crate) fn get_int_from_gn(gn: GeneralNameTypeRegistry) -> Result<i16, Error> {
    GENERAL_NAME_TABLES
        .get_int_to_name_table()
        .get_map()
        .get_by_right(&gn)
        .ok_or(Error::msg(format!(
            "Int value not found in the general name registry table given GeneralName {gn:?}"
        )))
        .cloned()
}

/// Get the general name value type from the int value.
pub(crate) fn get_gn_value_type_from_int(i: i16) -> Result<GeneralNameValueType, Error> {
    GENERAL_NAME_TABLES
        .get_int_to_type_table()
        .get(&i)
        .ok_or(Error::msg(format!(
            "General name value type not found in the general name registry table given {i}"
        )))
        .cloned()
}
