//! Session creation and storage

use std::{
    fmt::Debug,
    path::PathBuf,
    sync::{Arc, OnceLock},
    time::Duration,
};

use cardano_blockchain_types::Network;
use openssl::ssl::{SslContextBuilder, SslFiletype, SslMethod, SslVerifyMode};
use scylla::{
    client::{
        execution_profile::ExecutionProfile, pager::QueryPager, session::Session,
        session_builder::SessionBuilder,
    },
    frame::Compression,
    serialize::row::SerializeRow,
};
use thiserror::Error;
use tokio::fs;
use tracing::{debug, error, info};

use super::{
    queries::{
        purge::{self, PreparedDeleteQuery},
        FallibleQueryResults, PreparedQueries, PreparedQuery, PreparedSelectQuery,
        PreparedUpsertQuery,
    },
    schema::create_schema,
};
use crate::{
    service::utilities::health::{index_db_is_live, set_index_db_liveness},
    settings::{cassandra_db, Settings},
};

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

/// Represents errors that can occur while interacting with a Cassandra session.
#[derive(Debug, Error)]
pub(crate) enum CassandraSessionError {
    /// Error when creating a session fails.
    #[error("Creating session failed: {source}")]
    CreatingSessionFailed {
        /// The underlying error that caused the session creation to fail.
        #[source]
        source: anyhow::Error,
    },
    /// Error when connecting to database.
    #[error("Database connection failed: {source}")]
    ConnectionUnavailable {
        /// The underlying error that caused the connection failure.
        #[source]
        source: anyhow::Error,
    },
    /// Error when schema migration fails.
    #[error("Schema migration failed: {source}")]
    SchemaMigrationFailed {
        /// The underlying error that caused the schema migration to fail.
        #[source]
        source: anyhow::Error,
    },
    /// Error when preparing queries fails.
    #[error("Preparing queries failed: {source}")]
    PreparingQueriesFailed {
        /// The underlying error that caused query preparation to fail.
        #[source]
        source: anyhow::Error,
    },
    /// Error when preparing purge queries fails.
    #[error("Preparing purge queries failed: {source}")]
    PreparingPurgeQueriesFailed {
        /// The underlying error that caused purge query preparation to fail.
        #[source]
        source: anyhow::Error,
    },
    /// Error indicating that the session has already been set.
    #[error("Session already set")]
    SessionAlreadySet,
    /// Should be used by the caller when it fails to acquire the initialized database
    /// session.
    #[error("Failed acquiring database session")]
    FailedAcquiringSession,
}

/// All interaction with cassandra goes through this struct.
#[derive(Clone)]
pub(crate) struct CassandraSession {
    /// Is the session to the persistent or volatile DB?
    persistent: bool,
    /// Configuration for this session.
    cfg: Arc<cassandra_db::EnvVars>,
    /// The actual session.
    session: Arc<Session>,
    /// All prepared queries we can use on this session.
    queries: Arc<PreparedQueries>,
    /// All prepared purge queries we can use on this session.
    purge_queries: Arc<purge::PreparedQueries>,
}

/// Session error while initialization.
static INIT_SESSION_ERROR: OnceLock<Arc<CassandraSessionError>> = OnceLock::new();

/// Persistent DB Session.
static PERSISTENT_SESSION: OnceLock<Arc<CassandraSession>> = OnceLock::new();

/// Volatile DB Session.
static VOLATILE_SESSION: OnceLock<Arc<CassandraSession>> = OnceLock::new();

impl CassandraSession {
    /// Initialise the Cassandra Cluster Connections.
    pub(crate) fn init() {
        let (persistent, volatile) = Settings::cassandra_db_cfg();
        let network = Settings::cardano_network();

        let _join_handle =
            tokio::task::spawn(
                async move { Box::pin(retry_init(persistent, network, true)).await },
            );
        let _join_handle =
            tokio::task::spawn(async move { Box::pin(retry_init(volatile, network, false)).await });
    }

    /// Check to see if the Cassandra Indexing DB is ready for use
    pub(crate) async fn is_ready() -> bool {
        let persistent_ready = if let Some(cassandra) = PERSISTENT_SESSION.get() {
            cassandra
                .session
                .refresh_metadata()
                .await
                .inspect_err(|e| {
                    error!(error=%e, is_persistent=cassandra.is_persistent(), "Session connection failed");
                })
                .is_ok()
        } else {
            debug!(is_persistent = true, "Session has not been created");
            false
        };
        let volatile_ready = if let Some(cassandra) = VOLATILE_SESSION.get() {
            cassandra
                .session
                .refresh_metadata()
                .await
                .inspect_err(|e| {
                    error!(error=%e, is_persistent=cassandra.is_persistent(), "Session connection failed");
                })
                .is_ok()
        } else {
            debug!(is_persistent = false, "Session has not been created");
            false
        };
        let current_liveness = index_db_is_live();
        let is_ready = persistent_ready && volatile_ready;
        if is_ready {
            if !current_liveness {
                set_index_db_liveness(true);
            }
        } else if current_liveness {
            set_index_db_liveness(false);
        }
        is_ready
    }

