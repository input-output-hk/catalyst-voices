//! Command line and environment variable settings for the service
use std::{
    env::{self, VarError},
    fmt::{self, Display},
    net::{IpAddr, Ipv4Addr, SocketAddr},
    path::PathBuf,
    str::FromStr,
    sync::{LazyLock, OnceLock},
    time::Duration,
};

use anyhow::anyhow;
use cardano_chain_follower::Network;
use clap::Args;
use cryptoxide::{blake2b::Blake2b, mac::Mac};
use dotenvy::dotenv;
use duration_string::DurationString;
use strum::VariantNames;
use tracing::{error, info};
use url::Url;

use crate::{
    build_info::{log_build_info, BUILD_INFO},
    db::{
        self,
        index::session::{CompressionChoice, TlsChoice},
    },
    logger::{self, LogLevel, LOG_LEVEL_DEFAULT},
    service::utilities::net::{get_public_ipv4, get_public_ipv6},
};

/// Default address to start service on.
const ADDRESS_DEFAULT: &str = "0.0.0.0:3030";

/// Default Github repo owner
const GITHUB_REPO_OWNER_DEFAULT: &str = "input-output-hk";

/// Default Github repo name
const GITHUB_REPO_NAME_DEFAULT: &str = "catalyst-voices";

/// Default Github issue template to use
const GITHUB_ISSUE_TEMPLATE_DEFAULT: &str = "bug_report.yml";

/// Default `CLIENT_ID_KEY` used in development.
const CLIENT_ID_KEY_DEFAULT: &str = "3db5301e-40f2-47ed-ab11-55b37674631a";

/// Default `API_HOST_NAME/S` used in production.  This can be a single hostname, or a
/// list of them.
const API_HOST_NAMES_DEFAULT: &str = "https://api.prod.projectcatalyst.io";

/// Default `API_URL_PREFIX` used in development.
const API_URL_PREFIX_DEFAULT: &str = "/api";

/// Default `CHECK_CONFIG_TICK` used in development.
const CHECK_CONFIG_TICK_DEFAULT: &str = "5s";

/// Default Event DB URL.
const EVENT_DB_URL_DEFAULT: &str =
    "postgresql://postgres:postgres@localhost/catalyst_events?sslmode=disable";

/// Default Cassandra DB URL for the Persistent DB.
const CASSANDRA_PERSISTENT_DB_URL_DEFAULT: &str = "127.0.0.1:9042";

/// Default Cassandra DB URL for the Persistent DB.
const CASSANDRA_PERSISTENT_DB_NAMESPACE_DEFAULT: &str = "persistent";

/// Default Cassandra DB URL for the Persistent DB.
const CASSANDRA_VOLATILE_DB_URL_DEFAULT: &str = "127.0.0.1:9042";

/// Default Cassandra DB URL for the Persistent DB.
const CASSANDRA_VOLATILE_DB_NAMESPACE_DEFAULT: &str = "volatile";

/// Default maximum batch size.
/// This comes from:
/// <https://docs.aws.amazon.com/keyspaces/latest/devguide/functional-differences.html#functional-differences.batch>
/// Scylla may support larger batches for better performance.
/// Larger batches will incur more memory overhead to store the prepared batches.
const CASSANDRA_MAX_BATCH_SIZE_DEFAULT: i64 = 30;

/// Minimum possible batch size.
pub(crate) const CASSANDRA_MIN_BATCH_SIZE: i64 = 1;

/// Maximum possible batch size.
const CASSANDRA_MAX_BATCH_SIZE: i64 = 256;

/// Default chain to follow.
const CHAIN_FOLLOWER_DEFAULT: Network = Network::Mainnet;

/// Default number of sync tasks (must be in the range 1 to 255 inclusive.)
const CHAIN_FOLLOWER_SYNC_TASKS_DEFAULT: u16 = 16;

