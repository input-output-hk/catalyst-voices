//! Catalyst Gateway API Definition
//!
//! This defines all endpoints for the Catalyst Gateway API.
//! It however does NOT contain any processing for them, that is defined elsewhere.
use std::net::IpAddr;

use gethostname::gethostname;
use health::HealthApi;
use legacy::LegacyApi;
use local_ip_address::list_afinet_netifas;
use poem_openapi::{ContactObject, LicenseObject, OpenApiService, ServerObject};
use test_endpoints::TestApi;

use crate::settings::{DocsSettings, API_URL_PREFIX};

mod health;
mod legacy;
mod test_endpoints;

/// The name of the API
const API_TITLE: &str = "Catalyst Gateway";

/// The version of the API
const API_VERSION: &str = "1.2.0";

/// Get the contact details for inquiring about the API
fn get_api_contact() -> ContactObject {
    ContactObject::new()
        .name("Project Catalyst Team")
        .email("contact@projectcatalyst.io")
        .url("https://projectcatalyst.io")
}

/// A long description of the API. Markdown is supported
const API_DESCRIPTION: &str = "# Catalyst Gateway API.

The Catalyst Gateway API provides realtime data for all prior, current and future Catalyst voting events.

TODO:

* Implement Permissionless Auth.
* Implement Replacement Functionality for GVC.
* Implement representative registration on main-chain, distinct from voter registration.
* Implement Voting API abstracting the Jormungandr API from public exposure.
* Implement Audit API's (Retrieve voting blockchain records,  registration/voting power audit and private tally audit.
* Implement API's needed to support posting Ideas/Proposals etc.Catalyst Gateway
";

/// Get the license details for the API
fn get_api_license() -> LicenseObject {
    LicenseObject::new("Apache 2.0").url("https://www.apache.org/licenses/LICENSE-2.0")
}

/// Get the terms of service for the API
const TERMS_OF_SERVICE: &str =
    "https://github.com/input-output-hk/catalyst-voices/blob/main/CODE_OF_CONDUCT.md";

/// Create the `OpenAPI` definition
pub(crate) fn mk_api(
    hosts: Vec<String>, settings: &DocsSettings,
) -> OpenApiService<(TestApi, HealthApi, LegacyApi), ()> {
    let mut service = OpenApiService::new(
        (
            TestApi,
            HealthApi,
            (legacy::RegistrationApi, legacy::V0Api, legacy::V1Api),
        ),
        API_TITLE,
        API_VERSION,
    )
    .contact(get_api_contact())
    .description(API_DESCRIPTION)
    .license(get_api_license())
    .terms_of_service(TERMS_OF_SERVICE)
    .url_prefix(API_URL_PREFIX.as_str());

    // Retrieve the port from the socket address
    let port = settings.address.port().to_string();

    let server_name = &settings.server_name;

    for host in hosts {
        service = service.server(ServerObject::new(host).description("API Host"));
    }

    // Add server name if it is set
    if let Some(name) = server_name {
        service = service.server(ServerObject::new(name).description("Server at server name"));
    }

    // Get localhost name
    if let Ok(hostname) = gethostname().into_string() {
        let hostname_addresses = add_protocol_prefix(
            &format!("{hostname}:{port}"),
            settings.http_auto_servers,
            settings.https_auto_servers,
        );
        for hostname_address in hostname_addresses {
            service = service.server(
                ServerObject::new(hostname_address).description("Server at localhost name"),
            );
        }
    }

    // Get local IP address v4 and v6
    if let Ok(network_interfaces) = list_afinet_netifas() {
        for (name, ip) in &network_interfaces {
            if *name == "en0" {
                let (ip_with_port, desc) = match ip {
                    IpAddr::V4(_) => (format!("{ip}:{port}"), "Server at local IPv4 address"),
                    IpAddr::V6(_) => (format!("[{ip}]:{port}"), "Server at local IPv6 address"),
                };
                let ip_addresses = add_protocol_prefix(
                    &ip_with_port,
                    settings.http_auto_servers,
                    settings.https_auto_servers,
                );
                for address in ip_addresses {
                    service = service.server(ServerObject::new(address).description(desc));
                }
            }
        }
    }
    service
}

/// Function to add protocol prefix based on flags.
fn add_protocol_prefix(address: &String, is_http: bool, is_https: bool) -> Vec<String> {
    let mut addresses = Vec::new();
    if is_http {
        addresses.push(format!("http://{address}"));
    }
    if is_https {
        addresses.push(format!("https://{address}"));
    }
    addresses
}
