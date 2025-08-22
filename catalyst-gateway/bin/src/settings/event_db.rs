//! Command line and environment variable settings for the service

use std::time::Duration;

use super::str_env_var::StringEnvVar;

/// Sets the maximum number of connections managed by the pool.
/// Defaults to 100.
const EVENT_DB_MAX_CONNECTIONS: u32 = 100;

/// Sets the maximum lifetime of connections in the pool.
/// Defaults to 30 minutes.
const EVENT_DB_MAX_LIFETIME: Duration = Duration::from_secs(30 * 60);

/// Sets the minimum idle connection count maintained by the pool.
/// Defaults to 0.
const EVENT_DB_MIN_IDLE: u32 = 0;

/// Sets the connection timeout used by the pool.
/// Defaults to 30 seconds.
const EVENT_DB_CONN_TIMEOUT: Duration = Duration::from_secs(30);

/// Default Event DB URL.
const EVENT_DB_URL_DEFAULT: &str =
    "postgresql://postgres:postgres@localhost/catalyst_events?sslmode=disable";

/// Configuration for event db.
#[derive(Clone)]
pub(crate) struct EnvVars {
    /// The Address of the Event DB.
    url: StringEnvVar,

    /// The `UserName` to use for the Event DB.
    username: Option<StringEnvVar>,

    /// The Address of the Event DB.
    password: Option<StringEnvVar>,

    /// Sets the maximum number of connections managed by the pool.
    /// Defaults to 10.
    max_connections: u32,

    /// Sets the maximum lifetime of connections in the pool.
    /// Defaults to 30 minutes.
    max_lifetime: Duration,

    /// Sets the minimum idle connection count maintained by the pool.
    /// Defaults to None.
    min_idle: u32,

    /// Sets the connection timeout used by the pool.
    /// Defaults to 30 seconds.
    connection_timeout: Duration,
}

impl EnvVars {
    /// Create a config for event db.
    pub(super) fn new() -> Self {
        Self {
            url: StringEnvVar::new("EVENT_DB_URL", (EVENT_DB_URL_DEFAULT, true).into()),
            username: StringEnvVar::new_optional("EVENT_DB_USERNAME", false),
            password: StringEnvVar::new_optional("EVENT_DB_PASSWORD", true),
            max_connections: StringEnvVar::new_as_int(
                "EVENT_DB_MAX_CONNECTIONS",
                EVENT_DB_MAX_CONNECTIONS,
                0,
                u32::MAX,
            ),
            max_lifetime: StringEnvVar::new_as_duration(
                "EVENT_DB_MAX_LIFETIME",
                EVENT_DB_MAX_LIFETIME,
            ),
            min_idle: StringEnvVar::new_as_int("EVENT_DB_MIN_IDLE", EVENT_DB_MIN_IDLE, 0, u32::MAX),
            connection_timeout: StringEnvVar::new_as_duration(
                "EVENT_DB_CONN_TIMEOUT",
                EVENT_DB_CONN_TIMEOUT,
            ),
        }
    }

    /// Returns Event DB `url` setting
    pub(crate) fn url(&self) -> &str {
        self.url.as_str()
    }

    /// Returns Event DB `username` setting
    pub(crate) fn username(&self) -> Option<&str> {
        self.username.as_ref().map(StringEnvVar::as_str)
    }

    /// Returns Event DB `password` setting
    pub(crate) fn password(&self) -> Option<&str> {
        self.password.as_ref().map(StringEnvVar::as_str)
    }

    /// Returns Event DB `max_connections` setting
    pub(crate) fn max_connections(&self) -> u32 {
        self.max_connections
    }

    /// Returns Event DB `max_lifetime` setting
    pub(crate) fn max_lifetime(&self) -> Duration {
        self.max_lifetime
    }

    /// Returns Event DB `min_idle` setting
    pub(crate) fn min_idle(&self) -> u32 {
        self.min_idle
    }

    /// Returns Event DB `connection_timeout` setting
    pub(crate) fn connection_timeout(&self) -> Duration {
        self.connection_timeout
    }
}
