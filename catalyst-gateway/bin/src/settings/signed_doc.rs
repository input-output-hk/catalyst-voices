//! Command line and environment variable settings for the Catalyst Signed Docs

use std::time::Duration;

use super::str_env_var::StringEnvVar;

/// Default number value of `future_threshold`, 30 seconds.
const DEFAULT_FUTURE_THRESHOLD: Duration = Duration::from_secs(30);

/// Default number value of `future_threshold`, 10 minutes.
const DEFAULT_PAST_THRESHOLD: Duration = Duration::from_secs(60 * 10);

/// Configuration for the Catalyst Signed Documents validation configuration.
#[derive(Clone)]
pub(crate) struct EnvVars {
    /// The Catalyst Signed Document threshold, document cannot be too far in the future.
    future_threshold: Duration,

    /// The Catalyst Signed Document threshold, document cannot be too far behind.
    past_threshold: Duration,
}

impl EnvVars {
    /// Create a config for Catalyst Signed Document validation configuration.
    pub(super) fn new() -> Self {
        let future_threshold =
            StringEnvVar::new_as_duration("SIGNED_DOC_FUTURE_THRESHOLD", DEFAULT_FUTURE_THRESHOLD);

        let past_threshold =
            StringEnvVar::new_as_duration("SIGNED_DOC_PAST_THRESHOLD", DEFAULT_PAST_THRESHOLD);

        Self {
            future_threshold,
            past_threshold,
        }
    }

    /// The Catalyst Signed Document threshold, document cannot be too far in the future
    /// (in seconds).
    pub(crate) fn future_threshold(&self) -> Duration {
        self.future_threshold
    }

    /// The Catalyst Signed Document threshold, document cannot be too far behind
    /// (in seconds).
    pub(crate) fn past_threshold(&self) -> Duration {
        self.past_threshold
    }
}
