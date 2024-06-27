//! Tables
use asn1_rs::Oid;
use bimap::BiMap;
use std::hash::Hash;

use crate::c509_general_name::GeneralNamesRegistry;
pub(crate) trait TableTrait<K, V> {
    fn new(table: Vec<(K, V)>) -> Self;
    fn get_map(&self) -> &BiMap<K, V>;
}

// -----------------------------------------
#[derive(Debug)]
pub(crate) struct IntTable<T> {
    map: BiMap<i16, T>,
}

impl<T: Eq + Hash> TableTrait<i16, T> for IntTable<T> {
    fn new(table: Vec<(i16, T)>) -> Self {
        let mut map = BiMap::new();
        for entry in table {
            map.insert(entry.0, entry.1);
        }
        Self { map }
    }

    fn get_map(&self) -> &BiMap<i16, T> {
        &self.map
    }
}

// -----------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub(crate) struct IntegerToOidTable {
    map: BiMap<i16, Oid<'static>>,
}

impl IntegerToOidTable {
    pub(crate) fn new(table: Vec<(i16, Oid<'static>)>) -> Self {
        let map = IntTable::<Oid<'static>>::new(table);
        Self {
            map: map.get_map().clone(),
        }
    }

    pub(crate) fn get_map(&self) -> &BiMap<i16, Oid<'static>> {
        &self.map
    }
}

// -----------------------------------------

#[allow(dead_code)]
#[derive(Debug, Clone, PartialEq)]
pub(crate) struct IntegerToGNRegistryTable {
    map: BiMap<i16, GeneralNamesRegistry>,
}

#[allow(dead_code)]
impl IntegerToGNRegistryTable {
    pub(crate) fn new(table: Vec<(i16, GeneralNamesRegistry)>) -> Self {
        let map = IntTable::<GeneralNamesRegistry>::new(table);
        Self {
            map: map.get_map().clone(),
        }
    }

    pub(crate) fn get_map(&self) -> &BiMap<i16, GeneralNamesRegistry> {
        &self.map
    }
}
