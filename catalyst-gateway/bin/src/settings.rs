//! Command line and environment variable settings for the service
use std::{
    env,
    net::{IpAddr, SocketAddr},
    path::PathBuf,
};

use clap::Args;
use dotenvy::dotenv;
use lazy_static::lazy_static;
use tracing::log::error;
use url::Url;

use crate::logger::{LogLevel, LOG_LEVEL_DEFAULT};

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

/// Settings for the application.
///
/// This struct represents the configuration settings for the application.
/// It is used to specify the server binding address,
/// the URL to the `PostgreSQL` event database,
/// and the logging level.
#[derive(Args, Clone)]
pub(crate) struct ServiceSettings {
    /// Url to the postgres event db
    #[clap(long, env)]
    pub(crate) database_url: String,

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

    /// Flag for adding "http" to servers
    #[clap(long, default_value = "false", env = "HTTP_AUTO_SERVERS")]
    pub(crate) http_auto_servers: bool,

    /// Flag for adding "https" to servers
    #[clap(long, default_value = "true", env = "HTTPS_AUTO_SERVERS")]
    pub(crate) https_auto_servers: bool,

    /// Server name
    #[clap(long, env = "SERVER_NAME")]
    pub(crate) server_name: Option<String>,
}

/// An environment variable read as a string.
pub(crate) struct StringEnvVar(String);

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
    fn new(var_name: &str, default_value: &str) -> Self {
        dotenv().ok();
        let value = env::var(var_name).unwrap_or_else(|_| default_value.to_owned());
        Self(value)
    }

    /// Get the read env var as a str.
    ///
    /// # Returns
    ///
    /// * &str - the value
    pub(crate) fn as_str(&self) -> &str {
        &self.0
    }
}

// Lazy initialization of all env vars which are not command line parameters.
// All env vars used by the application should be listed here and all should have a
// default. The default for all NON Secret values should be suitable for Production, and
// NOT development. Secrets however should only be used with the default value in
// development.
lazy_static! {
    /// The github repo owner
    pub(crate) static ref GITHUB_REPO_OWNER: StringEnvVar = StringEnvVar::new("GITHUB_REPO_OWNER", GITHUB_REPO_OWNER_DEFAULT);

    /// The github repo name
    pub(crate) static ref GITHUB_REPO_NAME: StringEnvVar = StringEnvVar::new("GITHUB_REPO_NAME", GITHUB_REPO_NAME_DEFAULT);

    /// The github issue template to use
    pub(crate) static ref GITHUB_ISSUE_TEMPLATE: StringEnvVar = StringEnvVar::new("GITHUB_ISSUE_TEMPLATE", GITHUB_ISSUE_TEMPLATE_DEFAULT);

    /// The client id key used to anonymize client connections.
    pub(crate) static ref CLIENT_ID_KEY: StringEnvVar = StringEnvVar::new("CLIENT_ID_KEY", CLIENT_ID_KEY_DEFAULT);

    /// A List of servers to provideThe client id key used to anonymize client connections.
    pub(crate) static ref API_HOST_NAMES: StringEnvVar = StringEnvVar::new("API_HOST_NAMES", API_HOST_NAMES_DEFAULT);

    /// The base path the API is served at.
    pub(crate) static ref API_URL_PREFIX: StringEnvVar = StringEnvVar::new("API_URL_PREFIX", API_URL_PREFIX_DEFAULT);


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

/// Get a list of all host names to serve the API on.
///
/// Used by the `OpenAPI` Documentation to point to the correct backend.
/// Take a list of [scheme://] + host names from the env var and turns it into
/// a lits of strings.
///
/// Host names are taken from the `API_HOST_NAMES` environment variable.
/// If that is not set, `addr` is used.
pub(crate) fn get_api_host_names(addr: &SocketAddr) -> Vec<String> {
    string_to_api_host_names(addr, API_HOST_NAMES.as_str())
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
        GITHUB_REPO_OWNER.as_str(),
        GITHUB_REPO_NAME.as_str()
    );

    match Url::parse_with_params(&path, &[
        ("template", GITHUB_ISSUE_TEMPLATE.as_str()),
        ("title", title),
    ]) {
        Ok(url) => Some(url),
        Err(e) => {
            error!(err = e.to_string(); "Failed to generate github issue url");
            None
        },
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn github_repo_name_default() {
        assert_eq!(GITHUB_REPO_NAME.as_str(), GITHUB_REPO_NAME_DEFAULT);
    }

    #[test]
    fn generate_github_issue_url_test() {
        let title = "Hello, World! How are you?";
        assert_eq!(
            generate_github_issue_url(title).expect("Failed to generate url").as_str(),
            "https://github.com/input-output-hk/catalyst-voices/issues/new?template=bug_report.yml&title=Hello%2C+World%21+How+are+you%3F"
        );
    }

    #[test]
    fn configured_hosts_default() {
        let configured_hosts = get_api_host_names(&SocketAddr::from(([127, 0, 0, 1], 8080)));
        assert_eq!(configured_hosts, vec![
            "https://api.prod.projectcatalyst.io"
        ]);
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
