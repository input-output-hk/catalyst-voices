//! Configuration Endpoints

use poem::web::RealIp;
use poem_openapi::{param::Query, payload::Json, ApiResponse, OpenApi};
use serde_json::{Map, Value};
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
        types::generic::{ip_addr::IpAddr, json_object::JsonObject},
    },
};

/// Configuration API struct
pub(crate) struct ConfigApi;

/// Get configuration endpoint responses.
#[derive(ApiResponse)]
enum GetConfigResponses {
    /// Configuration result.
    #[oai(status = 200)]
    Ok(Json<JsonObject>),

    /// No frontend config defined.
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
        let general_config: JsonObject = match Config::get(ConfigKey::Frontend)
            .await
            .and_then(TryInto::try_into)
        {
            Ok(value) => value,
            Err(err) if err.is::<NotFoundError>() => return GetConfigResponses::NotFound.into(),
            Err(err) => {
                error!(id="get_frontend_config_general", error=?err, "Failed to get general frontend configuration");
                return GetConfigAllResponses::handle_error(&err);
            },
        };

        // Attempt to fetch the IP configuration
        let ip_config: Option<JsonObject> = if let Some(ip) = ip_address.0 {
            match Config::get(ConfigKey::FrontendForIp(ip))
                .await
                .and_then(TryInto::try_into)
            {
                Ok(value) => Some(value),
                Err(err) if err.is::<NotFoundError>() => None,
                Err(err) => {
                    error!(id = "get_frontend_config_ip", error = ?err, "Failed to get frontend configuration for IP");
                    return GetConfigAllResponses::handle_error(&err);
                },
            }
        } else {
            None
        };
        if let Some(ip_config) = ip_config {
            let config = merge_configs(general_config, ip_config);
            GetConfigResponses::Ok(Json(config)).into()
        } else {
            GetConfigResponses::Ok(Json(general_config)).into()
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
        Query(ip_address): Query<Option<IpAddr>>,
        Json(json_config): Json<JsonObject>, _auth: InternalApiKeyAuthorization,
    ) -> SetConfigAllResponses {
        if let Some(ip) = ip_address {
            set(ConfigKey::FrontendForIp(ip.into()), json_config.into()).await
        } else {
            set(ConfigKey::Frontend, json_config.into()).await
        }
    }
}

/// Helper function to merge two JSON values.
fn merge_configs(general: JsonObject, ip_specific: JsonObject) -> JsonObject {
    let mut merged = general;

    for (key, value) in Map::<String, Value>::from(ip_specific) {
        if let Some(existing_value) = merged.get_mut(&key) {
            *existing_value = value;
        } else {
            merged.insert(key, value);
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
