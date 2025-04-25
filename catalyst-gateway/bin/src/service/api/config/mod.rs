//! Configuration Endpoints

use poem::web::RealIp;
use poem_openapi::{param::Query, payload::Json, types::Example, ApiResponse, NewType, OpenApi};
use serde_json::Value;
use tracing::error;

use crate::{
    db::event::{
        config::{key::ConfigKey, Config},
        error::NotFoundError,
    },
    service::common::{
        auth::{api_key::InternalApiKeyAuthorization, none_or_rbac::NoneOrRBAC},
        responses::WithErrorResponses,
        tags::ApiTags,
    },
};

/// Configuration API struct
pub(crate) struct ConfigApi;

/// Get configuration endpoint responses.
#[derive(ApiResponse)]
enum GetConfigResponses {
    /// Configuration result.
    #[oai(status = 200)]
    Ok(Json<Value>),

    /// No frontend config.
    #[oai(status = 404)]
    NotFound,
}
/// Get configuration all responses.
type GetConfigAllResponses = WithErrorResponses<GetConfigResponses>;

/// Set configuration endpoint responses.
#[derive(ApiResponse)]
enum SetConfigResponse {
    /// Configuration Update Successful.
    #[oai(status = 204)]
    Ok,
}
/// Set configuration all responses.
type SetConfigAllResponses = WithErrorResponses<SetConfigResponse>;

#[derive(NewType)]
#[oai(example = true)]
/// IP Address.
pub(crate) struct IpAddr(std::net::IpAddr);

impl Example for IpAddr {
    fn example() -> Self {
        Self(std::net::IpAddr::V4(std::net::Ipv4Addr::new(
            192, 168, 10, 15,
        )))
    }
}

#[OpenApi(tag = "ApiTags::Config")]
impl ConfigApi {
    /// Get the configuration for the frontend.
    ///
    /// Get the frontend configuration for the requesting client.
    ///
    /// ### Security
    ///
    /// Does not require any Catalyst RBAC Token to access.
    #[oai(
        path = "/v1/config/frontend",
        method = "get",
        operation_id = "get_config_frontend"
    )]
    async fn get_frontend(&self, ip_address: RealIp, _auth: NoneOrRBAC) -> GetConfigAllResponses {
        let general_config = match Config::get(ConfigKey::Frontend).await {
            Ok(value) => Some(value),
            Err(err) if err.is::<NotFoundError>() => None,
            Err(err) => {
                error!(id="get_frontend_config_general", error=?err, "Failed to get general frontend configuration");
                return GetConfigAllResponses::handle_error(&err);
            },
        };

        // Attempt to fetch the IP configuration
        let ip_config = if let Some(ip) = ip_address.0 {
            match Config::get(ConfigKey::FrontendForIp(ip)).await {
                Ok(value) => Some(value),
                Err(err) if err.is::<NotFoundError>() => None,
                Err(err) => {
                    error!(id="get_frontend_config_ip", error=?err, "Failed to get frontend configuration for IP");
                    return GetConfigAllResponses::handle_error(&err);
                },
            }
        } else {
            None
        };

        match (general_config, ip_config) {
            (Some(general_config), Some(ip_config)) => {
                let config = merge_configs(&general_config, &ip_config);
                GetConfigResponses::Ok(Json(config)).into()
            },
            (Some(general_config), None) => GetConfigResponses::Ok(Json(general_config)).into(),
            (None, Some(ip_config)) => GetConfigResponses::Ok(Json(ip_config)).into(),
            (None, None) => GetConfigResponses::NotFound.into(),
        }
    }

    /// Set the frontend configuration.
    ///
    /// Store the given config as either global front end configuration, or configuration
    /// for a client at a specific IP address.
    ///
    /// ### Security
    ///
    /// Requires Admin Authoritative RBAC Token.
    #[oai(
        path = "/v1/config/frontend",
        method = "put",
        operation_id = "put_config_frontend",
        hidden = true
    )]
    async fn put_frontend(
        &self,
        /// *OPTIONAL* The IP Address to set the configuration for.
        #[oai(name = "IP")]
        Query(ip_query): Query<Option<IpAddr>>,
        Json(json_config): Json<Value>, _auth: InternalApiKeyAuthorization,
    ) -> SetConfigAllResponses {
        match ip_query {
            Some(ip) => set(ConfigKey::FrontendForIp(ip.0), json_config).await,
            None => set(ConfigKey::Frontend, json_config).await,
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
        Ok(()) => SetConfigResponse::Ok.into(),
        Err(err) => {
            error!(id="set_config_frontend", error=?err, "Failed to set frontend configuration");
            SetConfigAllResponses::handle_error(&err)
        },
    }
}
