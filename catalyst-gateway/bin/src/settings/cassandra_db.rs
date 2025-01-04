//! Command line and environment variable settings for the service

use tracing::info;

use super::str_env_var::StringEnvVar;
use crate::db::{
    self,
    index::session::{CompressionChoice, TlsChoice},
};

/// Default Cassandra DB URL for the Persistent DB.
pub(super) const PERSISTENT_URL_DEFAULT: &str = "172.17.0.2:9042";

/// Default Cassandra DB URL for the Persistent DB.
pub(super) const PERSISTENT_NAMESPACE_DEFAULT: &str = "persistent";

/// Default Cassandra DB URL for the Persistent DB.
pub(super) const VOLATILE_URL_DEFAULT: &str = "172.17.0.2:9042";

/// Default Cassandra DB URL for the Persistent DB.
pub(super) const VOLATILE_NAMESPACE_DEFAULT: &str = "volatile";

/// Default maximum batch size.
/// This comes from:
/// <https://docs.aws.amazon.com/keyspaces/latest/devguide/functional-differences.html#functional-differences.batch>
/// Scylla may support larger batches for better performance.
/// Larger batches will incur more memory overhead to store the prepared batches.
const MAX_BATCH_SIZE_DEFAULT: i64 = 30;

/// Minimum possible batch size.
pub(crate) const MIN_BATCH_SIZE: i64 = 1;

/// Maximum possible batch size.
const MAX_BATCH_SIZE: i64 = 256;

/// Configuration for an individual cassandra cluster.
#[derive(Clone)]
pub(crate) struct EnvVars {
    /// The Address/s of the DB.
    pub(crate) url: StringEnvVar,

    /// The Namespace of Cassandra DB.
    pub(crate) namespace: StringEnvVar,

    /// The `UserName` to use for the Cassandra DB.
    pub(crate) username: Option<StringEnvVar>,

    /// The Password to use for the Cassandra DB..
    pub(crate) password: Option<StringEnvVar>,

    /// Use TLS for the connection?
    pub(crate) tls: TlsChoice,

    /// Use TLS for the connection?
    pub(crate) tls_cert: Option<StringEnvVar>,

    /// Compression to use.
    pub(crate) compression: CompressionChoice,

    /// Maximum Configured Batch size.
    pub(crate) max_batch_size: i64,
}

impl EnvVars {
    /// Create a config for a cassandra cluster, identified by a default namespace.
    pub(super) fn new(url: &str, namespace: &str) -> Self {
        let name = namespace.to_uppercase();

        // We can actually change the namespace, but can't change the name used for env vars.
        let namespace = StringEnvVar::new(&format!("CASSANDRA_{name}_NAMESPACE"), namespace.into());

        let tls =
            StringEnvVar::new_as_enum(&format!("CASSANDRA_{name}_TLS"), TlsChoice::Disabled, false);
        let compression = StringEnvVar::new_as_enum(
            &format!("CASSANDRA_{name}_COMPRESSION"),
            CompressionChoice::Lz4,
            false,
        );

        Self {
            url: StringEnvVar::new(&format!("CASSANDRA_{name}_URL"), url.into()),
            namespace,
            username: StringEnvVar::new_optional(&format!("CASSANDRA_{name}_USERNAME"), false),
            password: StringEnvVar::new_optional(&format!("CASSANDRA_{name}_PASSWORD"), true),
            tls,
            tls_cert: StringEnvVar::new_optional(&format!("CASSANDRA_{name}_TLS_CERT"), false),
            compression,
            max_batch_size: StringEnvVar::new_as(
                &format!("CASSANDRA_{name}_BATCH_SIZE"),
                MAX_BATCH_SIZE_DEFAULT,
                MIN_BATCH_SIZE,
                MAX_BATCH_SIZE,
            ),
        }
    }

    /// Log the configuration of this Cassandra DB
    pub(crate) fn log(&self, persistent: bool) {
        let db_type = if persistent { "Persistent" } else { "Volatile" };

        let auth = match (&self.username, &self.password) {
            (Some(u), Some(_)) => format!("Username: {} Password: REDACTED", u.as_str()),
            _ => "No Authentication".to_string(),
        };

        let tls_cert = match &self.tls_cert {
            None => "No TLS Certificate Defined".to_string(),
            Some(cert) => cert.as_string(),
        };

        info!(
            url = self.url.as_str(),
            namespace = db::index::schema::namespace(self),
            auth = auth,
            tls = self.tls.to_string(),
            cert = tls_cert,
            compression = self.compression.to_string(),
            "Cassandra {db_type} DB Configuration"
        );
    }
}
