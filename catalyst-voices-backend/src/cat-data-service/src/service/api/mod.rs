//! Catalyst Data Service API Definition
//!
//! This defines all endpoints for the Catalyst Data Service API.
//! It however does NOT contain any processing for them, that is defined elsewhere.
use crate::settings::API_URL_PREFIX;
use health::HealthApi;
use poem_openapi::{ContactObject, LicenseObject, OpenApiService, ServerObject};
use registration::RegistrationApi;
use test_endpoints::TestApi;

mod health;
mod registration;
mod test_endpoints;

/// The name of the API
const API_TITLE: &str = "Catalyst Data Service";

/// The version of the API
const API_VERSION: &str = "1.2.0";

/// Get the contact details for inquiring about the API
fn get_api_contact() -> ContactObject {
    ContactObject::new()
        .name("Project Catalyst Team")
        .email("contact@projectcatalyst.io")
        .url("https://projectcatalyst.io")
}

/// A summary describing the API
const API_SUMMARY: &str = "Project Catalyst Data Service API";

/// A long description of the API. Markdown is supported
const API_DESCRIPTION: &str = r#"# Catalyst Data Service API.

The Catalyst Data Service API provides realtime data for all prior, current and future Catalyst voting events.

TODO:

* Implement Permissionless Auth.
* Implement Replacement Functionality for GVC.
* Implement representative registration on main-chain, distinct from voter registration.
* Implement Voting API abstracting the Jormungandr API from public exposure.
* Implement Audit API's (Retrieve voting blockchain records,  registration/voting power audit and private tally audit.
* Implement API's needed to support posting Ideas/Proposals etc.Catalyst Data Service
"#;

/// Get the license details for the API
fn get_api_license() -> LicenseObject {
    LicenseObject::new("Apache 2.0")
        .url("https://www.apache.org/licenses/LICENSE-2.0")
        .identifier("Apache-2.0")
}

/// Get the terms of service for the API
const TERMS_OF_SERVICE: &str =
    "https://github.com/input-output-hk/catalyst-core/blob/main/book/src/98_CODE_OF_CONDUCT.md";

/// Create the OpenAPI definition
pub(crate) fn mk_api(
    hosts: Vec<String>,
) -> OpenApiService<(TestApi, HealthApi, RegistrationApi), ()> {
    let mut service = OpenApiService::new(
        (TestApi, HealthApi, RegistrationApi),
        API_TITLE,
        API_VERSION,
    )
    .contact(get_api_contact())
    .description(API_DESCRIPTION)
    .license(get_api_license())
    .summary(API_SUMMARY)
    .terms_of_service(TERMS_OF_SERVICE)
    .url_prefix(API_URL_PREFIX.as_str());

    // Add all the hosts where this API should be reachable.
    for host in hosts {
        service = service.server(ServerObject::new(host));
    }

    service
}
