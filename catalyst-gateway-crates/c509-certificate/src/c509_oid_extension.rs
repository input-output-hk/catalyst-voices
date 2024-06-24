//! C509 OID Extension
//! Extension fallback of C509 OID extension
//! Given OID if not found in the registered OID table, it will be encoded as a PEN OID.
//! If the OID is not a PEN OID, it will be encoded as an unwrapped OID.

// FIXME - Consider rename and moving this file to a more appropriate location.

use asn1_rs::{oid, Oid};
use bimap::BiMap;
use minicbor::{encode::Write, Encode, Encoder};
use once_cell::sync::Lazy;

use crate::c509_oid::{C509oid, C509oidRegistered};

// Define static lookup for extensions table
/// Refernce Section - 9.4. C509 Extensions Registry.
/// Map of OID to Extension Registry integer value.
static EXTENSIONS_TABLE: Lazy<BiMap<C509oid<'static>, i16>> = Lazy::new(|| {
    let mut map = BiMap::new();

    // FIXME - .pen_encoded()
    // Subject Key Identifier
    map.insert(C509oid::new(oid!(2.5.29 .14)).pen_encoded(), 1);
    // Key Usage
    map.insert(C509oid::new(oid!(2.5.29 .15)).pen_encoded(), 2);
    // Subject Alternative Name
    map.insert(C509oid::new(oid!(2.5.29 .17)).pen_encoded(), 3);
    // Basic Constraints
    map.insert(C509oid::new(oid!(2.5.29 .19)).pen_encoded(), 4);
    // CRL Distribution Points
    map.insert(C509oid::new(oid!(2.5.29 .31)).pen_encoded(), 5);
    // Certificate Policies
    map.insert(C509oid::new(oid!(2.5.29 .32)).pen_encoded(), 6);
    // Authority Key Identifier
    map.insert(C509oid::new(oid!(2.5.29 .35)).pen_encoded(), 7);
    // Extended Key Usage
    map.insert(C509oid::new(oid!(2.5.29 .37)).pen_encoded(), 8);
    // Authority Information Access
    map.insert(C509oid::new(oid!(1.3.6 .1 .5 .5 .7 .1 .1)).pen_encoded(), 9);
    // Signed Certificate Timestamp List
    map.insert(
        C509oid::new(oid!(1.3.6 .1 .4 .1 .11129 .2 .4 .2)).pen_encoded(),
        10,
    );
    // Subject Directory Attributes
    map.insert(C509oid::new(oid!(2.5.29 .9)).pen_encoded(), 24);
    // Issuer Alternative Name
    map.insert(C509oid::new(oid!(2.5.29 .18)).pen_encoded(), 25);
    // Name Constraints
    map.insert(C509oid::new(oid!(2.5.29 .30)).pen_encoded(), 26);
    // Policy Mappings
    map.insert(C509oid::new(oid!(2.5.29 .33)).pen_encoded(), 27);
    // Policy Constraints
    map.insert(C509oid::new(oid!(2.5.29 .36)).pen_encoded(), 28);
    // Freshest CRL
    map.insert(C509oid::new(oid!(2.5.29 .46)).pen_encoded(), 29);
    // Inhibit anyPolicy
    map.insert(C509oid::new(oid!(2.5.29 .54)).pen_encoded(), 30);
    // Subject Information Access
    map.insert(
        C509oid::new(oid!(1.3.6 .1 .5 .5 .7 .1 .11)).pen_encoded(),
        31,
    );
    // AS Resource
    map.insert(
        C509oid::new(oid!(1.3.6 .1 .5 .5 .7 .1 .7)).pen_encoded(),
        32,
    );
    // IP Resources v2
    map.insert(
        C509oid::new(oid!(1.3.6 .1 .5 .5 .7 .1 .28)).pen_encoded(),
        34,
    );
    // AS Resources v2
    map.insert(
        C509oid::new(oid!(1.3.6 .1 .5 .5 .7 .1 .29)).pen_encoded(),
        35,
    );
    // Biometric Information
    map.insert(
        C509oid::new(oid!(1.3.6 .1 .5 .5 .7 .1 .2)).pen_encoded(),
        36,
    );
    // Precertificate Signing Certificate
    map.insert(
        C509oid::new(oid!(1.3.6 .1 .4 .1 .11129 .2 .4 .4)).pen_encoded(),
        37,
    );
    // OCSP No Check
    map.insert(
        C509oid::new(oid!(1.3.6 .1 .5 .5 .7 .48 .1 .5)).pen_encoded(),
        38,
    );
    map
});

