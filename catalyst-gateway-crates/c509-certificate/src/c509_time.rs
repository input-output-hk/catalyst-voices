//! C509 Time

use minicbor::{encode::Write, Decode, Decoder, Encode, Encoder};
use serde::{Deserialize, Serialize};

/// A struct representing a time where it accept seconds since the Unix epoch.
#[derive(Debug, Clone, PartialEq, Deserialize, Serialize)]
pub struct Time(i64);

/// No expiration date in seconds since the Unix epoch.
const NO_EXP_DATE: i64 = 253_402_300_799;

impl Time {
    /// Create a new instance of `Time`.
    #[must_use]
    pub fn new(time: i64) -> Self {
        Self(time)
    }

    /// Get the time in i64.
    #[must_use]
    pub fn to_i64(&self) -> i64 {
        self.0
    }
}

impl Encode<()> for Time {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, _ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        if self.0 == NO_EXP_DATE {
            e.null()?;
        } else {
            e.i64(self.0)?;
        }
        Ok(())
    }
}

impl Decode<'_, ()> for Time {
    fn decode(d: &mut Decoder<'_>, _ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
        match d.datatype()? {
            minicbor::data::Type::U8
            | minicbor::data::Type::I8
            | minicbor::data::Type::U16
            | minicbor::data::Type::I16
            | minicbor::data::Type::U32
            | minicbor::data::Type::I32
            | minicbor::data::Type::U64
            | minicbor::data::Type::I64 => {
                let time = d.i64()?;
                Ok(Time::new(time))
            },
            minicbor::data::Type::Null => {
                d.null()?;
                Ok(Time::new(NO_EXP_DATE))
            },
            _ => Err(minicbor::decode::Error::message("Invalid type for Time")),
        }
    }
}

#[cfg(test)]
mod test_time {

    use super::*;

    #[test]
    fn test_encode_decode_no_exp_date() {
        let mut buffer = Vec::new();
        let mut encoder = minicbor::Encoder::new(&mut buffer);
        let time = Time::new(NO_EXP_DATE);
        time.encode(&mut encoder, &mut ())
            .expect("Failed to encode Time");
        // null: 0xf6
        assert_eq!(hex::encode(buffer.clone()), "f6");

        let mut decoder = minicbor::Decoder::new(&buffer);
        let decoded_time = Time::decode(&mut decoder, &mut ()).expect("Failed to decode Time");

        assert_eq!(decoded_time, time);
    }

    // Test reference https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/
    // A.1.  Example RFC 7925 profiled X.509 Certificate
    #[test]
    fn test_encode_decode() {
        let mut buffer = Vec::new();
        let mut encoder = minicbor::Encoder::new(&mut buffer);
        // Jan 1 00:00:00 2023 GMT
        let time = Time::new(1_672_531_200);
        time.encode(&mut encoder, &mut ())
            .expect("Failed to encode Time");
        assert_eq!(hex::encode(buffer.clone()), "1a63b0cd00");

        let mut decoder = minicbor::Decoder::new(&buffer);
        let decoded_time = Time::decode(&mut decoder, &mut ()).expect("Failed to decode Time");

        assert_eq!(decoded_time, time);
    }
}
