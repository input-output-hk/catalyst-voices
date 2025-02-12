//! Query Parameter that can take either a Blockchain slot Number or Unix Epoch timestamp.
//!
//! Allows better specifying of times that restrict a GET endpoints response.

//! Hex encoded 28 byte hash.
//!
//! Hex encoded string which represents a 28 byte hash.

use std::{
    cmp::{max, min},
    fmt::{self, Display},
    sync::LazyLock,
};

use anyhow::{bail, Result};
use chrono::DateTime;
use const_format::concatcp;
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{ParseError, ParseFromParameter, ParseResult, Type},
};
use regex::Regex;
use serde_json::Value;

use crate::{service::common::types::cardano::slot_no::SlotNo, settings::Settings};

/// Title.
const TITLE: &str = "As At this Time OR Slot.";
/// Description.
const DESCRIPTION: &str = "Restrict the query to this time.
Time can be represented as either the blockchains slot number, 
or the number of seconds since midnight 1970, UTC.

If this parameter is not defined, the query will retrieve data up to the current time.";
/// Example whence.
const EXAMPLE_WHENCE: &str = TIME_DISCRIMINATOR;
/// Example time.
const EXAMPLE_TIME: u64 = 1_730_861_339; // Date and time (UTC): November 6, 2024 2:48:59 AM
/// Example
static EXAMPLE: LazyLock<String> = LazyLock::new(|| {
    // Note, the SlotNumber here is wrong, but its not used for generating the example, so
    // thats OK.
    let example = AsAt((EXAMPLE_WHENCE.to_owned(), EXAMPLE_TIME, SlotNo::default()));
    format!("{example}")
});
/// Time Discriminator
const TIME_DISCRIMINATOR: &str = "TIME";
/// Slot Discriminator
const SLOT_DISCRIMINATOR: &str = "SLOT";
/// Validation Regex Pattern
const PATTERN: &str = concatcp!(
    "^(",
    SLOT_DISCRIMINATOR,
    "|",
    TIME_DISCRIMINATOR,
    r"):(\d{1,20})$"
);
/// Minimum parameter length
static MIN_LENGTH: LazyLock<usize> =
    LazyLock::new(|| min(TIME_DISCRIMINATOR.len(), SLOT_DISCRIMINATOR.len()) + ":0".len());
/// Maximum parameter length
static MAX_LENGTH: LazyLock<usize> = LazyLock::new(|| {
    max(TIME_DISCRIMINATOR.len(), SLOT_DISCRIMINATOR.len()) + ":".len() + u64::MAX.to_string().len()
});

/// Parse the `AsAt` parameter from the Query string provided.
fn parse_parameter(param: &str) -> Result<(String, u64)> {
    /// Regex to parse the parameter
    #[allow(clippy::unwrap_used)] // Safe because the Regex is constant.  Can never panic in prod.
    static RE: LazyLock<Regex> = LazyLock::new(|| Regex::new(PATTERN).unwrap());

    let Some(results) = RE.captures(param) else {
        bail!("Not a valid `as_at` parameter.");
    };
    let whence = &results[1];
    let Ok(when) = results[2].parse::<u64>() else {
        bail!(
            "Not a valid `as_at` parameter. Invalid {} specified.",
            whence
        );
    };
    Ok((whence.to_owned(), when))
}

/// Schema.
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some(TITLE.to_owned()),
        description: Some(DESCRIPTION),
        example: Some(Value::String(EXAMPLE.to_string())),
        max_length: Some(*MAX_LENGTH),
        min_length: Some(*MIN_LENGTH),
        pattern: Some(PATTERN.to_string()),
        ..poem_openapi::registry::MetaSchema::ANY
    }
});

/// As at time from query string parameter.
/// Store (Whence, When and decoded `SlotNo`) in a tuple for easier access.
#[derive(Debug, Eq, PartialEq, Hash)]
pub(crate) struct AsAt((String, u64, SlotNo));

impl Type for AsAt {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "string(slot or time)".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        let schema_ref = MetaSchemaRef::Inline(Box::new(MetaSchema::new_with_format(
            "string",
            "slot or time",
        )));
        schema_ref.merge(SCHEMA.clone())
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

impl ParseFromParameter for AsAt {
    fn parse_from_parameter(value: &str) -> ParseResult<Self> {
        let (whence, when) = parse_parameter(value)?;
        let slot = if whence == TIME_DISCRIMINATOR {
            let network = Settings::cardano_network();
            let Ok(epoch_time) = when.try_into() else {
                return Err(ParseError::from(format!(
                    "time {when} too far in the future"
                )));
            };
            let Some(datetime) = DateTime::from_timestamp(epoch_time, 0) else {
                return Err(ParseError::from(format!("invalid time {when}")));
            };
            let Some(slot) = network.time_to_slot(datetime) else {
                return Err(ParseError::from(format!(
                    "invalid time {when} for network: {network}"
                )));
            };
            slot
        } else {
            when
        };
        let slot_no: SlotNo = slot.try_into().map_err(ParseError::from)?;
        Ok(Self((whence, when, slot_no)))
    }
}

impl From<AsAt> for SlotNo {
    fn from(value: AsAt) -> Self {
        value.0 .2
    }
}

impl Display for AsAt {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}:{}", self.0 .0, self.0 .1)
    }
}

#[cfg(test)]
mod tests {
    use super::parse_parameter;

    #[test]
    fn test_string_to_slot_no() {
        let slot_no = "SLOT:12396302";
        assert!(parse_parameter(slot_no).is_ok());

        let unix_timestamp = "TIME:1736164751";
        assert!(parse_parameter(unix_timestamp).is_ok());
    }
}
