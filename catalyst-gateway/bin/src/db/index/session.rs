//! Session creation and storage

use std::{
    path::PathBuf,
    sync::{Arc, OnceLock},
    time::Duration,
};

use openssl::ssl::{SslContextBuilder, SslFiletype, SslMethod, SslVerifyMode};
use scylla::{frame::Compression, ExecutionProfile, Session, SessionBuilder};
use tokio::fs;
use tracing::{error, info};

use super::schema::create_schema;
use crate::settings::{CassandraEnvVars, Settings};

/// Configuration Choices for compression
#[derive(Clone, strum::EnumString, strum::Display, strum::VariantNames)]
#[strum(ascii_case_insensitive)]
pub(crate) enum CompressionChoice {
    /// LZ4 link data compression.
    Lz4,
    /// Snappy link data compression.
    Snappy,
    /// No compression.
    None,
}

/// Configuration Choices for TLS.
#[derive(Clone, strum::EnumString, strum::Display, strum::VariantNames, PartialEq)]
#[strum(ascii_case_insensitive)]
pub(crate) enum TlsChoice {
    /// Disable TLS.
    Disabled,
    /// Verifies that the peer's certificate is trusted.
    Verified,
    /// Disables verification of the peer's certificate.
    Unverified,
}

/// A Session on the cassandra database
pub(crate) type CassandraSession = Arc<Session>;

/// Create a new execution profile based on the given configuration.
fn make_execution_profile(_cfg: &CassandraEnvVars) -> ExecutionProfile {
    ExecutionProfile::builder()
        .consistency(scylla::statement::Consistency::LocalQuorum)
        .serial_consistency(Some(scylla::statement::SerialConsistency::LocalSerial))
        .retry_policy(Box::new(scylla::retry_policy::DefaultRetryPolicy::new()))
        .load_balancing_policy(
            scylla::load_balancing::DefaultPolicyBuilder::new()
                .permit_dc_failover(true)
                .build(),
        )
        .speculative_execution_policy(Some(Arc::new(
            scylla::speculative_execution::SimpleSpeculativeExecutionPolicy {
                max_retry_count: 3,
                retry_interval: Duration::from_millis(100),
            },
        )))
        .build()
}

/// Construct a session based on the given configuration.
async fn make_session(cfg: &CassandraEnvVars) -> anyhow::Result<CassandraSession> {
    let cluster_urls: Vec<&str> = cfg.url.as_str().split(',').collect();

    let mut sb = SessionBuilder::new()
        .known_nodes(cluster_urls)
        .auto_await_schema_agreement(false);

    let profile_handle = make_execution_profile(cfg).into_handle();
    sb = sb.default_execution_profile_handle(profile_handle);

    sb = match cfg.compression {
        CompressionChoice::Lz4 => sb.compression(Some(Compression::Lz4)),
        CompressionChoice::Snappy => sb.compression(Some(Compression::Snappy)),
        CompressionChoice::None => sb.compression(None),
    };

    if cfg.tls != TlsChoice::Disabled {
        let mut context_builder = SslContextBuilder::new(SslMethod::tls())?;

        if let Some(cert_name) = &cfg.tls_cert {
            let certdir = fs::canonicalize(PathBuf::from(cert_name.as_str())).await?;
            context_builder.set_certificate_file(certdir.as_path(), SslFiletype::PEM)?;
        }

        if cfg.tls == TlsChoice::Verified {
            context_builder.set_verify(SslVerifyMode::PEER);
        } else {
            context_builder.set_verify(SslVerifyMode::NONE);
        }

        let ssl_context = context_builder.build();

        sb = sb.ssl_context(Some(ssl_context));
    }

    // Set the username and password, if required.
    if let Some(username) = &cfg.username {
        if let Some(password) = &cfg.password {
            sb = sb.user(username.as_str(), password.as_str());
        }
    }

    let session = Box::pin(sb.build()).await?;

    Ok(Arc::new(session))
}

/// Persistent DB Session.
static PERSISTENT_SESSION: OnceLock<CassandraSession> = OnceLock::new();
/// Volatile DB Session.
static VOLATILE_SESSION: OnceLock<CassandraSession> = OnceLock::new();

/// Continuously try and init the DB, if it fails, backoff.
///
/// Display reasonable logs to help diagnose DB connection issues.
async fn retry_init(cfg: CassandraEnvVars, persistent: bool) {
    let mut retry_delay = Duration::from_secs(0);
    let db_type = if persistent { "Persistent" } else { "Volatile" };

    info!(db_type = db_type, "Index DB Session Creation: Started.");

    cfg.log(persistent);

    loop {
        tokio::time::sleep(retry_delay).await;
        retry_delay = Duration::from_secs(30); // 30 seconds if we every try again.

        info!(
            db_type = db_type,
            "Attempting to connect to Cassandra DB..."
        );

        // Create a Session to the Cassandra DB.
        let session = match make_session(&cfg).await {
            Ok(session) => session,
            Err(error) => {
                let error = format!("{error:?}");
                error!(
                    db_type = db_type,
                    error = error,
                    "Failed to Create Cassandra DB Session"
                );
                continue;
            },
        };

        // Set up the Schema for it.
        if let Err(error) = create_schema(&mut session.clone(), &cfg, persistent).await {
            let error = format!("{error:?}");
            error!(
                db_type = db_type,
                error = error,
                "Failed to Create Cassandra DB Schema"
            );
        }

        // Save the session so we can execute queries on the DB
        if persistent {
            if PERSISTENT_SESSION.set(session).is_err() {
                error!("Persistent Session already set.  This should not happen.");
            };
        } else if VOLATILE_SESSION.set(session).is_err() {
            error!("Volatile Session already set.  This should not happen.");
        };

        // IF we get here, then everything seems to have worked, so finish init.
        break;
    }

    info!(db_type = db_type, "Index DB Session Creation: OK.");
}

/// Initialise the Cassandra Cluster Connections.
pub(crate) fn init() {
    let (persistent, volatile) = Settings::cassandra_db_cfg();

    let _join_handle = tokio::task::spawn(async move { retry_init(persistent, true).await });
    let _join_handle = tokio::task::spawn(async move { retry_init(volatile, false).await });
}

/// Check to see if the Cassandra Indexing DB is ready for use
pub(crate) fn is_ready() -> bool {
    PERSISTENT_SESSION.get().is_some() && VOLATILE_SESSION.get().is_some()
}
