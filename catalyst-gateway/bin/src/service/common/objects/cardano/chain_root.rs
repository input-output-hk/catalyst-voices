//! Implement newtype for chain root.

use core::fmt;
use std::str::FromStr;

use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseFromParameter, ParseResult, Type},
};

/// Newtype for chain root.
#[derive(Debug, Clone)]
pub(crate) struct ChainRoot(Vec<u8>);

impl Type for ChainRoot {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "chain_root".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        MetaSchemaRef::Inline(Box::new(MetaSchema::new_with_format("string", ""))).merge(
            MetaSchema {
                title: Some("Chain Root".into()),
                description: Some("Chain root in the hash format with leading 0x."),
                example: Some(Self::example().to_string().into()),
                max_length: Some(66),
                min_length: Some(66),
                pattern: Some("^0x[0-9a-f]{64}$".into()),
                ..poem_openapi::registry::MetaSchema::ANY
            },
        )
    }

    fn as_raw_value(&self) -> Option<&Self::RawValueType> {
        Some(self)
    }

    fn raw_element_iter<'a>(
        &'a self,
    ) -> Box<dyn Iterator<Item = &'a Self::RawElementValueType> + 'a> {
        Box::new(self.as_raw_value().into_iter())
    }
}

impl FromStr for ChainRoot {
    type Err = anyhow::Error;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let hex_str = s.strip_prefix("0x").unwrap_or(s);

        if hex_str.len() != 64 {
            return Err(anyhow::anyhow!("Invalid chain root length"));
        }

        let bytes = hex_str
            .as_bytes()
            .chunks(2)
            .map(|chunk| {
                let hex_pair =
                    std::str::from_utf8(chunk).map_err(|_| anyhow::anyhow!("Invalid hex string length"))?;
                u8::from_str_radix(hex_pair, 16).map_err(|e| anyhow::anyhow!(e))
            })
            .collect::<Result<Vec<u8>, _>>()?;

        Ok(Self(bytes))
    }
}

impl fmt::Display for ChainRoot {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str("0x")?;
        for byte in &self.0 {
            write!(f, "{byte:02x}")?;
        }
        Ok(())
    }
}

impl ParseFromParameter for ChainRoot {
    fn parse_from_parameter(value: &str) -> ParseResult<Self> {
        Ok(Self::from_str(value)?)
    }
}

impl Example for ChainRoot {
    fn example() -> Self {
        // 0xff561c1ce6becf136a5d3063f50d78b8db50b8a1d4c03b18d41a8e98a6a18aed
        Self(vec![
            255, 86, 28, 28, 230, 190, 207, 19, 106, 93, 48, 99, 245, 13, 120, 184, 219, 80, 184,
            161, 212, 192, 59, 24, 212, 26, 142, 152, 166, 161, 138, 237,
        ])
    }
}
