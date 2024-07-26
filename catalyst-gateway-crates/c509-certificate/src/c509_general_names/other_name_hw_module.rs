//! `OtherNameHardwareModuleName`, special type for `hardwareModuleName` type of
//! otherName. When 'otherName + hardwareModuleName' is used, then `[ ~oid, bytes ]` is
//! used to contain the pair ( hwType, hwSerialNum ) directly as specified in
//! [RFC4108](https://datatracker.ietf.org/doc/rfc4108/)

use asn1_rs::Oid;
use minicbor::{encode::Write, Decode, Decoder, Encode, Encoder};
use serde::{Deserialize, Serialize};

use crate::c509_oid::C509oid;

/// A struct represents the hardwareModuleName type of otherName.
/// Containing a pair of ( hwType, hwSerialNum ) as mentioned in
/// [RFC4108](https://datatracker.ietf.org/doc/rfc4108/)
#[derive(Debug, Clone, PartialEq, Eq, Hash, Deserialize, Serialize)]
pub struct OtherNameHardwareModuleName {
    /// The hardware type OID.
    hw_type: C509oid,
    /// The hardware serial number represent in bytes.
    hw_serial_num: Vec<u8>,
}

impl OtherNameHardwareModuleName {
    /// Create a new instance of `OtherNameHardwareModuleName`.
    #[must_use]
    pub fn new(hw_type: Oid<'static>, hw_serial_num: Vec<u8>) -> Self {
        Self {
            hw_type: C509oid::new(hw_type),
            hw_serial_num,
        }
    }
}

impl Encode<()> for OtherNameHardwareModuleName {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        e.array(2)?;
        self.hw_type.encode(e, ctx)?;
        e.bytes(&self.hw_serial_num)?;
        Ok(())
    }
}

impl<'a> Decode<'a, ()> for OtherNameHardwareModuleName {
    fn decode(d: &mut Decoder<'a>, ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
        d.array()?;
        let hw_type = C509oid::decode(d, ctx)?;
        let hw_serial_num = d.bytes()?.to_vec();
        Ok(OtherNameHardwareModuleName::new(
            hw_type.get_oid(),
            hw_serial_num,
        ))
    }
}