    /// Wait for the Cassandra Indexing DB to be ready before continuing
    pub(crate) async fn wait_until_ready(
        interval: Duration, ignore_err: bool,
    ) -> Result<(), Arc<CassandraSessionError>> {
        loop {
            if !ignore_err {
                if let Some(err) = INIT_SESSION_ERROR.get() {
                    return Err(err.clone());
                }
            }

            if Self::is_ready().await {
                return Ok(());
            }

            tokio::time::sleep(interval).await;
        }
    }

    /// Get the session needed to perform a query.
    pub(crate) fn get(persistent: bool) -> Option<Arc<CassandraSession>> {
        if persistent {
            PERSISTENT_SESSION.get().cloned()
        } else {
            VOLATILE_SESSION.get().cloned()
        }
    }

    /// Executes a select query with the given parameters.
    ///
    /// Returns an iterator that iterates over all the result pages that the query
    /// returns.
    pub(crate) async fn execute_iter<P>(
        &self, select_query: PreparedSelectQuery, params: P,
    ) -> anyhow::Result<QueryPager>
    where P: SerializeRow {
        let session = self.session.clone();
        let queries = self.queries.clone();

        queries.execute_iter(session, select_query, params).await
    }

    /// Execute a Batch query with the given parameters.
    ///
    /// Values should be a Vec of values which implement `SerializeRow` and they MUST be
    /// the same, and must match the query being executed.
    ///
    /// This will divide the batch into optimal sized chunks and execute them until all
    /// values have been executed or the first error is encountered.
    pub(crate) async fn execute_batch<T: SerializeRow + Debug>(
        &self, query: PreparedQuery, values: Vec<T>,
    ) -> FallibleQueryResults {
        let session = self.session.clone();
        let cfg = self.cfg.clone();
        let queries = self.queries.clone();

        queries.execute_batch(session, cfg, query, values).await
    }

    /// Execute a query which returns no results, except an error if it fails.
    /// Can not be batched, takes a single set of parameters.
    pub(crate) async fn execute_upsert<T: SerializeRow + Debug>(
        &self, query: PreparedUpsertQuery, value: T,
    ) -> anyhow::Result<()> {
        let session = self.session.clone();
        let queries = self.queries.clone();

        queries.execute_upsert(session, query, value).await
    }

    /// Execute a purge query with the given parameters.
    ///
    /// Values should be a Vec of values which implement `SerializeRow` and they MUST be
    /// the same, and must match the query being executed.
    ///
    /// This will divide the batch into optimal sized chunks and execute them until all
    /// values have been executed or the first error is encountered.
    ///
    /// NOTE: This is currently only used to purge volatile data.
    pub(crate) async fn purge_execute_batch<T: SerializeRow + Debug>(
        &self, query: PreparedDeleteQuery, values: Vec<T>,
    ) -> FallibleQueryResults {
        // Only execute purge queries on the volatile session
        let persistent = false;
        let Some(volatile_db) = Self::get(persistent) else {
            // This should never happen
            anyhow::bail!("Volatile DB Session not found");
        };
        let cfg = self.cfg.clone();
        let queries = self.purge_queries.clone();
        let session = volatile_db.session.clone();

        queries.execute_batch(session, cfg, query, values).await
    }

    /// Execute a select query to gather primary keys for purging.
    pub(crate) async fn purge_execute_iter(
        &self, query: purge::PreparedSelectQuery,
    ) -> anyhow::Result<QueryPager> {
        // Only execute purge queries on the volatile session
        let persistent = false;
        let Some(volatile_db) = Self::get(persistent) else {
            // This should never happen
            anyhow::bail!("Volatile DB Session not found");
        };
        let queries = self.purge_queries.clone();

        queries
            .execute_iter(volatile_db.session.clone(), query)
            .await
    }

    /// Get underlying Raw Cassandra Session.
    pub(crate) fn get_raw_session(&self) -> Arc<Session> {
        self.session.clone()
    }

    /// Returns `true` if the database session is persistent.
    pub fn is_persistent(&self) -> bool {
        self.persistent
    }
}

