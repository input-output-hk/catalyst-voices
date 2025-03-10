//! Frontend configuration objects.

use derive_more::{From, Into};
use poem_openapi::{types::Example, NewType, Object};

use super::{environment::ConfigEnvironment, version::SemVer};
use crate::service::common;

/// Frontend JSON schema.
#[derive(Object, Default)]
#[oai(example = true)]
pub(crate) struct FrontendConfig {
    /// Sentry properties.
    sentry: Option<ConfiguredSentry>,
}

impl Example for FrontendConfig {
    fn example() -> Self {
        Self {
            sentry: Some(Example::example()),
        }
    }
}

/// Configured sentry using in `FrontendConfig`.
#[derive(NewType, From, Into)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
pub(crate) struct ConfiguredSentry(Sentry);

impl Example for ConfiguredSentry {
    fn example() -> Self {
        Self(Example::example())
    }
}

/// Frontend configuration for Sentry.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct Sentry {
    /// The Data Source Name (DSN) for Sentry.
    dsn: common::types::generic::url::Url,
    /// A version of the code deployed to an environment.
    release: Option<SemVer>,
    /// The environment in which the application is running, e.g., 'dev', 'qa'.
    environment: Option<SentryConfiguredProfile>,
}

impl Example for Sentry {
    fn example() -> Self {
        Self {
            dsn: Example::example(),
            release: Some(Example::example()),
            environment: Some(Example::example()),
        }
    }
}

/// Configured sentry profile.
#[derive(NewType, From, Into)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
pub(crate) struct SentryConfiguredProfile(ConfigEnvironment);

impl Example for SentryConfiguredProfile {
    fn example() -> Self {
        Self(Example::example())
    }
}
