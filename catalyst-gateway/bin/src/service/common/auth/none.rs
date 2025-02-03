//! None authorization scheme.
//!
//! Means the API Endpoint does not need to use any Auth.

/// Endpoint can be used without any authorization.
#[allow(dead_code)]
pub(crate) struct NoAuthorization();

impl<'a> poem_openapi::ApiExtractor<'a> for NoAuthorization {
    type ParamRawType = ();
    type ParamType = ();

    const TYPES: &'static [poem_openapi::ApiExtractorType] =
        &[poem_openapi::ApiExtractorType::SecurityScheme];

    fn register(registry: &mut poem_openapi::registry::Registry) {
        registry.create_security_scheme(
            "NoAuthorization",
            poem_openapi::registry::MetaSecurityScheme {
                ty: "http",
                description: Some("Endpoint can be used without any authorization."),
                name: None,
                key_in: None,
                scheme: Some("none"),
                bearer_format: None,
                flows: None,
                openid_connect_url: None,
            },
        );
    }

    fn security_schemes() -> Vec<&'static str> {
        vec!["NoAuthorization"]
    }

    async fn from_request(
        _req: &'a poem::Request, _body: &mut poem::RequestBody,
        _param_opts: poem_openapi::ExtractParamOptions<Self::ParamType>,
    ) -> poem::Result<Self> {
        Ok(Self())
    }
}