/// Hash the Public IPv4 and IPv6 address of the machine, and convert to a 128 bit V4
/// UUID.
fn calculate_service_uuid() -> String {
    let mut hasher = Blake2b::new_keyed(16, "Catalyst-Gateway-Machine-UID".as_bytes());

    let ipv4 = get_public_ipv4().to_string();
    let ipv6 = get_public_ipv6().to_string();

    hasher.input(ipv4.as_bytes());
    hasher.input(ipv6.as_bytes());

    let mut hash = [0u8; 16];

    hasher.raw_result(&mut hash);
    uuid::Builder::from_custom_bytes(hash)
        .into_uuid()
        .hyphenated()
        .to_string()
}

/// Settings for the application.
///
/// This struct represents the configuration settings for the application.
/// It is used to specify the server binding address,
/// the URL to the `PostgreSQL` event database,
/// and the logging level.
#[derive(Args, Clone)]
#[clap(version = BUILD_INFO)]
pub(crate) struct ServiceSettings {
    /// Url to the postgres event db
    #[clap(long, env)]
    pub(crate) event_db_url: Option<String>,

    /// Logging level
    #[clap(long, default_value = LOG_LEVEL_DEFAULT)]
    pub(crate) log_level: LogLevel,

    /// Docs settings.
    #[clap(flatten)]
    pub(crate) docs_settings: DocsSettings,
}

/// Settings specifies `OpenAPI` docs generation.
#[derive(Args, Clone)]
pub(crate) struct DocsSettings {
    /// The output path to the generated docs file, if omitted prints to stdout.
    pub(crate) output: Option<PathBuf>,

    /// Server binding address
    #[clap(long, default_value = ADDRESS_DEFAULT, env = "ADDRESS")]
    pub(crate) address: SocketAddr,

    /// Server name
    #[clap(long, env = "SERVER_NAME")]
    pub(crate) server_name: Option<String>,
}

/// An environment variable read as a string.
#[derive(Clone)]
pub(crate) struct StringEnvVar {
    /// Value of the env var.
    value: String,
    /// Whether the env var is displayed redacted or not.
    redacted: bool,
}

/// Ergonomic way of specifying if a env var needs to be redacted or not.
enum StringEnvVarParams {
    /// The env var is plain and should not be redacted.
    Plain(String, Option<String>),
    /// The env var is redacted and should be redacted.
    Redacted(String, Option<String>),
}

impl From<&str> for StringEnvVarParams {
    fn from(s: &str) -> Self {
        StringEnvVarParams::Plain(String::from(s), None)
    }
}

impl From<String> for StringEnvVarParams {
    fn from(s: String) -> Self {
        StringEnvVarParams::Plain(s, None)
    }
}

impl From<(&str, bool)> for StringEnvVarParams {
    fn from((s, r): (&str, bool)) -> Self {
        if r {
            StringEnvVarParams::Redacted(String::from(s), None)
        } else {
            StringEnvVarParams::Plain(String::from(s), None)
        }
    }
}

impl From<(&str, bool, &str)> for StringEnvVarParams {
    fn from((s, r, c): (&str, bool, &str)) -> Self {
        if r {
            StringEnvVarParams::Redacted(String::from(s), Some(String::from(c)))
        } else {
            StringEnvVarParams::Plain(String::from(s), Some(String::from(c)))
        }
    }
}

