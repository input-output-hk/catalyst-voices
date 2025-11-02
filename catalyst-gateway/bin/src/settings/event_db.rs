//! Command line and environment variable settings for the service

use super::str_env_var::StringEnvVar;

/// Sets the maximum number of connections managed by the pool.
/// Defaults to 100.
const EVENT_DB_MAX_CONNECTIONS: u32 = 100;

/// Sets the maximum lifetime of connections in the pool.
/// Defaults to 30 minutes.
const EVENT_DB_MAX_LIFETIME: u32 = 30;

/// Sets the minimum idle connection count maintained by the pool.
/// Defaults to 0.
const EVENT_DB_MIN_IDLE: u32 = 0;

/// Sets the connection timeout used by the pool.
/// Defaults to 300 seconds.
const EVENT_DB_CONN_TIMEOUT: u32 = 300;

/// Default Event DB URL.
const EVENT_DB_URL_DEFAULT: &str =
    "postgresql://postgres:postgres@localhost/catalyst_events?sslmode=disable";

/// Configuration for event db.
#[derive(Clone)]
pub(crate) struct EnvVars {
    /// The Address of the Event DB.
    pub(crate) url: StringEnvVar,

    /// The `UserName` to use for the Event DB.
    pub(crate) username: Option<StringEnvVar>,

    /// The Address of the Event DB.
    pub(crate) password: Option<StringEnvVar>,

    /// Sets the maximum number of connections managed by the pool.
    /// Defaults to 10.
    pub(crate) max_connections: u32,

    /// Sets the maximum lifetime of connections in the pool.
    /// Defaults to 30 minutes.
    pub(crate) max_lifetime: u32,

    /// Sets the minimum idle connection count maintained by the pool.
    /// Defaults to None.
    pub(crate) min_idle: u32,

    /// Sets the connection timeout used by the pool.
    /// Defaults to 30 seconds.
    pub(crate) connection_timeout: u32,
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
            max_lifetime: StringEnvVar::new_as_int(
                "EVENT_DB_MAX_LIFETIME",
                EVENT_DB_MAX_LIFETIME,
                0,
                u32::MAX,
            ),
            min_idle: StringEnvVar::new_as_int("EVENT_DB_MIN_IDLE", EVENT_DB_MIN_IDLE, 0, u32::MAX),
            connection_timeout: StringEnvVar::new_as_int(
                "EVENT_DB_CONN_TIMEOUT",
                EVENT_DB_CONN_TIMEOUT,
                0,
                u32::MAX,
            ),
        }
    }
}
