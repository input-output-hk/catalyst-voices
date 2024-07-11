//! C509 Unwrapped CBOR Unsigned Bignum

// cspell: words Bignum bignum

use minicbor::{encode::Write, Decode, Decoder, Encode, Encoder};

/// A struct representing an unwrapped CBOR unsigned bignum.
#[derive(Debug, Clone, PartialEq)]
pub struct UnwrappedBigUint(u64);

impl UnwrappedBigUint {
    /// Create a new instance of `UnwrappedBigUint`.
    #[must_use]
    pub fn new(uint: u64) -> Self {
        Self(uint)
    }
}

impl Encode<()> for UnwrappedBigUint {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, _ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        let bytes = self.0.to_be_bytes();
        // Trim leading zeros
        let significant_bytes = bytes
            .iter()
            .skip_while(|&&b| b == 0)
            .copied()
            .collect::<Vec<u8>>();

        e.bytes(&significant_bytes)?;
        Ok(())
    }
}

impl Decode<'_, ()> for UnwrappedBigUint {
    fn decode(d: &mut Decoder<'_>, _ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
        let bytes = d.bytes()?;
        // Turn bytes into u64
        let b = bytes.iter().fold(0, |acc, &b| (acc << 8) | u64::from(b));
        Ok(UnwrappedBigUint::new(b))
    }
}

#[cfg(test)]
mod test_big_uint {

    use super::*;

    // Test reference https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/
    // A.1.  Example RFC 7925 profiled X.509 Certificate
    #[test]
    fn test_encode_decode() {
        let mut buffer = Vec::new();
        let mut encoder = minicbor::Encoder::new(&mut buffer);
        let b_uint = UnwrappedBigUint::new(128_269);
        b_uint
            .encode(&mut encoder, &mut ())
            .expect("Failed to encode UnwrappedBigUint");
        assert_eq!(hex::encode(buffer.clone()), "4301f50d");

        let mut decoder = minicbor::Decoder::new(&buffer);
        let decoded_b_uint = UnwrappedBigUint::decode(&mut decoder, &mut ())
            .expect("Failed to decode UnwrappedBigUint");

        assert_eq!(decoded_b_uint, b_uint);
    }

    // Test reference https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/
    // A.2.  Example IEEE 802.1AR profiled X.509 Certificate
    #[test]
    fn test_encode_decode_2() {
        let mut buffer = Vec::new();
        let mut encoder = minicbor::Encoder::new(&mut buffer);
        let b_uint = UnwrappedBigUint::new(9_112_578_475_118_446_130);
        b_uint
            .encode(&mut encoder, &mut ())
            .expect("Failed to encode UnwrappedBigUint");
        assert_eq!(hex::encode(buffer.clone()), "487e7661d7b54e4632");

        let mut decoder = minicbor::Decoder::new(&buffer);
        let decoded_b_uint = UnwrappedBigUint::decode(&mut decoder, &mut ())
            .expect("Failed to decode UnwrappedBigUint");

        assert_eq!(decoded_b_uint, b_uint);
    }
}
