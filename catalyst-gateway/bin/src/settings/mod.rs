//! Command line and environment variable settings for the service
use std::{
    net::{IpAddr, Ipv4Addr, SocketAddr},
    str::FromStr,
    sync::{LazyLock, OnceLock},
    time::Duration,
};

use anyhow::anyhow;
use cardano_blockchain_types::{Network, Slot};
use clap::Args;
use dotenvy::dotenv;
use str_env_var::StringEnvVar;
use tracing::error;
use url::Url;

use crate::{
    build_info::{log_build_info, BUILD_INFO},
    logger::{self, LogLevel, LOG_LEVEL_DEFAULT},
    service::utilities::net::{get_public_ipv4, get_public_ipv6},
    utils::blake2b_hash::generate_uuid_string_from_data,
};

pub(crate) mod cassandra_db;
pub(crate) mod chain_follower;
mod str_env_var;

/// Default address to start service on, '0.0.0.0:3030'.
const ADDRESS_DEFAULT: SocketAddr = SocketAddr::new(IpAddr::V4(Ipv4Addr::new(0, 0, 0, 0)), 3030);

/// Default Github repo owner
const GITHUB_REPO_OWNER_DEFAULT: &str = "input-output-hk";

/// Default Github repo name
const GITHUB_REPO_NAME_DEFAULT: &str = "catalyst-voices";

/// Default Github issue template to use
const GITHUB_ISSUE_TEMPLATE_DEFAULT: &str = "bug_report.yml";

/// Default `CLIENT_ID_KEY` used in development.
const CLIENT_ID_KEY_DEFAULT: &str = "3db5301e-40f2-47ed-ab11-55b37674631a";

/// Default `API_URL_PREFIX` used in development.
const API_URL_PREFIX_DEFAULT: &str = "/api";

/// Default `CHECK_CONFIG_TICK` used in development, 5 seconds.
const CHECK_CONFIG_TICK_DEFAULT: Duration = Duration::from_secs(5);

/// Default `METRICS_MEMORY_INTERVAL`, 1 second.
const METRICS_MEMORY_INTERVAL_DEFAULT: Duration = Duration::from_secs(1);

/// Default `METRICS_FOLLOWER_INTERVAL`, 1 second.
const METRICS_FOLLOWER_INTERVAL_DEFAULT: Duration = Duration::from_secs(1);

/// Default Event DB URL.
const EVENT_DB_URL_DEFAULT: &str =
    "postgresql://postgres:postgres@localhost/catalyst_events?sslmode=disable";

/// Default number of slots used as overlap when purging Live Index data.
const PURGE_BACKWARD_SLOT_BUFFER_DEFAULT: u64 = 100;

/// Default `SERVICE_LIVE_TIMEOUT_INTERVAL`, that is used to determine if the service is
/// live, 30 seconds.
const SERVICE_LIVE_TIMEOUT_INTERVAL_DEFAULT: Duration = Duration::from_secs(30);

/// Default `SERVICE_LIVE_COUNTER_THRESHOLD`, that is used to determine if the service is
/// live.
const SERVICE_LIVE_COUNTER_THRESHOLD_DEFAULT: u64 = 100;

/// Hash the Public IPv4 and IPv6 address of the machine, and convert to a 128 bit V4
/// UUID.
fn calculate_service_uuid() -> String {
    let ip_addr: Vec<String> = vec![get_public_ipv4().to_string(), get_public_ipv6().to_string()];

    generate_uuid_string_from_data("Catalyst-Gateway-Machine-UID", &ip_addr)
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
    /// Logging level
    #[clap(long, default_value = LOG_LEVEL_DEFAULT)]
    pub(crate) log_level: LogLevel,
}

/// All the `EnvVars` used by the service.
struct EnvVars {
    /// The github repo owner
    github_repo_owner: StringEnvVar,

    /// The github repo name
    github_repo_name: StringEnvVar,

    /// The github issue template to use
    github_issue_template: StringEnvVar,

    /// Server binding address
    address: SocketAddr,

    /// Server name
    server_name: Option<StringEnvVar>,

    /// The Service ID used to anonymize client connections.
    service_id: StringEnvVar,

    /// The client id key used to anonymize client connections.
    client_id_key: StringEnvVar,

    /// A List of servers to provide
    api_host_names: Option<StringEnvVar>,

    /// The base path the API is served at.
    api_url_prefix: StringEnvVar,

    /// The Address of the Event DB.
    event_db_url: StringEnvVar,

    /// The `UserName` to use for the Event DB.
    event_db_username: Option<StringEnvVar>,

    /// The Address of the Event DB.
    event_db_password: Option<StringEnvVar>,