// -----------------------------------------

#[allow(dead_code)]
struct C509ExtensionOid<'a> {
    registered_oid: C509oidRegistered<'a>,
    critical: bool,
}

#[allow(dead_code)]
impl<'a> C509ExtensionOid<'a> {
    fn new(oid: Oid<'a>) -> Self {
        C509ExtensionOid {
            registered_oid: C509oidRegistered::new(oid, &EXTENSIONS_TABLE).pen_encoded(),
            critical: false,
        }
    }

    pub fn critical(mut self) -> Self {
        self.critical = true;
        self
    }
}

impl<C> Encode<C> for C509ExtensionOid<'_> {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut C,
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        // Handle CBOR int
        if let Some(&value) = self
            .registered_oid
            .get_table()
            .get_by_left(&self.registered_oid.c509_oid())
        {
            // Handle critical flag
            let encoded_value = if self.critical { -value } else { value };
            e.i16(encoded_value)?;
        // Handle unwrapped CBOR OID or CBOR PEN
        } else {
            self.registered_oid.c509_oid().encode(e, ctx)?;
        }
        Ok(())
    }
}

// -----------------------------------------

#[cfg(test)]
mod test_c509_extension {
    use super::*;

    #[test]
    fn test_c509_extension_int() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        // Precertificate Signing Certificate
        let oid = C509ExtensionOid::new(oid!(1.3.6 .1 .4 .1 .11129 .2 .4 .4));
        oid.encode(&mut encoder, &mut ())
            .expect("Failed to encode OID");
        assert_eq!(hex::encode(buffer), "1825");
    }

    #[test]
    fn test_c509_extension_oid_critical() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        // Precertificate Signing Certificate
        let oid = C509ExtensionOid::new(oid!(1.3.6 .1 .4 .1 .11129 .2 .4 .4)).critical();
        oid.encode(&mut encoder, &mut ())
            .expect("Failed to encode OID");
        assert_eq!(hex::encode(buffer), "3824");
    }

    #[test]
    fn test_c509_extension_oid_pen() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        // Precertificate Signing Certificate
        let oid = C509ExtensionOid::new(oid!(1.3.6 .1 .4 .1 .1 .1 .29));
        oid.encode(&mut encoder, &mut ())
            .expect("Failed to encode OID");
        assert_eq!(hex::encode(buffer), "d8704301011d");
    }

    #[test]
    fn test_c509_extension_oid_pen_critical() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);

        // Precertificate Signing Certificate
        // Critical should not work since the OID is not in the registry table
        let oid = C509ExtensionOid::new(oid!(1.3.6 .1 .4 .1 .1 .1 .29)).critical();
        oid.encode(&mut encoder, &mut ())
            .expect("Failed to encode OID");
        assert_eq!(hex::encode(buffer), "d8704301011d");
    }

    #[test]
    fn test_c509_extension_oid_unwrapped() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        // Not PEN OID and not in the registry table
        let oid = C509ExtensionOid::new(oid!(2.16.840 .1 .101 .3 .4 .2 .1));
        oid.encode(&mut encoder, &mut ())
            .expect("Failed to encode OID");
        assert_eq!(hex::encode(buffer.clone()), "49608648016503040201");
    }

    #[test]
    fn test_c509_extension_oid_unwrapped_critical() {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        // Not PEN OID and not in the registry table
        // Critical should not work since the OID is not in the registry table
        let oid = C509ExtensionOid::new(oid!(2.16.840 .1 .101 .3 .4 .2 .1)).critical();
        oid.encode(&mut encoder, &mut ())
            .expect("Failed to encode OID");
        assert_eq!(hex::encode(buffer.clone()), "49608648016503040201");
    }
}
