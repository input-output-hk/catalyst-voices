//! Role 0 Key Id (Kid)

use std::fmt;

use as_slice::AsSlice;
use minicbor::{encode::Write, Decode, Decoder, Encode, Encoder};
use pallas::crypto::hash::Hash;
use to_vec::ToVec;

use crate::utils::blake2b_hash::blake2b_128;

/// Length of the role0 hash
const ROLE0_KID_LENGTH: usize = 16;

/// Role 0 Key ID - Blake2b-128 hash of the Role 0 Certificate defining the Session public
/// key.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub(crate) struct Role0Kid(Hash<ROLE0_KID_LENGTH>);

impl Role0Kid {
    /// Create a new Role0 Kid from a Certificate.
    ///
    /// `cert` should be a valid X509 or C509 certificate, this is not checked.
    pub fn new(cert: &[u8]) -> Self {
        let kid = blake2b_128(cert);
        Self(kid.into())
    }
}

// Check if the certificate represented as a Vec<u8> matches this Kid
impl PartialEq<Vec<u8>> for Role0Kid {
    fn eq(&self, other: &Vec<u8>) -> bool {
        *self == Self::new(other)
    }
}

impl AsSlice for Role0Kid {
    type Element = u8;

    fn as_slice(&self) -> &[u8] {
        self.0.as_slice()
    }
}

impl ToVec<u8> for Role0Kid {
    fn to_vec(self) -> Vec<u8> {
        self.0.to_vec()
    }
}

impl Decode<'_, ()> for Role0Kid {
    fn decode(
        d: &mut Decoder<'_>, (): &mut (),
    ) -> std::result::Result<Self, minicbor::decode::Error> {
        let kid = d.bytes()?;
        if kid.len() != ROLE0_KID_LENGTH {
            return Err(minicbor::decode::Error::message(format!(
                "Kid length must be {ROLE0_KID_LENGTH}"
            )));
        }

        let kid = Self(kid.into());

        Ok(kid)
    }
}

impl Encode<()> for Role0Kid {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, (): &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        e.bytes(self.as_slice())?.ok()
    }
}

impl fmt::Display for Role0Kid {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "Kid: 0x{}", self.0)
    }
}

#[cfg(test)]
mod test_big_uint {

    use super::*;

    /// Check if we can round trip Encode/Decode a `Role0Kid`
    #[test]
    fn test_encode_decode() {
        let dummy_cert: Vec<u8> = vec![
            0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xAA, 0xBB, 0xCC, 0xDD,
            0xEE, 0xFF,
        ];

        let kid = Role0Kid::new(&dummy_cert);

        let mut buffer: Vec<u8> = Vec::new();
        let mut encoder = minicbor::Encoder::new(&mut buffer);

        kid.encode(&mut encoder, &mut ())
            .expect("Should be able to encode");
        assert_eq!(buffer.len(), ROLE0_KID_LENGTH + 1); // Size of the hash plus one byte for cbor encoding.

        let mut decoder = minicbor::Decoder::new(&buffer);
        let decoded_kid =
            Role0Kid::decode(&mut decoder, &mut ()).expect("Failed to decode Role0Kid");

        assert_eq!(kid, decoded_kid);
    }
}
