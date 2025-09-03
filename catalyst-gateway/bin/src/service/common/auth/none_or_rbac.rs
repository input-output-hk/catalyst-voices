//! Either has No Authorization, or RBAC Token.

use poem::{
    web::headers::{authorization::Bearer, Authorization, HeaderMapExt},
    Request, RequestBody,
};
use poem_openapi::{registry::Registry, ApiExtractor, ApiExtractorType, ExtractParamOptions};

use super::{
    none::NoAuthorization,
    rbac::{scheme::CatalystRBACSecurityScheme, token::CatalystRBACTokenV1},
};

#[allow(dead_code, clippy::upper_case_acronyms, clippy::large_enum_variant)]
/// Endpoint allows Authorization with or without RBAC Token.
pub(crate) enum NoneOrRBAC {
    /// Has RBAC Token.
    RBAC(CatalystRBACSecurityScheme),
    /// Has No Authorization.
    None(NoAuthorization),
}

impl<'a> ApiExtractor<'a> for NoneOrRBAC {
    type ParamRawType = ();
    type ParamType = ();

    const TYPES: &'static [ApiExtractorType] = &[ApiExtractorType::SecurityScheme];

    fn register(registry: &mut Registry) {
        CatalystRBACSecurityScheme::register(registry);
        NoAuthorization::register(registry);
    }

    fn security_schemes() -> Vec<&'static str> {
        let mut schemas = Vec::new();
        schemas.extend(CatalystRBACSecurityScheme::security_schemes());
        schemas.extend(NoAuthorization::security_schemes());
        schemas
    }

    async fn from_request(
        req: &'a Request,
        body: &mut RequestBody,
        param_opts: ExtractParamOptions<Self::ParamType>,
    ) -> poem::Result<Self> {
        if req.headers().typed_get::<Authorization<Bearer>>().is_some() {
            let auth = CatalystRBACSecurityScheme::from_request(req, body, param_opts).await?;
            Ok(NoneOrRBAC::RBAC(auth))
        } else {
            Ok(NoneOrRBAC::None(NoAuthorization))
        }
    }
}

impl From<NoneOrRBAC> for Option<CatalystRBACTokenV1> {
    fn from(value: NoneOrRBAC) -> Self {
        match value {
            NoneOrRBAC::RBAC(auth) => Some(auth.into()),
            NoneOrRBAC::None(_) => None,
        }
    }
}
