//! Retry After type

use chrono::{DateTime, Utc};
use poem_openapi::{types::Example, NewType};

/// Parameter which describes the possible choices for a Retry-After header field.
#[allow(dead_code)] // Its OK if all these variants are not used.
pub(crate) enum RetryAfter {
    /// Http Date
    Date(DateTime<Utc>),
    /// Interval in seconds.
    Seconds(u64),
}

impl RetryAfter {
    /// Consume this value and return the header contents.
    pub(crate) fn to_header(&self) -> RetryAfterHeader {
        match self {
            RetryAfter::Date(date_time) => {
                let date_string = date_time.format("%a, %d %b %Y %T GMT").to_string();
                RetryAfterHeader(date_string)
            },
            RetryAfter::Seconds(secs) => RetryAfterHeader(format!("{secs}")),
        }
    }
}

impl Default for RetryAfter {
    fn default() -> Self {
        RetryAfter::Seconds(300)
    }
}

#[derive(NewType)]
#[oai(example)]
/// Http Date or Interval in seconds.
///
/// Valid formats:
///
/// * `Retry-After: <http-date>`
/// * `Retry-After: <delay-seconds>`
///
/// See: <https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Retry-After>
pub(crate) struct RetryAfterHeader(String);

impl Example for RetryAfterHeader {
    fn example() -> Self {
        RetryAfter::default().to_header()
    }
}
