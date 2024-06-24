//! C509 OID Extension OIDs
//! Extension fallback of C509 OID extension
//! Given OID if not found in the registered OID table, it will be encoded as a PEN OID.
//! If the OID is not a PEN OID, it will be encoded as an unwrapped OID.

// FIXME - Consider rename and moving this file to a more appropriate location.

use asn1_rs::{oid, Oid};
use minicbor::{encode::Write, Decode, Encode, Encoder};
use once_cell::sync::Lazy;

use crate::c509_oid::{C509oidRegistered, OidToIntegerTable};

// Define static lookup for extensions table
/// Refernce Section - 9.4. C509 Extensions Registry.
/// Map of OID to Extension Registry integer value.
static EXTENSIONS_TABLE: Lazy<OidToIntegerTable> = Lazy::new(|| {
    OidToIntegerTable::new(vec![
        (1, oid!(2.5.29 .14)),                      // Subject Key Identifier
        (2, oid!(2.5.29 .15)),                      // Key Usage
        (3, oid!(2.5.29 .17)),                      // Subject Alternative Name
        (4, oid!(2.5.29 .19)),                      // Basic Constraints
        (5, oid!(2.5.29 .31)),                      // CRL Distribution Points
        (6, oid!(2.5.29 .32)),                      // Certificate Policies
        (7, oid!(2.5.29 .35)),                      // Authority Key Identifier
        (8, oid!(2.5.29 .37)),                      // Extended Key Usage
        (9, oid!(1.3.6 .1 .5 .5 .7 .1 .1)),         // Authority Information Access
        (10, oid!(1.3.6 .1 .4 .1 .11129 .2 .4 .2)), // Signed Certificate Timestamp List
        (24, oid!(2.5.29 .9)),                      // Subject Directory Attributes
        (25, oid!(2.5.29 .18)),                     // Issuer Alternative Name
        (26, oid!(2.5.29 .30)),                     // Name Constraints
        (27, oid!(2.5.29 .33)),                     // Policy Mappings
        (28, oid!(2.5.29 .36)),                     // Policy Constraints
        (29, oid!(2.5.29 .46)),                     // Freshest CRL
        (30, oid!(2.5.29 .54)),                     // Inhibit anyPolicy
        (31, oid!(1.3.6 .1 .5 .5 .7 .1 .11)),       // Subject Information Access
        (32, oid!(1.3.6 .1 .5 .5 .7 .1 .7)),        // AS Resource
        (34, oid!(1.3.6 .1 .5 .5 .7 .1 .28)),       // IP Resources v2
        (35, oid!(1.3.6 .1 .5 .5 .7 .1 .29)),       // AS Resources v2
        (36, oid!(1.3.6 .1 .5 .5 .7 .1 .2)),        // Biometric Information
        (37, oid!(1.3.6 .1 .4 .1 .11129 .2 .4 .4)), // Precertificate Signing Certificate
        (38, oid!(1.3.6 .1 .5 .5 .7 .48 .1 .5)),    // OCSP No Check
    ])
});

// -----------------------------------------

#[allow(dead_code)]
pub struct C509Extension<'a, T>
where
    T: Encode<T> + Decode<'a, T>,
{
    registered_oid: C509oidRegistered<'a>,
    critical: bool,
    value: T,
}

#[allow(dead_code)]
impl<'a, T> C509Extension<'a, T>
where
    T: Encode<T> + Decode<'a, T>,
{
    fn new(oid: Oid<'a>, value: T) -> Self {
        C509Extension {
            registered_oid: C509oidRegistered::new(oid, &EXTENSIONS_TABLE).pen_encoded(),
            critical: false,
            value,
        }
    }

    pub fn critical(mut self) -> Self {
        self.critical = true;
        self
    }

    pub fn set(mut self, value: T) -> Self {
        self.value = value;
        self
    }
}

impl<'a, T, C> Encode<C> for C509Extension<'a, T>
where
    T: Encode<T> + Decode<'a, T>,
{
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut C,
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        // Handle CBOR int
        if let Some(&oid) = self
            .registered_oid
            .get_table()
            .get_map()
            .get_by_right(&self.registered_oid.get_oid())
        {
            // Handle critical flag
            let encoded_oid = if self.critical { -oid } else { oid };
            e.i16(encoded_oid)?;
        // Handle unwrapped CBOR OID or CBOR PEN
        } else {
            self.registered_oid.get_c509_oid().encode(e, ctx)?;
            if self.critical {
                e.bool(true)?;
            }
        }
        // FIXME - Handle encoding of value
        self.value.encode(e, _)?;
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
