//! C509 OID Extension
//! Extension fallback of C509 OID extension
//! Given OID if not found in the registered OID table, it will be encoded as a PEN OID.
//! If the OID is not a PEN OID, it will be encoded as an unwrapped OID.

// FIXME - Consider rename and moving this file to a more appropriate location.

use asn1_rs::{oid, Oid};
use bimap::BiMap;
use lazy_static::lazy_static;

use crate::c509_oid::C509oidRegistered;

struct C509ExtensionOid<'a>(C509oidRegistered<'a>);

// Define static lookup for extensions table
lazy_static! {
    /// Refernce Section - 9.4. C509 Extensions Registry.
    /// Map of OID to Extension Registry integer value.
    static ref EXTENSIONS_TABLE: BiMap<Oid<'static>, u64> = {
        let mut map = BiMap::new();

        map.insert(oid!(2.5.29 .14), 1);
        map.insert(oid!(2.5.29 .15), 2);
        map.insert(oid!(2.5.29 .17), 3);
        map.insert(oid!(2.5.29 .19), 4);
        map.insert(oid!(2.5.29 .31), 5);
        map.insert(oid!(2.5.29 .32), 6);
        map.insert(oid!(2.5.29 .35), 7);
        map.insert(oid!(2.5.29 .37), 8);
        map.insert(oid!(1.3.6 .1 .5 .5 .7 .1 .1), 9);
        map.insert(oid!(1.3.6 .1 .4 .1 .11129 .2 .4 .2), 10);
        map.insert(oid!(2.5.29 .9), 24);
        map.insert(oid!(2.5.29 .18), 25);
        map.insert(oid!(2.5.29 .30), 26);
        map.insert(oid!(2.5.29 .33), 27);
        map.insert(oid!(2.5.29 .36), 28);
        map.insert(oid!(2.5.29 .46), 29);
        map.insert(oid!(2.5.29 .54), 30);
        map.insert(oid!(1.3.6 .1 .5 .5 .7 .1 .11), 31);
        map.insert(oid!(1.3.6 .1 .5 .5 .7 .1 .7), 32);
        map
    };
}

impl<'a> C509ExtensionOid<'a> {
    fn new(oid: Oid<'a>) -> Self {
        C509ExtensionOid(C509oidRegistered::new(oid, EXTENSIONS_TABLE.clone()).pen_encoded())
    }
}
