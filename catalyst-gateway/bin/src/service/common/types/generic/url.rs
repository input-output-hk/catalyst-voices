//! Implementation of `Url` newtype.

use std::str::FromStr;

use derive_more::{From, Into};
use poem_openapi::{types::Example, NewType};

/// URL String
#[derive(Debug, Clone, NewType, From, Into)]
#[oai(example)]
pub(crate) struct Url(url::Url);

impl Example for Url {
    #[allow(clippy::expect_used)]
    fn example() -> Self {
        Self(url::Url::from_str("https://example.com").expect("Invalid URL example"))
    }
}
