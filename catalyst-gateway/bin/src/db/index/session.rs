//! Session creation and storage

use std::{
    fmt::Debug,
    path::PathBuf,
    sync::{Arc, OnceLock},
    time::Duration,
};

use handlebars::Handlebars;
use openssl::ssl::{SslContextBuilder, SslFiletype, SslMethod, SslVerifyMode};
use scylla::{
    frame::Compression, serialize::row::SerializeRow, transport::iterator::QueryPager,
    ExecutionProfile, Session, SessionBuilder,
};
use serde_json::json;
use tokio::fs;
use tracing::{error, info};

use super::{
    queries::{
        FallibleQueryResults, PreparedQueries, PreparedQuery, PreparedSelectQuery,
        PreparedUpsertQuery,
    },
    schema::{create_schema, get_table_names},
};
use crate::{
    db::index::{queries, schema::namespace},
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

/// All interaction with cassandra goes through this struct.
#[derive(Clone)]
pub(crate) struct CassandraSession {
    /// Is the session to the persistent or volatile DB?
    #[allow(dead_code)]
    persistent: bool,
    /// Configuration for this session.
    cfg: Arc<cassandra_db::EnvVars>,
    /// The actual session.
    session: Arc<Session>,
    /// All prepared queries we can use on this session.
    queries: Arc<PreparedQueries>,
}

/// Persistent DB Session.
static PERSISTENT_SESSION: OnceLock<Arc<CassandraSession>> = OnceLock::new();

/// Volatile DB Session.
static VOLATILE_SESSION: OnceLock<Arc<CassandraSession>> = OnceLock::new();

impl CassandraSession {
    /// Initialise the Cassandra Cluster Connections.
    pub(crate) async fn init() {
        let (persistent, volatile) = Settings::cassandra_db_cfg();

        // wait until persistent has been created
        if retry_init(persistent, true).await.is_ok() {
            let _unused = retry_init(volatile, false).await;
        };
    }

    /// Check to see if the Cassandra Indexing DB is ready for use
    pub(crate) fn is_ready() -> bool {
        PERSISTENT_SESSION.get().is_some() && VOLATILE_SESSION.get().is_some()
    }

    /// Wait for the Cassandra Indexing DB to be ready before continuing
    pub(crate) async fn wait_is_ready(interval: Duration) {
        loop {
            if Self::is_ready() {
                break;
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

    /// Get underlying Raw Cassandra Session.
    pub(crate) fn get_raw_session(&self) -> Arc<Session> {
        self.session.clone()
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
        .retry_policy(Arc::new(scylla::retry_policy::DefaultRetryPolicy::new()))
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

/// Continuously try and init the DB, if it fails, backoff.
///
/// Display reasonable logs to help diagnose DB connection issues.
#[allow(clippy::match_same_arms)]
async fn retry_init(cfg: cassandra_db::EnvVars, persistent: bool) -> anyhow::Result<()> {
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

        info!(db_type = db_type, "Connected to Cassandra DB");

        if let Err(error) = create_schema(&mut session.clone(), &cfg).await {
            let error = format!("{error:?}");
            error!(
                db_type = db_type,
                error = error,
                "Failed to Create Cassandra DB Schema"
            );
            continue;
        }

        info!(db_type = db_type, "Created schema");

        // Check if we are on AWS infrastructure
        if on_aws(session.clone()).await {
            let key_space = namespace(&cfg);

            match session.use_keyspace(key_space.clone(), false).await {
                Ok(()) => (),
                Err(err) => {
                    error!("Failed to set keyspace, continue trying... {:?}", err);
                    continue;
                },
            }

            // poll until the status of all tables are ACTIVE
            while check_all_tables(session.clone(), key_space.clone())
                .await
                .is_err()
            {}
        }

        let queries = match queries::PreparedQueries::new(session.clone(), &cfg).await {
            Ok(queries) => Arc::new(queries),
            Err(error) => {
                error!(
                    db_type = db_type,
                    error = %error,
                    "Failed to Create Cassandra Prepared Queries"
                );
                continue;
            },
        };

        let cassandra_session = CassandraSession {
            persistent,
            cfg: Arc::new(cfg),
            session: session.clone(),
            queries,
        };

        // Save the session so we can execute queries on the DB
        if persistent {
            if PERSISTENT_SESSION.set(Arc::new(cassandra_session)).is_err() {
                error!("Persistent Session already set.  This should not happen.");
            };
        } else if VOLATILE_SESSION.set(Arc::new(cassandra_session)).is_err() {
            error!("Volatile Session already set.  This should not happen.");
        };

        // IF we get here, then everything seems to have worked, so finish init.
        break;
    }

    info!(db_type = db_type, "Index DB Session Creation: OK.");

    Ok(())
}

/// Check if we are on AWS infra
pub async fn on_aws(session: Arc<Session>) -> bool {
    /// Query to check if we are AWS infra
    const ON_AWS: &str = include_str!("schema/cql/on_aws.cql");
    session.query_unpaged(ON_AWS, []).await.is_ok()
}

/// Check tables are active in AWS key spaces
async fn check_all_tables(session: Arc<Session>, keyspace: String) -> anyhow::Result<()> {
    for table in get_table_names()? {
        table_creation_status_keyspaces(session.clone(), keyspace.clone(), table).await?;
    }

    Ok(())
}

/// Check if AWS table has been created and status is ACTIVE.
/// `https://docs.aws.amazon.com/keyspaces/latest/devguide/tables-create.html`
async fn table_creation_status_keyspaces(
    session: Arc<Session>, keyspace: String, table_name: String,
) -> anyhow::Result<bool> {
    /// Query to check status of tables
    const AWS_TABLE_CHECK: &str = include_str!("schema/cql/aws_table_check.cql");

    let mut reg = Handlebars::new();
    reg.register_escape_fn(|s| s.into());
    let query = reg.render_template(
        AWS_TABLE_CHECK,
        &json!({"keyspace_name": keyspace,"table_name":table_name}),
    )?;

    let table_status: (String,) = session
        .query_unpaged(query, &[])
        .await?
        .into_rows_result()?
        .first_row::<(String,)>()?;

    if table_status.0 == "ACTIVE" {
        Ok(true)
    } else {
        Err(anyhow::anyhow!("Table not active yet {:?}", table_name))
    }
}

/// Check keyspace creation status in Amazon Keyspaces
/// `https://docs.aws.amazon.com/keyspaces/latest/devguide/keyspaces-create.htmll`
pub async fn keyspace_creation_status(
    session: Arc<Session>, keyspace: String,
) -> anyhow::Result<bool> {
    /// Query to check if keyspace exists
    const AWS_KEYSPACE_CHECK: &str = include_str!("schema/cql/aws_check_keyspace_exists.cql");

    let mut reg = Handlebars::new();
    reg.register_escape_fn(|s| s.into());
    let query = reg.render_template(AWS_KEYSPACE_CHECK, &json!({"keyspace_name": keyspace}))?;

    let keyspace_name: (String,) = session
        .query_unpaged(query, &[])
        .await?
        .into_rows_result()?
        .first_row::<(String,)>()?;

    if keyspace_name.0 == keyspace {
        Ok(true)
    } else {
        Err(anyhow::anyhow!("Keyspace not created yet {:?}", keyspace))
    }
}
