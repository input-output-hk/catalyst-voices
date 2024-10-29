//! Frontend configuration objects.

use poem_openapi::{types::Example, Object};

/// Frontend JSON schema.
#[derive(Object, Default, serde::Deserialize)]
#[oai(example = true)]
pub(crate) struct FrontendConfig {
    /// Sentry properties.
    sentry: Option<Sentry>,
}

impl Example for FrontendConfig {
    fn example() -> Self {
        FrontendConfig {
            sentry: Some(Sentry::example()),
        }
    }
}

/// Frontend configuration for Sentry.
#[derive(Object, Default, serde::Deserialize)]
#[oai(example = true)]
pub(crate) struct Sentry {
    /// The Data Source Name (DSN) for Sentry.
    #[oai(validator(max_length = "100", pattern = "^https?://"))]
    dsn: String,
    /// A version of the code deployed to an environment.
    #[oai(validator(max_length = "100", pattern = "^[0-9a-zA-Z].*$"))]
    release: Option<String>,
    /// The environment in which the application is running, e.g., 'dev', 'qa'.
    #[oai(validator(max_length = "100", pattern = "^[0-9a-zA-Z].*$"))]
    environment: Option<String>,
}

impl Example for Sentry {
    fn example() -> Self {
        Sentry {
            dsn: "https://example.com".to_string(),
            release: Some("1.0.0".to_string()),
            environment: Some("dev".to_string()),
        }
    }
}
