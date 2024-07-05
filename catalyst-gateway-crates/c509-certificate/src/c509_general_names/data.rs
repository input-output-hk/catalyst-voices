//! General Name data provides a necessary information for encoding and decoding of C509
//! General Name. See [C509 Certificate](https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/)
//! Section 9.9 C509 General Names Registry for more information.

use std::collections::HashMap;

use bimap::BiMap;
use once_cell::sync::Lazy;

use super::general_name::{GeneralNameRegistry, GeneralNameValueType};
use crate::tables::{IntTable, TableTrait};

/// Type of `GeneralName` data.
/// Int | Name | Type
type GeneralNameDataTuple = (i16, GeneralNameRegistry, GeneralNameValueType);

/// `GeneralName` data table.
const GENERAL_NAME_DATA: [GeneralNameDataTuple; 10] = [
    (
        -3,
        GeneralNameRegistry::OtherNameBundleEID,
        GeneralNameValueType::Unsupported,
    ),
    (
        -2,
        GeneralNameRegistry::OtherNameSmtpUTF8Mailbox,
        GeneralNameValueType::Text,
    ),
    (
        -1,
        GeneralNameRegistry::OtherNameHardwareModuleName,
        GeneralNameValueType::OtherNameHWModuleName,
    ),
    (
        0,
        GeneralNameRegistry::OtherName,
        GeneralNameValueType::OtherNameHWModuleName,
    ),
    (
        1,
        GeneralNameRegistry::Rfc822Name,
        GeneralNameValueType::Text,
    ),
    (2, GeneralNameRegistry::DNSName, GeneralNameValueType::Text),
    (
        4,
        GeneralNameRegistry::DirectoryName,
        GeneralNameValueType::Unsupported,
    ),
    (
        6,
        GeneralNameRegistry::UniformResourceIdentifier,
        GeneralNameValueType::Text,
    ),
    (
        7,
        GeneralNameRegistry::IPAddress,
        GeneralNameValueType::Bytes,
    ),
    (
        8,
        GeneralNameRegistry::RegisteredID,
        GeneralNameValueType::Oid,
    ),
];

/// A struct of data that contains lookup table for `GeneralName`.
pub(crate) struct GeneralNameData {
    /// A table of integer to `GeneralNameRegistry`, provide a bidirectional lookup.
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

/// A struct of integer to `GeneralNameRegistry` table.
#[derive(Debug, Clone, PartialEq)]
pub(crate) struct IntegerToGNTable {
    /// Table of integer to `GeneralNameRegistry`.
    table: IntTable<GeneralNameRegistry>,
}

impl IntegerToGNTable {
    /// Create a new instance of `IntegerToGNTable`.
    pub(crate) fn new() -> Self {
        Self {
            table: IntTable::<GeneralNameRegistry>::new(),
        }
    }

    /// Add a new integer to `GeneralNameRegistry` map table.
    pub(crate) fn add(&mut self, k: i16, v: GeneralNameRegistry) {
        self.table.add(k, v);
    }

    /// Get the map table of integer to `GeneralNameRegistry`.
    pub(crate) fn get_map(&self) -> &BiMap<i16, GeneralNameRegistry> {
        self.table.get_map()
    }
}

/// Define static lookup for general names table
pub(crate) static GENERAL_NAME_TABLES: Lazy<GeneralNameData> = Lazy::new(|| {
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