    /// The Config of the Persistent Cassandra DB.
    cassandra_persistent_db: cassandra_db::EnvVars,

    /// The Config of the Volatile Cassandra DB.
    cassandra_volatile_db: cassandra_db::EnvVars,

    /// The Chain Follower configuration
    chain_follower: chain_follower::EnvVars,

    /// Internal API Access API Key
    internal_api_key: Option<StringEnvVar>,

    /// Tick every N seconds until config exists in db
    #[allow(unused)]
    check_config_tick: Duration,

    /// Slot buffer used as overlap when purging Live Index data.
    purge_backward_slot_buffer: u64,

    /// Interval for updating and sending memory metrics.
    metrics_memory_interval: Duration,

    /// Interval for updating and sending Chain Follower metrics.
    metrics_follower_interval: Duration,

    /// Interval for determining if the service is live.
    service_live_timeout_interval: Duration,

    /// Threshold for determining if the service is live.
    service_live_counter_threshold: u64,
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

    let address = StringEnvVar::new("ADDRESS", ADDRESS_DEFAULT.to_string().into());
    let address = SocketAddr::from_str(address.as_str())
        .inspect(|err| {
            error!(
                "Invalid binding address {}, err: {err}. Using default binding address value {ADDRESS_DEFAULT}.",
                address.as_str(),
            );
        }).unwrap_or(ADDRESS_DEFAULT);

    let purge_backward_slot_buffer = StringEnvVar::new_as_int(
        "PURGE_BACKWARD_SLOT_BUFFER",
        PURGE_BACKWARD_SLOT_BUFFER_DEFAULT,
        0,
        u64::MAX,
    );

