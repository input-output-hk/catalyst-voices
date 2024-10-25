//! Configuration Endpoints

use std::{net::IpAddr, str::FromStr};

use jsonschema::BasicOutput;
use poem::web::RealIp;
use poem_openapi::{param::Query, payload::Json, ApiResponse, Object, OpenApi};
use serde_json::Value;
use tracing::error;

use crate::{
    db::event::config::{key::ConfigKey, Config},
    service::common::{responses::WithErrorResponses, tags::ApiTags},
};

/// Configuration API struct
pub(crate) struct ConfigApi;

/// Frontend JSON schema
#[derive(Object, Default, serde::Deserialize)]
struct FrontendConfig {
    /// Sentry properties.
    sentry: Option<Sentry>,
}

/// Frontend configuration for Sentry
#[derive(Object, Default, serde::Deserialize)]
struct Sentry {
    /// The Data Source Name (DSN) for Sentry.
    #[oai(validator(max_length = "100", pattern = "^https?://"))]
    dsn: String,
    /// A version of the code deployed to an environment.
    #[oai(validator(max_length = "100", pattern = "^[0-9a-zA-Z].*$"))]
    release: Option<String>,
    /// The environment in which the application is running, e.g., 'dev', 'qa'.
    #[oai(validator(max_length = "100", pattern = "^[0-9a-zA-Z].*$"))]
    environment: Option<String>,
}

/// Get configuration endpoint responses.
#[derive(ApiResponse)]
enum GetConfigResponses {
    /// Configuration result.
    #[oai(status = 200)]
    Ok(Json<FrontendConfig>),
}
/// Get configuration all responses.
type GetConfigAllResponses = WithErrorResponses<GetConfigResponses>;

/// Get configuration schema endpoint responses.
#[derive(ApiResponse)]
enum GetConfigSchemaResponses {
    /// Configuration result.
    #[oai(status = 200)]
    Ok(Json<Value>),
}
/// Get configuration schema all responses.
type GetConfigSchemaAllResponses = WithErrorResponses<GetConfigSchemaResponses>;

/// Set configuration endpoint responses.
#[derive(ApiResponse)]
enum SetConfigResponse {
    /// Configuration Update Successful.
    #[oai(status = 204)]
    Ok,
    /// Set configuration bad request.
    #[oai(status = 400)]
    BadRequest(Json<ConfigBadRequest>),
}
/// Set configuration all responses.
type SetConfigAllResponses = WithErrorResponses<SetConfigResponse>;

/// Bad request errors
#[derive(Object, Default)]
struct ConfigBadRequest {
    /// Error messages.
    #[oai(validator(max_length = "100", pattern = "^[0-9a-zA-Z].*$"))]
    error: String,
    /// Optional schema validation errors.
    #[oai(validator(max_items = "1000", max_length = "9999", pattern = "^[0-9a-zA-Z].*$"))]
    schema_validation_errors: Option<Vec<String>>,
}

#[OpenApi(tag = "ApiTags::Config")]
impl ConfigApi {
    /// Get the configuration for the frontend.
    ///
    /// Retrieving IP from X-Real-IP, Forwarded, X-Forwarded-For or Remote Address.
    #[oai(
        path = "/draft/config/frontend",
        method = "get",
        operation_id = "get_config_frontend"
    )]
    async fn get_frontend(&self, ip_address: RealIp) -> GetConfigAllResponses {
        // Fetch the general configuration
        let general_config = Config::get(ConfigKey::Frontend).await;

        // Attempt to fetch the IP configuration
        let ip_config = if let Some(ip) = ip_address.0 {
            match Config::get(ConfigKey::FrontendForIp(ip)).await {
                Ok(value) => Some(value),
                Err(err) => {
                    error!(id="get_frontend_config_ip", error=?err, "Failed to get frontend configuration for IP");
                    return GetConfigAllResponses::handle_error(&err);
                },
            }
        } else {
            None
        };

        // Handle the response
        match general_config {
            Ok(general) => {
                // If there is IP specific config, replace any key in the general config with
                // the keys from the IP specific config
                let response_config = if let Some(ip_specific) = ip_config {
                    merge_configs(&general, &ip_specific)
                } else {
                    general
                };

                // Convert the merged Value to FrontendConfig
                let frontend_config: FrontendConfig =
                    serde_json::from_value(response_config).unwrap_or_default(); // Handle error as needed

                GetConfigResponses::Ok(Json(frontend_config)).into()
            },
            Err(err) => {
                error!(id="get_frontend_config_general", error=?err, "Failed to get general frontend configuration");
                GetConfigAllResponses::handle_error(&err)
            },
        }
    }

    /// Get the frontend JSON schema.
    ///
    /// Returns the JSON schema which defines the data which can be read or written for
    /// the frontend configuration.
    #[oai(
        path = "/draft/config/frontend/schema",
        method = "get",
        operation_id = "get_config_frontend_schema"
    )]
    #[allow(clippy::unused_async)]
    async fn get_frontend_schema(&self) -> GetConfigSchemaAllResponses {
        // Schema for both IP specific and general are identical
        GetConfigSchemaResponses::Ok(Json(ConfigKey::Frontend.schema().clone())).into()
    }

    /// Set the frontend configuration.
    ///
    /// Store the given config as either global front end configuration, or configuration
    /// for a client at a specific IP address.
    #[oai(
        path = "/draft/config/frontend",
        method = "put",
        operation_id = "put_config_frontend"
    )]
    async fn put_frontend(
        &self,
        /// *OPTIONAL* The IP Address to set the configuration for.
        #[oai(name = "IP")]
        ip_query: Query<Option<String>>,
        body: Json<Value>,
    ) -> SetConfigAllResponses {
        let body_value = body.0;

        match ip_query.0 {
            Some(ip) => {
                match IpAddr::from_str(&ip) {
                    Ok(parsed_ip) => set(ConfigKey::FrontendForIp(parsed_ip), body_value).await,
                    Err(err) => {
                        SetConfigResponse::BadRequest(Json(ConfigBadRequest {
                            error: format!("Invalid IP address: {err}"),
                            schema_validation_errors: None,
                        }))
                        .into()
                    },
                }
            },
            None => set(ConfigKey::Frontend, body_value).await,
        }
    }
}

/// Helper function to merge two JSON values.
fn merge_configs(general: &Value, ip_specific: &Value) -> Value {
    let mut merged = general.clone();

    if let Some(ip_specific_obj) = ip_specific.as_object() {
        if let Some(merged_obj) = merged.as_object_mut() {
            for (key, value) in ip_specific_obj {
                if let Some(existing_value) = merged_obj.get_mut(key) {
                    *existing_value = value.clone();
                } else {
                    merged_obj.insert(key.clone(), value.clone());
                }
            }
        }
    }

    merged
}

/// Helper function to handle set.
async fn set(key: ConfigKey, value: Value) -> SetConfigAllResponses {
    match Config::set(key, value).await {
        Ok(validate) => {
            match validate {
                BasicOutput::Valid(_) => SetConfigResponse::Ok.into(),
                BasicOutput::Invalid(errors) => {
                    let schema_errors: Vec<String> = errors
                        .iter()
                        .map(|error| error.error_description().clone().into_inner())
                        .collect();
                    SetConfigResponse::BadRequest(Json(ConfigBadRequest {
                        error: "Invalid JSON data validating against JSON schema".to_string(),
                        schema_validation_errors: Some(schema_errors),
                    }))
                    .into()
                },
            }
        },
        Err(err) => {
            error!(id="set_config_frontend", error=?err, "Failed to set frontend configuration");
            SetConfigAllResponses::handle_error(&err)
        },
    }
}