/// Create a new execution profile based on the given configuration.
///
/// The intention here is that we should be able to tune this based on configuration,
/// but for now we don't so the `cfg` is not used yet.
fn make_execution_profile(_cfg: &cassandra_db::EnvVars) -> ExecutionProfile {
    ExecutionProfile::builder()
        .consistency(scylla::statement::Consistency::LocalQuorum)
        .serial_consistency(Some(scylla::statement::SerialConsistency::LocalSerial))
        .retry_policy(Arc::new(scylla::policies::retry::DefaultRetryPolicy::new()))
        .load_balancing_policy(
            scylla::policies::load_balancing::DefaultPolicyBuilder::new()
                .permit_dc_failover(true)
                .build(),
        )
        .speculative_execution_policy(Some(Arc::new(
            scylla::policies::speculative_execution::SimpleSpeculativeExecutionPolicy {
                max_retry_count: 3,
                retry_interval: Duration::from_millis(100),
            },
        )))
        .build()
}

/// Construct a session based on the given configuration.
async fn make_session(cfg: &cassandra_db::EnvVars) -> anyhow::Result<Arc<Session>> {
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

        sb = sb.tls_context(Some(ssl_context));
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

/// Continuously try and init the DB, if it fails, backoff.
///
/// Display reasonable logs to help diagnose DB connection issues.
async fn retry_init(cfg: cassandra_db::EnvVars, network: Network, persistent: bool) {
    let mut retry_delay = Duration::from_secs(0);
    let db_type = if persistent { "Persistent" } else { "Volatile" };

    info!(
        db_type = db_type,
        network = %network,
        "Index DB Session Creation: Started."
    );

    cfg.log(persistent, network);

    loop {
        tokio::time::sleep(retry_delay).await;
        retry_delay = Duration::from_secs(30); // 30 seconds if we every try again.

        info!(
            db_type = db_type,
            network = %network,
            "Attempting to connect to Cassandra DB..."
        );

        // Create a Session to the Cassandra DB.
        let session = match make_session(&cfg).await {
            Ok(session) => session,
            Err(error) => {
                error!(
                    db_type = db_type,
                    network = %network,
                    error = format!("{error:?}"),
                    "Failed to Create Cassandra DB Session"
                );
                drop(INIT_SESSION_ERROR.set(Arc::new(
                    CassandraSessionError::CreatingSessionFailed { source: error },
                )));
                continue;
            },
        };

        // Set up the Schema for it.
        if let Err(error) = create_schema(&mut session.clone(), &cfg, persistent, network).await {
            error!(
                db_type = db_type,
                network = %network,
                error = format!("{error:?}"),
                "Failed to Create Cassandra DB Schema"
            );
            drop(
                INIT_SESSION_ERROR.set(Arc::new(CassandraSessionError::SchemaMigrationFailed {
                    source: error,
                })),
            );
            continue;
        }

        let queries = match PreparedQueries::new(session.clone(), &cfg).await {
            Ok(queries) => Arc::new(queries),
            Err(error) => {
                error!(
                    db_type = db_type,
                    network = %network,
                    error = %error,
                    "Failed to Create Cassandra Prepared Queries"
                );
                drop(INIT_SESSION_ERROR.set(Arc::new(
                    CassandraSessionError::PreparingQueriesFailed { source: error },
                )));
                continue;
            },
        };

        let purge_queries = match Box::pin(purge::PreparedQueries::new(session.clone(), &cfg)).await
        {
            Ok(queries) => Arc::new(queries),
            Err(error) => {
                error!(
                    db_type = db_type,
                    network = %network,
                    error = %error,
                    "Failed to Create Cassandra Prepared Purge Queries"
                );
                drop(INIT_SESSION_ERROR.set(Arc::new(
                    CassandraSessionError::PreparingPurgeQueriesFailed { source: error },
                )));
                continue;
            },
        };

        let cassandra_session = CassandraSession {
            persistent,
            cfg: Arc::new(cfg),
            session,
            queries,
            purge_queries,
        };

        // Save the session so we can execute queries on the DB
        if persistent {
            if PERSISTENT_SESSION.set(Arc::new(cassandra_session)).is_err() {
                error!("Persistent Session already set.  This should not happen.");
                drop(INIT_SESSION_ERROR.set(Arc::new(CassandraSessionError::SessionAlreadySet)));
            };
        } else if VOLATILE_SESSION.set(Arc::new(cassandra_session)).is_err() {
            error!("Volatile Session already set.  This should not happen.");
            drop(INIT_SESSION_ERROR.set(Arc::new(CassandraSessionError::SessionAlreadySet)));
        };

        // IF we get here, then everything seems to have worked, so finish init.
        break;
    }

    info!(db_type = db_type, network = %network, "Index DB Session Creation: OK.");
}
