//! Command line and environment variable settings for the service

use std::time::Duration;

use super::str_env_var::StringEnvVar;

/// Default the maximum number of connections managed by the pool.
const EVENT_DB_MAX_CONNECTIONS_DEFAULT: u32 = 100;

/// Default the timeout when creating a new connection.
const EVENT_DB_CONN_TIMEOUT_DEFAULT: Duration = Duration::from_secs(5);

/// Default the timeout for waiting for a slot to become available.
const EVENT_DB_SLOT_WAIT_TIMEOUT_DEFAULT: Duration = Duration::from_secs(5);

/// Default the timeout when for recycling a connection.
const EVENT_DB_CONN_RECYCLE_TIMEOUT_DEFAULT: Duration = Duration::from_secs(5);

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

    /// Sets the timeout when creating a new connection.
    /// Defaults to 5 seconds.
    connection_creation_timeout: Duration,

    /// Sets the timeout for waiting for a slot to become available.
    /// Defaults to 5 seconds.
    slot_wait_timeout: Duration,

    /// Sets the timeout when for recycling a connection.
    /// Defaults to 5 seconds.
    connection_recycle_timeout: Duration,
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
                EVENT_DB_MAX_CONNECTIONS_DEFAULT,
                0,
                u32::MAX,
            ),
            connection_creation_timeout: StringEnvVar::new_as_duration(
                "EVENT_DB_CONN_TIMEOUT",
                EVENT_DB_CONN_TIMEOUT_DEFAULT,
            ),
            slot_wait_timeout: StringEnvVar::new_as_duration(
                "EVENT_DB_SLOT_WAIT_TIMEOUT",
                EVENT_DB_SLOT_WAIT_TIMEOUT_DEFAULT,
            ),
            connection_recycle_timeout: StringEnvVar::new_as_duration(
                "EVENT_DB_CONN_RECYCLE_TIMEOUT",
                EVENT_DB_CONN_RECYCLE_TIMEOUT_DEFAULT,
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

    /// Returns Event DB `connection_creation_timeout` setting
    pub(crate) fn connection_creation_timeout(&self) -> Duration {
        self.connection_creation_timeout
    }

    /// Returns Event DB `slot_wait_timeout` setting
    pub(crate) fn slot_wait_timeout(&self) -> Duration {
        self.slot_wait_timeout
    }

    /// Returns Event DB `connection_recycle_timeout` setting
    pub(crate) fn connection_recycle_timeout(&self) -> Duration {
        self.connection_recycle_timeout
    }
}
