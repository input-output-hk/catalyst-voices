//! Command line and environment variable settings for the Catalyst Signed Docs

use std::{str::FromStr, time::Duration};

use super::str_env_var::StringEnvVar;

/// Default number value of `future_threshold`, 30 seconds.
const DEFAULT_FUTURE_THRESHOLD: Duration = Duration::from_secs(30);

/// Default number value of `past_threshold`, 10 minutes.
const DEFAULT_PAST_THRESHOLD: Duration = Duration::from_secs(60 * 10);

/// Configuration for the Catalyst Signed Documents validation.
#[derive(Clone)]
pub(crate) struct EnvVars {
    /// The Catalyst Signed Document threshold, document cannot be too far in the future.
    future_threshold: Duration,

    /// The Catalyst Signed Document threshold, document cannot be too far behind.
    past_threshold: Duration,

    /// The Catalyst Signed Document Admin Catalyst ID from the `SIGNED_DOC_ADMIN_KEYS`
    /// env.
    admin_key: catalyst_signed_doc::CatalystId,
}

impl EnvVars {
    /// Create a config for Catalyst Signed Document validation configuration.
    pub(super) fn new() -> Self {
        let future_threshold =
            StringEnvVar::new_as_duration("SIGNED_DOC_FUTURE_THRESHOLD", DEFAULT_FUTURE_THRESHOLD);

        let past_threshold =
            StringEnvVar::new_as_duration("SIGNED_DOC_PAST_THRESHOLD", DEFAULT_PAST_THRESHOLD);

        let Some(admin_key) = string_to_catalyst_id(
            &StringEnvVar::new_optional("SIGNED_DOC_ADMIN_KEYS", false)
                .map(|v| v.as_string())
                .unwrap_or_default(),
        ) else {
            panic!("Missing or invalid Catalyst ID for Admin. This is required.");
        };

        Self {
            future_threshold,
            past_threshold,
            admin_key,
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

    /// The Catalyst Signed Document Admin key.
    #[allow(dead_code)]
    pub(crate) fn admin_key(&self) -> &catalyst_signed_doc::CatalystId {
        &self.admin_key
    }
}

/// Convert an Envvar into the Catalyst ID type, `None` if missing or invalid value.
fn string_to_catalyst_id(s: &str) -> Option<catalyst_signed_doc::CatalystId> {
    catalyst_signed_doc::CatalystId::from_str(s)
        .inspect_err(|err| {
            tracing::error!(
                err = ?err,
                "Cannot parse Admin CatalystId entry"
            );
        })
        .ok()
}