/// An environment variable read as a string.
impl StringEnvVar {
    /// Read the env var from the environment.
    ///
    /// If not defined, read from a .env file.
    /// If still not defined, use the default.
    ///
    /// # Arguments
    ///
    /// * `var_name`: &str - the name of the env var
    /// * `default_value`: &str - the default value
    ///
    /// # Returns
    ///
    /// * Self - the value
    ///
    /// # Example
    ///
    /// ```rust,no_run
    /// #use cat_data_service::settings::StringEnvVar;
    ///
    /// let var = StringEnvVar::new("MY_VAR", "default");
    /// assert_eq!(var.as_str(), "default");
    /// ```
    fn new(var_name: &str, param: StringEnvVarParams) -> Self {
        let (default_value, redacted, choices) = match param {
            StringEnvVarParams::Plain(s, c) => (s, false, c),
            StringEnvVarParams::Redacted(s, c) => (s, true, c),
        };

        match env::var(var_name) {
            Ok(value) => {
                if redacted {
                    info!(env = var_name, value = "Redacted", "Env Var Defined");
                } else {
                    info!(env = var_name, value = value, "Env Var Defined");
                }
                Self { value, redacted }
            },
            Err(VarError::NotPresent) => {
                if let Some(choices) = choices {
                    if redacted {
                        info!(
                            env = var_name,
                            default = "Default Redacted",
                            choices = choices,
                            "Env Var Defaulted"
                        );
                    } else {
                        info!(
                            env = var_name,
                            default = default_value,
                            choices = choices,
                            "Env Var Defaulted"
                        );
                    };
                } else if redacted {
                    info!(
                        env = var_name,
                        default = "Default Redacted",
                        "Env Var Defined"
                    );
                } else {
                    info!(env = var_name, default = default_value, "Env Var Defaulted");
                }

                Self {
                    value: default_value,
                    redacted,
                }
            },
            Err(error) => {
                error!(
                    env = var_name,
                    default = default_value,
                    error = ?error,
                    "Env Var Error"
                );
                Self {
                    value: default_value,
                    redacted,
                }
            },
        }
    }

    /// New Env Var that is optional.
    fn new_optional(var_name: &str, redacted: bool) -> Option<Self> {
        match env::var(var_name) {
            Ok(value) => {
                if redacted {
                    info!(env = var_name, value = "Redacted", "Env Var Defined");
                } else {
                    info!(env = var_name, value = value, "Env Var Defined");
                }
                Some(Self { value, redacted })
            },
            Err(VarError::NotPresent) => {
                info!(env = var_name, "Env Var Not Set");
                None
            },
            Err(error) => {
                error!(
                    env = var_name,
                    error = ?error,
                    "Env Var Error"
                );
                None
            },
        }
    }

    /// Convert an Envvar into the required Enum Type.
    fn new_as_enum<T: FromStr + Display + VariantNames>(
        var_name: &str, default: T, redacted: bool,
    ) -> T
    where <T as std::str::FromStr>::Err: std::fmt::Display {
        let mut choices = String::new();
        for name in T::VARIANTS {
            if choices.is_empty() {
                choices.push('[');
            } else {
                choices.push(',');
            }
            choices.push_str(name);
        }
        choices.push(']');

        let choice = StringEnvVar::new(
            var_name,
            (default.to_string().as_str(), redacted, choices.as_str()).into(),
        );

        let value = match T::from_str(choice.as_str()) {
            Ok(var) => var,
            Err(error) => {
                error!(error=%error, default=%default, choices=choices, choice=%choice, "Invalid choice. Using Default.");
                default
            },
        };

        value
    }

    /// Convert an Envvar into an integer in the bounded range.
    fn new_as_i64(var_name: &str, default: i64, min: i64, max: i64) -> i64
where {
        let choices = format!("A value in the range {min} to {max} inclusive");

        let raw_value = StringEnvVar::new(
            var_name,
            (default.to_string().as_str(), false, choices.as_str()).into(),
        )
        .as_string();

        match raw_value.parse::<i64>() {
            Ok(value) => {
                if value < min {
                    error!("{var_name} out of range. Range = {min} to {max} inclusive. Clamped to {min}");
                    min
                } else if value > max {
                    error!("{var_name} out of range. Range = {min} to {max} inclusive. Clamped to {max}");
                    max
                } else {
                    value
                }
            },
            Err(error) => {
                error!(error=%error, default=default, "{var_name} not an integer. Range = {min} to {max} inclusive. Defaulted");
                default
            },
        }
    }

