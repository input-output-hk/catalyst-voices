//! Configuration Endpoints

use std::{net::IpAddr, str::FromStr};

use poem::web::RealIp;
use poem_openapi::{param::Query, payload::Json, ApiResponse, OpenApi};
use serde_json::Value;
use tracing::info;

use crate::{
    db::event::config::{key::ConfigKey, Config},
    service::common::tags::ApiTags,
};

/// Configuration API struct
pub(crate) struct ConfigApi;

/// Endpoint responses
#[derive(ApiResponse)]
enum Responses {
    /// Configuration result
    #[oai(status = 200)]
    Ok(Json<String>),
    /// Configuration not found
    #[oai(status = 404)]
    NotFound(Json<String>),
    /// Bad request
    #[oai(status = 400)]
    BadRequest(Json<String>),
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
    async fn get_frontend(&self, ip_address: RealIp) -> Responses {
        info!("IP Address: {:?}", ip_address.0);

        // Fetch the general configuration
        let general_config = Config::get(ConfigKey::Frontend).await;

        // Attempt to fetch the IP configuration
        let ip_config = if let Some(ip) = ip_address.0 {
            Config::get(ConfigKey::FrontendForIp(ip)).await.ok()
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

                Responses::Ok(Json(response_config.to_string()))
            },
            Err(err) => Responses::NotFound(Json(err.to_string())),
        }
    }

    /// Set the frontend configuration.
    #[oai(
        path = "/draft/config/frontend",
        method = "put",
        operation_id = "put_config_frontend"
    )]
    async fn put_frontend(
        &self, #[oai(name = "IP")] ip_query: Query<Option<String>>, body: Json<Value>,
    ) -> Responses {
        let body_value = body.0;

        match ip_query.0 {
            Some(ip) => {
                match IpAddr::from_str(&ip) {
                    Ok(parsed_ip) => set(ConfigKey::FrontendForIp(parsed_ip), body_value).await,
                    Err(err) => Responses::BadRequest(Json(format!("Invalid IP address: {err}"))),
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
async fn set(key: ConfigKey, value: Value) -> Responses {
    match Config::set(key, value).await {
        Ok(()) => Responses::Ok(Json("Configuration successfully set.".to_string())),
        Err(err) => Responses::BadRequest(Json(format!("Failed to set configuration: {err}"))),
    }
}
