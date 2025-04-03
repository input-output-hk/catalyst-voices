//! Command line and environment variable settings for the Catalyst Signed Docs

use super::str_env_var::StringEnvVar;

/// Default number value of `future_threshold`, 30 seconds.
const DEFAULT_FUTURE_THRESHOLD: u64 = 30;

/// Default number value of `future_threshold`, 10 minutes.
const DEFAULT_PAST_THRESHOLD: u64 = 10 * 60;

/// Configuration for the Catalyst Signed Documents validation configuration.
#[derive(Clone)]
pub(crate) struct EnvVars {
    /// The Catalyst Signed Document threshold, document cannot be too far in the future
    /// (in seconds).
    future_threshold: u64,

    /// The Catalyst Signed Document threshold, document cannot be too far behind
    /// (in seconds).
    past_threshold: u64,
}

impl EnvVars {
    /// Create a config for Catalyst Signed Document validation configuration.
    pub(super) fn new() -> Self {
        let future_threshold: u64 = StringEnvVar::new_as_int(
            "SIGNED_DOC_FUTURE_THRESHOLD",
            DEFAULT_FUTURE_THRESHOLD,
            0,
            u64::MAX,
        );

        let past_threshold: u64 = StringEnvVar::new_as_int(
            "SIGNED_DOC_PAST_THRESHOLD",
            DEFAULT_PAST_THRESHOLD,
            0,
            u64::MAX,
        );

        Self {
            future_threshold,
            past_threshold,
        }
    }

    /// The Catalyst Signed Document threshold, document cannot be too far in the future
    /// (in seconds).
    pub(crate) fn future_threshold(&self) -> u64 {
        self.future_threshold
    }

    /// The Catalyst Signed Document threshold, document cannot be too far behind
    /// (in seconds).
    pub(crate) fn past_threshold(&self) -> u64 {
        self.past_threshold
    }
}
