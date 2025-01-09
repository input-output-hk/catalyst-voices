//! Retry After header type
//!
//! This is an active header which expects to be provided in a response.

use std::{borrow::Cow, fmt::Display};

use chrono::{DateTime, Utc};
use poem::http::HeaderValue;
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{ToHeader, Type},
};
use serde_json::Value;

/// Parameter which describes the possible choices for a Retry-After header field.
#[derive(Debug)]
#[allow(dead_code)] // Its OK if all these variants are not used.
pub(crate) enum RetryAfterHeader {
    /// Http Date
    Date(DateTime<Utc>),
    /// Interval in seconds.
    Seconds(u64),
}

/// Parameter which lets us set the retry header, or use some default.
/// Needed, because its valid to exclude the retry header specifically.
/// This is also due to the way Poem handles optional headers.
#[derive(Debug)]
#[allow(dead_code)] // Its OK if all these variants are not used.
pub(crate) enum RetryAfterOption {
    /// Use a default Retry After header value
    Default,
    /// Don't include the Retry After header value in the response.
    None,
    /// Use a specific Retry After header value
    Some(RetryAfterHeader),
}

impl From<RetryAfterOption> for Option<RetryAfterHeader> {
    fn from(value: RetryAfterOption) -> Self {
        match value {
            RetryAfterOption::Default => Some(RetryAfterHeader::default()),
            RetryAfterOption::None => None,
            RetryAfterOption::Some(value) => Some(value),
        }
    }
}

impl Display for RetryAfterHeader {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            RetryAfterHeader::Date(date_time) => {
                let http_date = date_time.format("%a, %d %b %Y %T GMT").to_string();
                write!(f, "{http_date}")
            },
            RetryAfterHeader::Seconds(secs) => write!(f, "{secs}"),
        }
    }
}

impl Default for RetryAfterHeader {
    fn default() -> Self {
        Self::Seconds(300)
    }
}

impl Type for RetryAfterHeader {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> Cow<'static, str> {
        "string(http-date || integer)".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        MetaSchemaRef::Inline(Box::new(MetaSchema::new_with_format(
            "string",
            "http-date || integer",
        )))
        .merge(MetaSchema {
            title: Some("Retry-After Header".to_owned()),
            description: Some(
                "Http Date or Interval in seconds.
Valid formats:

* `Retry-After: <http-date>`
* `Retry-After: <delay-seconds>`

See: <https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Retry-After>",
            ),
            example: Some(Value::String("300".to_string())),
            ..poem_openapi::registry::MetaSchema::ANY
        })
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

impl ToHeader for RetryAfterHeader {
    fn to_header(&self) -> Option<HeaderValue> {
        HeaderValue::from_str(&self.to_string()).ok()
    }
}
