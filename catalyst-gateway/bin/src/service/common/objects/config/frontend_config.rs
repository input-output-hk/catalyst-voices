//! Frontend configuration objects.

use poem_openapi::{types::Example, Object};

use super::{environment::ConfigEnvironment, version::SemVer};
use crate::service::common;

/// Frontend JSON schema.
#[derive(Object, Default)]
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
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct Sentry {
    /// The Data Source Name (DSN) for Sentry.
    dsn: common::types::generic::url::Url,
    /// A version of the code deployed to an environment.
    release: Option<SemVer>,
    /// The environment in which the application is running, e.g., 'dev', 'qa'.
    environment: Option<ConfigEnvironment>,
}

impl Example for Sentry {
    fn example() -> Self {
        Sentry {
            dsn: common::types::generic::url::Url::example(),
            release: Some(SemVer::example()),
            environment: Some(ConfigEnvironment::example()),
        }
    }
}
