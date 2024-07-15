//! Session creation and storage

use crate::settings::{CassandraEnvVars, Settings};
use openssl::ssl::{SslContextBuilder, SslFiletype, SslMethod, SslVerifyMode};
use scylla::{frame::Compression, Session, SessionBuilder};
use std::{path::PathBuf, sync::Arc};
use tokio::fs;

use super::schema::{create_schema, SCHEMA_VERSION};

/// Configuration Choices for compression
#[derive(Clone, strum::EnumString)]
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
#[derive(Clone, strum::EnumString, PartialEq)]
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

/// Construct a session based on the given configuration.
async fn make_session(cfg: CassandraEnvVars) -> anyhow::Result<CassandraSession> {
    let cluster_urls: Vec<&str> = cfg.url.as_str().split(',').collect();

    let mut sb = SessionBuilder::new().known_nodes(cluster_urls);

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

    // Build and set the Keyspace to use.
    let keyspace = format!("{}_V{}", cfg.namespace.as_str(), SCHEMA_VERSION);
    sb = sb.use_keyspace(keyspace, false);

    // Set the username and password, if required.
    if let Some(username) = cfg.username {
        if let Some(password) = cfg.password {
            sb = sb.user(username.as_str(), password.as_str());
        }
    }

    let session = Box::pin(sb.build()).await?;

    Ok(Arc::new(session))
}

/// Initialise the Cassandra Cluster Connections.
pub(crate) async fn init() -> anyhow::Result<()> {
    let (persistent, volatile) = Settings::cassandra_db_cfg();

    let persistent_session = make_session(persistent).await?;
    let volatile_session = make_session(volatile).await?;

    create_schema(persistent_session.clone()).await;
    create_schema(volatile_session.clone()).await;

    Ok(())
}
