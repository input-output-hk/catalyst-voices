//! Tables
use asn1_rs::Oid;
use bimap::BiMap;
use std::hash::Hash;

pub(crate) trait TableTrait<K, V> {
    fn new() -> Self;
    fn add(&mut self, k: K, v: V);
    fn get_map(&self) -> &BiMap<K, V>;
}

// -----------------------------------------
#[derive(Debug, Clone, PartialEq)]
pub(crate) struct IntTable<T: Eq + Hash> {
    // Using i16 because the int value can be -256 to 255
    map: BiMap<i16, T>,
}

impl<T: Eq + Hash> TableTrait<i16, T> for IntTable<T> {
    fn new() -> Self {
        Self { map: BiMap::new() }
    }

    fn add(&mut self, k: i16, v: T) {
        self.map.insert(k, v);
    }
    fn get_map(&self) -> &BiMap<i16, T> {
        &self.map
    }
}

// -----------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub(crate) struct IntegerToOidTable {
    table: IntTable<Oid<'static>>,
}

#[allow(dead_code)]
impl IntegerToOidTable {
    pub(crate) fn new() -> Self {
        Self {
            table: IntTable::<Oid<'static>>::new(),
        }
    }
    pub(crate) fn add(&mut self, k: i16, v: Oid<'static>) {
        self.table.add(k, v);
    }

    pub(crate) fn get_map(&self) -> &BiMap<i16, Oid<'static>> {
        self.table.get_map()
    }
}
