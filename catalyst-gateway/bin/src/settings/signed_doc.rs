//! Command line and environment variable settings for the Catalyst Signed Docs

use std::{collections::HashMap, str::FromStr, time::Duration};

use hex::FromHex;
use itertools::Itertools;

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

    /// The Catalyst Signed Document Admin keys map from the `SIGNED_DOC_ADMIN_KEYS` env
    /// var. Each Admin key entry is a pair of `CatalystId` string and hex encoded
    /// `VerifyingKey` separated by ';' character.
    admin_keys: HashMap<catalyst_signed_doc::CatalystId, ed25519_dalek::VerifyingKey>,
}

impl EnvVars {
    /// Create a config for Catalyst Signed Document validation configuration.
    pub(super) fn new() -> Self {
        let future_threshold =
            StringEnvVar::new_as_duration("SIGNED_DOC_FUTURE_THRESHOLD", DEFAULT_FUTURE_THRESHOLD);

        let past_threshold =
            StringEnvVar::new_as_duration("SIGNED_DOC_PAST_THRESHOLD", DEFAULT_PAST_THRESHOLD);

        let admin_keys = string_to_admin_keys(
            &StringEnvVar::new_optional("SIGNED_DOC_ADMIN_KEYS", false)
                .map(|v| v.as_string())
                .unwrap_or_default(),
        );

        Self {
            future_threshold,
            past_threshold,
            admin_keys,
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

    /// The Catalyst Signed Document Admin keys map.
    pub(crate) fn admin_keys(
        &self
    ) -> &HashMap<catalyst_signed_doc::CatalystId, ed25519_dalek::VerifyingKey> {
        &self.admin_keys
    }
}

/// Transform a string list of admin keys into a map.
/// Each Admin key entry is a pair of `CatalystId` string and hex encoded
/// `VerifyingKey` separated by ';' character.
fn string_to_admin_keys(
    admin_keys: &str
) -> HashMap<catalyst_signed_doc::CatalystId, ed25519_dalek::VerifyingKey> {
    admin_keys
        .split(',')
        // filters out at the beginning all empty entries, because they all would be invalid and
        // filtered out anyway
        .filter(|s| !s.is_empty())
        .filter_map(|s| {
            // split `CatalystId` and `VerifyingKey` by `;` character.
            let Some((id, key)) = s.split(';').collect_tuple() else {
                tracing::error!(entry = s, "Invalid admin key entry");
                return None;
            };

            let id = catalyst_signed_doc::CatalystId::from_str(id)
                .inspect_err(|err| {
                    tracing::error!(
                        err = ?err,
                        "Cannot parse Admin CatalystId entry, skipping the value..."
                    );
                })
                .ok()?;

            // Strip the prefix and convert to 32 bytes array
            let key = key
                .strip_prefix("0x")
                .ok_or(anyhow::anyhow!(
                    "Admin key hex value does not start with '0x'"
                ))
                .and_then(|s| Ok(Vec::from_hex(s)?))
                .and_then(|bytes| Ok(bytes.as_slice().try_into()?))
                .inspect_err(|err| {
                    tracing::error!(
                        err = ?err,
                        "Cannot parse Admin VerifyingKey entry, skipping the value..."
                    );
                })
                .ok()?;
            Some((id, key))
        })
        .collect()
}
