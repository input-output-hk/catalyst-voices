//! Configuration Endpoints

use std::{net::IpAddr, str::FromStr};

use poem_openapi::{param::Path, payload::Json, ApiResponse, Multipart, OpenApi};

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

/// Configuration insert request
#[derive(Multipart)]
struct ConfigInsertRequest {
    /// ID1 of config table
    id1: String,
    /// ID2 of config table
    id2: Option<String>,
    /// ID3 of config table
    id3: Option<String>,
    /// Value of config table
    value: String,
}

#[OpenApi(prefix_path = "/config", tag = "ApiTags::Config")]
impl ConfigApi {
    /// Get the general configuration
    #[oai(path = "/", method = "get", operation_id = "get_general_config")]
    async fn get_general(&self) -> Responses {
        match Config::get(ConfigKey::Frontend).await {
            Ok(config) => Responses::Ok(Json(config.to_string())),
            Err(err) => Responses::NotFound(Json(err.to_string())),
        }
    }

    /// Get configuration for a specific IP
    #[oai(path = "/:ip", method = "get", operation_id = "get_ip_config")]
    async fn get_with_ip(&self, ip: Path<String>) -> Responses {
        match IpAddr::from_str(&ip.0) {
            Ok(parsed_ip) => {
                match Config::get(ConfigKey::FrontendForIp(parsed_ip)).await {
                    Ok(config) => Responses::Ok(Json(config.to_string())),
                    Err(err) => Responses::NotFound(Json(err.to_string())),
                }
            },
            Err(err) => Responses::BadRequest(Json(format!("Invalid IP address: {err}"))),
        }
    }

    /// Insert configuration
    #[oai(path = "/insert", method = "post", operation_id = "insert_config")]
    async fn insert(&self, payload: ConfigInsertRequest) -> Responses {
        let config_key = ConfigKey::from_id(
            &payload.id1,
            &payload.id2.unwrap_or_default(),
            &payload.id3.unwrap_or_default(),
        );

        if let Some(config_key) = config_key {
            match serde_json::from_str(&payload.value) {
                Ok(parsed_value) => {
                    match Config::insert(config_key, parsed_value).await {
                        Ok(()) => {
                            Responses::Ok(Json("Configuration inserted successfully.".to_string()))
                        },
                        Err(err) => {
                            Responses::BadRequest(Json(format!(
                                "Failed to insert configuration: {err}"
                            )))
                        },
                    }
                },
                Err(err) => {
                    Responses::BadRequest(Json(format!("Failed to parse JSON value: {err}")))
                },
            }
        } else {
            Responses::BadRequest(Json(
                "Invalid configuration key derives from ids.".to_string(),
            ))
        }
    }
}