    EnvVars {
        github_repo_owner: StringEnvVar::new("GITHUB_REPO_OWNER", GITHUB_REPO_OWNER_DEFAULT.into()),
        github_repo_name: StringEnvVar::new("GITHUB_REPO_NAME", GITHUB_REPO_NAME_DEFAULT.into()),
        github_issue_template: StringEnvVar::new(
            "GITHUB_ISSUE_TEMPLATE",
            GITHUB_ISSUE_TEMPLATE_DEFAULT.into(),
        ),
        address,
        server_name: StringEnvVar::new_optional("SERVER_NAME", false),
        service_id: StringEnvVar::new("SERVICE_ID", calculate_service_uuid().into()),
        client_id_key: StringEnvVar::new("CLIENT_ID_KEY", CLIENT_ID_KEY_DEFAULT.into()),
        api_host_names: StringEnvVar::new_optional("API_HOST_NAMES", false),
        api_url_prefix: StringEnvVar::new("API_URL_PREFIX", API_URL_PREFIX_DEFAULT.into()),
        event_db_url: StringEnvVar::new("EVENT_DB_URL", EVENT_DB_URL_DEFAULT.into()),
        event_db_username: StringEnvVar::new_optional("EVENT_DB_USERNAME", false),
        event_db_password: StringEnvVar::new_optional("EVENT_DB_PASSWORD", true),
        cassandra_persistent_db: cassandra_db::EnvVars::new(
            cassandra_db::PERSISTENT_URL_DEFAULT,
            cassandra_db::PERSISTENT_NAMESPACE_DEFAULT,
        ),
        cassandra_volatile_db: cassandra_db::EnvVars::new(
            cassandra_db::VOLATILE_URL_DEFAULT,
            cassandra_db::VOLATILE_NAMESPACE_DEFAULT,
        ),
        chain_follower: chain_follower::EnvVars::new(),
        internal_api_key: StringEnvVar::new_optional("INTERNAL_API_KEY", true),
        check_config_tick: StringEnvVar::new_as_duration(
            "CHECK_CONFIG_TICK",
            CHECK_CONFIG_TICK_DEFAULT,
        ),
        purge_backward_slot_buffer,
        metrics_memory_interval: StringEnvVar::new_as_duration(
            "METRICS_MEMORY_INTERVAL",
            METRICS_MEMORY_INTERVAL_DEFAULT,
        ),
        metrics_follower_interval: StringEnvVar::new_as_duration(
            "METRICS_FOLLOWER_INTERVAL",
            METRICS_FOLLOWER_INTERVAL_DEFAULT,
        ),
        service_live_timeout_interval: StringEnvVar::new_as_duration(
            "SERVICE_LIVE_TIMEOUT_INTERVAL",
            SERVICE_LIVE_TIMEOUT_INTERVAL_DEFAULT,
        ),
        service_live_counter_threshold: StringEnvVar::new_as_int(
            "SERVICE_LIVE_COUNTER_THRESHOLD",
            SERVICE_LIVE_COUNTER_THRESHOLD_DEFAULT,
            0,
            u64::MAX,
        ),
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
    pub(crate) fn cassandra_db_cfg() -> (cassandra_db::EnvVars, cassandra_db::EnvVars) {
        (
            ENV_VARS.cassandra_persistent_db.clone(),
            ENV_VARS.cassandra_volatile_db.clone(),
        )
    }

    /// Get the configuration of the chain follower.
    pub(crate) fn follower_cfg() -> chain_follower::EnvVars {
        ENV_VARS.chain_follower.clone()
    }

    /// Chain Follower network (The Blockchain network we are configured to use).
    /// Note: Catalyst Gateway can ONLY follow one network at a time.
    pub(crate) fn cardano_network() -> Network {
        ENV_VARS.chain_follower.chain
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
    pub(crate) fn service_id() -> &'static str {
        ENV_VARS.service_id.as_str()
    }

    /// The memory metrics interval
    pub(crate) fn metrics_memory_interval() -> Duration {
        ENV_VARS.metrics_memory_interval
    }

    /// The Chain Follower metrics interval
    pub(crate) fn metrics_follower_interval() -> Duration {
        ENV_VARS.metrics_follower_interval
    }

    /// Get a list of all host names to serve the API on.
    ///
    /// Used by the `OpenAPI` Documentation to point to the correct backend.
    /// Take a list of [scheme://] + host names from the env var and turns it into
    /// a lits of strings.
    ///
    /// Host names are taken from the `API_HOST_NAMES` environment variable.
    /// If that is not set, returns an empty list.
    pub(crate) fn api_host_names() -> Vec<String> {
        string_to_api_host_names(
            ENV_VARS
                .api_host_names
                .as_ref()
                .map(StringEnvVar::as_str)
                .unwrap_or_default(),
        )
    }

    /// The socket address we are bound to.
    pub(crate) fn bound_address() -> SocketAddr {
        ENV_VARS.address
    }

    /// Get the server name to be used in the `Server` object of the `OpenAPI` Document.
    pub(crate) fn server_name() -> Option<&'static str> {
        ENV_VARS.server_name.as_ref().map(StringEnvVar::as_str)
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

    /// Check a given key matches the internal API Key
    pub(crate) fn check_internal_api_key(value: &str) -> bool {
        if let Some(required_key) = ENV_VARS.internal_api_key.as_ref().map(StringEnvVar::as_str) {
            value == required_key
        } else {
            false
        }
    }

    /// Slot buffer used as overlap when purging Live Index data.
    pub(crate) fn purge_backward_slot_buffer() -> Slot {
        ENV_VARS.purge_backward_slot_buffer.into()
    }

    /// Duration in seconds used to determine if the system is live during checks.
    pub(crate) fn service_live_timeout_interval() -> Duration {
        ENV_VARS.service_live_timeout_interval
    }

    /// Value after which the service is considered NOT live.
    pub(crate) fn service_live_counter_threshold() -> u64 {
        ENV_VARS.service_live_counter_threshold
    }
}

/// Transform a string list of host names into a vec of host names.
fn string_to_api_host_names(hosts: &str) -> Vec<String> {
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

    configured_hosts
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
        assert!(configured_hosts.is_empty());
    }

    #[test]
    fn configured_hosts_set_multiple() {
        let configured_hosts = string_to_api_host_names(
            "http://api.prod.projectcatalyst.io , https://api.dev.projectcatalyst.io:1234",
        );
        assert_eq!(configured_hosts, vec![
            "http://api.prod.projectcatalyst.io",
            "https://api.dev.projectcatalyst.io:1234"
        ]);
    }

    #[test]
    fn configured_hosts_set_multiple_one_invalid() {
        let configured_hosts =
            string_to_api_host_names("not a hostname , https://api.dev.projectcatalyst.io:1234");
        assert_eq!(configured_hosts, vec![
            "https://api.dev.projectcatalyst.io:1234"
        ]);
    }

    #[test]
    fn configured_hosts_set_empty() {
        let configured_hosts = string_to_api_host_names("");
        assert!(configured_hosts.is_empty());
    }

    #[test]
    fn configured_service_live_timeout_interval_default() {
        let timeout_secs = Settings::service_live_timeout_interval();
        assert_eq!(timeout_secs, SERVICE_LIVE_TIMEOUT_INTERVAL_DEFAULT);
    }

    #[test]
    fn configured_service_live_counter_threshold_default() {
        let threshold = Settings::service_live_counter_threshold();
        assert_eq!(threshold, SERVICE_LIVE_COUNTER_THRESHOLD_DEFAULT);
    }
}
