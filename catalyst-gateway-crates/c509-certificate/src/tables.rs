//! A bimap table for bidirectional lookup.

use std::hash::Hash;

use asn1_rs::Oid;
use bimap::BiMap;

/// A trait that represents a table structure with key-value pairs.
///
/// # Type Parameters
///
/// * `K` - The type of the keys in the table.
/// * `V` - The type of the values in the table.
pub(crate) trait TableTrait<K, V> {
    /// Create new instance of the map table.
    fn new() -> Self;
    /// Add the key-value pair to the map table.
    fn add(&mut self, k: K, v: V);
    /// Get the bimap of the map table.
    fn get_map(&self) -> &BiMap<K, V>;
}

// -----------------------------------------

/// A struct that represents a table mapping integers to any type that
/// implements `Eq` and `Hash`.
/// i16 is used because the int value in C509 certificate registry can be -256 to 255.
#[derive(Debug, Clone, PartialEq)]
pub(crate) struct IntTable<T: Eq + Hash> {
    /// A bimap table for bidirectional lookup where it map between i16 and other type.
    map: BiMap<i16, T>,
}

impl<T: Eq + Hash> TableTrait<i16, T> for IntTable<T> {
    /// Create new instance of `IntTable`.
    fn new() -> Self {
        Self { map: BiMap::new() }
    }

    /// Add the key-value pair to the map table.
    fn add(&mut self, k: i16, v: T) {
        self.map.insert(k, v);
    }

    /// Get the bimap of the map table.
    fn get_map(&self) -> &BiMap<i16, T> {
        &self.map
    }
}

// -----------------------------------------

/// A struct represents a table of integer to OID.
#[derive(Debug, Clone, PartialEq)]
pub(crate) struct IntegerToOidTable {
    /// A table of integer to OID, provide a bidirectional lookup.
    table: IntTable<Oid<'static>>,
}

#[allow(dead_code)]
impl IntegerToOidTable {
    /// Create new instance of `IntegerToOidTable`.
    pub(crate) fn new() -> Self {
        Self {
            table: IntTable::<Oid<'static>>::new(),
        }
    }

    /// Add the key-value pair to the map table.
    pub(crate) fn add(&mut self, k: i16, v: Oid<'static>) {
        self.table.add(k, v);
    }

    /// Get the bimap of the map table.
    pub(crate) fn get_map(&self) -> &BiMap<i16, Oid<'static>> {
        self.table.get_map()
    }
}