    /// Get the read env var as a str.
    ///
    /// # Returns
    ///
    /// * &str - the value
    pub(crate) fn as_str(&self) -> &str {
        &self.value
    }

    /// Get the read env var as a str.
    ///
    /// # Returns
    ///
    /// * &str - the value
    pub(crate) fn as_string(&self) -> String {
        self.value.clone()
    }
}

impl fmt::Display for StringEnvVar {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        if self.redacted {
            return write!(f, "REDACTED");
        }
        write!(f, "{}", self.value)
    }
}

impl fmt::Debug for StringEnvVar {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        if self.redacted {
            return write!(f, "REDACTED");
        }
        write!(f, "env: {}", self.value)
    }
}

/// Configuration for an individual cassandra cluster.
#[derive(Clone)]
pub(crate) struct CassandraEnvVars {
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

impl CassandraEnvVars {
    /// Create a config for a cassandra cluster, identified by a default namespace.
    fn new(url: &str, namespace: &str) -> Self {
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
            max_batch_size: StringEnvVar::new_as_i64(
                &format!("CASSANDRA_{name}_BATCH_SIZE"),
                CASSANDRA_MAX_BATCH_SIZE_DEFAULT,
                CASSANDRA_MIN_BATCH_SIZE,
                CASSANDRA_MAX_BATCH_SIZE,
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

/// Configuration for the chain follower.
#[derive(Clone)]
pub(crate) struct ChainFollowerEnvVars {
    /// The Blockchain we sync from.
    pub(crate) chain: Network,

    /// The maximum number of sync tasks.
    pub(crate) sync_tasks: u16,
}

impl ChainFollowerEnvVars {
    /// Create a config for a cassandra cluster, identified by a default namespace.
    fn new() -> Self {
        let chain = StringEnvVar::new_as_enum("CHAIN_NETWORK", CHAIN_FOLLOWER_DEFAULT, false);
        let sync_tasks: u16 = StringEnvVar::new_as_i64(
            "CHAIN_FOLLOWER_SYNC_TASKS",
            CHAIN_FOLLOWER_SYNC_TASKS_DEFAULT.into(),
            1,
            u16::MAX.into(),
        )
        .try_into()
        .unwrap_or(CHAIN_FOLLOWER_SYNC_TASKS_DEFAULT);

        Self { chain, sync_tasks }
    }

    /// Log the configuration of this Chain Follower
    pub(crate) fn log(&self) {
        info!(
            chain = self.chain.to_string(),
            sync_tasks = self.sync_tasks,
            "Chain Follower Configuration"
        );
    }
}

/// All the `EnvVars` used by the service.
struct EnvVars {
    /// The github repo owner
    github_repo_owner: StringEnvVar,

    /// The github repo name
    github_repo_name: StringEnvVar,

    /// The github issue template to use
    github_issue_template: StringEnvVar,

    /// The Service ID used to anonymize client connections.
    service_id: StringEnvVar,

    /// The client id key used to anonymize client connections.
    client_id_key: StringEnvVar,

    /// A List of servers to provide
    api_host_names: StringEnvVar,

    /// The base path the API is served at.
    api_url_prefix: StringEnvVar,

    /// The Address of the Event DB.
    event_db_url: StringEnvVar,

    /// The `UserName` to use for the Event DB.
    event_db_username: Option<StringEnvVar>,

    /// The Address of the Event DB.
    event_db_password: Option<StringEnvVar>,

    /// The Config of the Persistent Cassandra DB.
    cassandra_persistent_db: CassandraEnvVars,

    /// The Config of the Volatile Cassandra DB.
    cassandra_volatile_db: CassandraEnvVars,

    /// The Chain Follower configuration
    chain_follower: ChainFollowerEnvVars,

    /// Tick every N seconds until config exists in db
    #[allow(unused)]
    check_config_tick: Duration,
}

// Lazy initialization of all env vars which are not command line parameters.
// All env vars used by the application should be listed here and all should have a
// default. The default for all NON Secret values should be suitable for Production, and
// NOT development. Secrets however should only be used with the default value in
// development

/// Handle to the mithril sync thread. One for each Network ONLY.
static ENV_VARS: LazyLock<EnvVars> = LazyLock::new(|| {
    // Support env vars in a `.env` file,  doesn't need to exist.
    dotenv().ok();

    let check_interval = StringEnvVar::new("CHECK_CONFIG_TICK", CHECK_CONFIG_TICK_DEFAULT.into());
    let check_config_tick = match DurationString::try_from(check_interval.as_string()) {
        Ok(duration) => duration.into(),
        Err(error) => {
            error!(
                "Invalid Check Config Tick Duration: {} : {}. Defaulting to 5 seconds.",
                check_interval.as_str(),
                error
            );
            Duration::from_secs(5)
        },
    };

    EnvVars {
        github_repo_owner: StringEnvVar::new("GITHUB_REPO_OWNER", GITHUB_REPO_OWNER_DEFAULT.into()),
        github_repo_name: StringEnvVar::new("GITHUB_REPO_NAME", GITHUB_REPO_NAME_DEFAULT.into()),
        github_issue_template: StringEnvVar::new(
            "GITHUB_ISSUE_TEMPLATE",
            GITHUB_ISSUE_TEMPLATE_DEFAULT.into(),
        ),
        service_id: StringEnvVar::new("SERVICE_ID", calculate_service_uuid().into()),
        client_id_key: StringEnvVar::new("CLIENT_ID_KEY", CLIENT_ID_KEY_DEFAULT.into()),
        api_host_names: StringEnvVar::new("API_HOST_NAMES", API_HOST_NAMES_DEFAULT.into()),
        api_url_prefix: StringEnvVar::new("API_URL_PREFIX", API_URL_PREFIX_DEFAULT.into()),
        event_db_url: StringEnvVar::new("EVENT_DB_URL", EVENT_DB_URL_DEFAULT.into()),
        event_db_username: StringEnvVar::new_optional("EVENT_DB_USERNAME", false),
        event_db_password: StringEnvVar::new_optional("EVENT_DB_PASSWORD", true),
        cassandra_persistent_db: CassandraEnvVars::new(
            CASSANDRA_PERSISTENT_DB_URL_DEFAULT,
            CASSANDRA_PERSISTENT_DB_NAMESPACE_DEFAULT,
        ),
        cassandra_volatile_db: CassandraEnvVars::new(
            CASSANDRA_VOLATILE_DB_URL_DEFAULT,
            CASSANDRA_VOLATILE_DB_NAMESPACE_DEFAULT,
        ),
        chain_follower: ChainFollowerEnvVars::new(),
        check_config_tick,
    }
});

impl EnvVars {
    /// Validate env vars in ways we couldn't when they were first loaded.
    pub(crate) fn validate() -> anyhow::Result<()> {
        let mut status = Ok(());

        let url = ENV_VARS.event_db_url.as_str();
        if let Err(error) = tokio_postgres::config::Config::from_str(url) {
            error!(error=%error, url=url, "Invalid Postgres DB URL.");
            status = Err(anyhow!("Environment Variable Validation Error."));
        }

        status
    }
}

/// All Settings/Options for the Service.
static SERVICE_SETTINGS: OnceLock<ServiceSettings> = OnceLock::new();

/// Our Global Settings for this running service.
pub(crate) struct Settings();

impl Settings {
    /// Initialize the settings data.
    pub(crate) fn init(settings: ServiceSettings) -> anyhow::Result<()> {
        let log_level = settings.log_level;

        if SERVICE_SETTINGS.set(settings).is_err() {
            // We use println here, because logger not yet configured.
            println!("Failed to initialize service settings. Called multiple times?");
        }

        // Init the logger.
        logger::init(log_level);

        log_build_info();

        // Validate any settings we couldn't validate when loaded.
        EnvVars::validate()
    }

    /// Get the current Event DB settings for this service.
    pub(crate) fn event_db_settings() -> (&'static str, Option<&'static str>, Option<&'static str>)
    {
        let url = ENV_VARS.event_db_url.as_str();
        let user = ENV_VARS
            .event_db_username
            .as_ref()
            .map(StringEnvVar::as_str);
        let pass = ENV_VARS
            .event_db_password
            .as_ref()
            .map(StringEnvVar::as_str);

        (url, user, pass)
    }

    /// Get the Persistent & Volatile Cassandra DB config for this service.
    pub(crate) fn cassandra_db_cfg() -> (CassandraEnvVars, CassandraEnvVars) {
        (
            ENV_VARS.cassandra_persistent_db.clone(),
            ENV_VARS.cassandra_volatile_db.clone(),
        )
    }

    /// Get the configuration of the chain follower.
    pub(crate) fn follower_cfg() -> ChainFollowerEnvVars {
        ENV_VARS.chain_follower.clone()
    }

    /// The API Url prefix
    pub(crate) fn api_url_prefix() -> &'static str {
        ENV_VARS.api_url_prefix.as_str()
    }

    /// The Key used to anonymize client connections in the logs.
    pub(crate) fn client_id_key() -> &'static str {
        ENV_VARS.client_id_key.as_str()
    }

    /// The Service UUID
    #[allow(unused)]
    pub(crate) fn service_id() -> &'static str {
        ENV_VARS.service_id.as_str()
    }

    /// Get a list of all host names to serve the API on.
    ///
    /// Used by the `OpenAPI` Documentation to point to the correct backend.
    /// Take a list of [scheme://] + host names from the env var and turns it into
    /// a lits of strings.
    ///
    /// Host names are taken from the `API_HOST_NAMES` environment variable.
    /// If that is not set, `addr` is used.
    pub(crate) fn api_host_names() -> Vec<String> {
        if let Some(settings) = SERVICE_SETTINGS.get() {
            let addr = settings.docs_settings.address;
            string_to_api_host_names(&addr, ENV_VARS.api_host_names.as_str())
        } else {
            Vec::new()
        }
    }

    /// The socket address we are bound to.
    pub(crate) fn bound_address() -> SocketAddr {
        if let Some(settings) = SERVICE_SETTINGS.get() {
            settings.docs_settings.address
        } else {
            // This should never happen, needed to satisfy the compiler.
            SocketAddr::new(IpAddr::V4(Ipv4Addr::new(127, 0, 0, 1)), 8080)
        }
    }

    /// Get the server name to be used in the `Server` object of the `OpenAPI` Document.
    pub(crate) fn server_name() -> Option<String> {
        if let Some(settings) = SERVICE_SETTINGS.get() {
            settings.docs_settings.server_name.clone()
        } else {
            None
        }
    }

    /// Generate a github issue url with a given title
    ///
    /// ## Arguments
    ///
    /// * `title`: &str - the title to give the issue
    ///
    /// ## Returns
    ///
    /// * String - the url
    ///
    /// ## Example
    ///
    /// ```rust,no_run
    /// # use cat_data_service::settings::generate_github_issue_url;
    /// assert_eq!(
    ///     generate_github_issue_url("Hello, World! How are you?"),
    ///     "https://github.com/input-output-hk/catalyst-voices/issues/new?template=bug_report.yml&title=Hello%2C%20World%21%20How%20are%20you%3F"
    /// );
    /// ```
    pub(crate) fn generate_github_issue_url(title: &str) -> Option<Url> {
        let path = format!(
            "https://github.com/{}/{}/issues/new",
            ENV_VARS.github_repo_owner.as_str(),
            ENV_VARS.github_repo_name.as_str()
        );

        match Url::parse_with_params(&path, &[
            ("template", ENV_VARS.github_issue_template.as_str()),
            ("title", title),
        ]) {
            Ok(url) => Some(url),
            Err(e) => {
                error!("Failed to generate github issue url {:?}", e.to_string());
                None
            },
        }
    }
}

/// Transform a string list of host names into a vec of host names.
/// Default to the service address if none specified.
fn string_to_api_host_names(addr: &SocketAddr, hosts: &str) -> Vec<String> {
    /// Log an invalid hostname.
    fn invalid_hostname(hostname: &str) -> String {
        error!("Invalid host name for API: {}", hostname);
        String::new()
    }

    let configured_hosts: Vec<String> = hosts
        .split(',')
        .map(|s| {
            let url = Url::parse(s.trim());
            match url {
                Ok(url) => {
                    // Get the scheme, and if its empty, use http
                    let scheme = url.scheme();

                    let port = url.port();

                    // Rebuild the scheme + hostname
                    match url.host() {
                        Some(host) => {
                            let host = host.to_string();
                            if host.is_empty() {
                                invalid_hostname(s)
                            } else {
                                match port {
                                    Some(port) => {
                                        format! {"{scheme}://{host}:{port}"}
                                        // scheme.to_owned() + "://" + &host + ":" +
                                        // &port.to_string()
                                    },
                                    None => {
                                        format! {"{scheme}://{host}"}
                                    },
                                }
                            }
                        },
                        None => invalid_hostname(s),
                    }
                },
                Err(_) => invalid_hostname(s),
            }
        })
        .filter(|s| !s.is_empty())
        .collect();

    // If there are no host names, just use the address of the service.
    if configured_hosts.is_empty() {
        // If the Socket Address is the "catchall" address, then use localhost.
        if match addr.ip() {
            IpAddr::V4(ipv4) => ipv4.is_unspecified(),
            IpAddr::V6(ipv6) => ipv6.is_unspecified(),
        } {
            let port = addr.port();
            vec![format! {"http://localhost:{port}"}]
        } else {
            vec![format! {"http://{addr}"}]
        }
    } else {
        configured_hosts
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn generate_github_issue_url_test() {
        let title = "Hello, World! How are you?";
        assert_eq!(
            Settings::generate_github_issue_url(title).expect("Failed to generate url").as_str(),
            "https://github.com/input-output-hk/catalyst-voices/issues/new?template=bug_report.yml&title=Hello%2C+World%21+How+are+you%3F"
        );
    }

    #[test]
    fn configured_hosts_default() {
        let configured_hosts = Settings::api_host_names();
        assert_eq!(configured_hosts, Vec::<String>::new());
    }

    #[test]
    fn configured_hosts_set_multiple() {
        let configured_hosts = string_to_api_host_names(
            &SocketAddr::from(([127, 0, 0, 1], 8080)),
            "http://api.prod.projectcatalyst.io , https://api.dev.projectcatalyst.io:1234",
        );
        assert_eq!(configured_hosts, vec![
            "http://api.prod.projectcatalyst.io",
            "https://api.dev.projectcatalyst.io:1234"
        ]);
    }

    #[test]
    fn configured_hosts_set_multiple_one_invalid() {
        let configured_hosts = string_to_api_host_names(
            &SocketAddr::from(([127, 0, 0, 1], 8080)),
            "not a hostname , https://api.dev.projectcatalyst.io:1234",
        );
        assert_eq!(configured_hosts, vec![
            "https://api.dev.projectcatalyst.io:1234"
        ]);
    }

    #[test]
    fn configured_hosts_set_empty() {
        let configured_hosts =
            string_to_api_host_names(&SocketAddr::from(([127, 0, 0, 1], 8080)), "");
        assert_eq!(configured_hosts, vec!["http://127.0.0.1:8080"]);
    }

    #[test]
    fn configured_hosts_set_empty_undefined_address() {
        let configured_hosts =
            string_to_api_host_names(&SocketAddr::from(([0, 0, 0, 0], 7654)), "");
        assert_eq!(configured_hosts, vec!["http://localhost:7654"]);
    }
}
