//! Either has No Authorization, or RBAC Token.

use poem_openapi::SecurityScheme;

use super::{
    none::NoAuthorization,
    rbac::{scheme::CatalystRBACSecurityScheme, token::CatalystRBACTokenV1},
};

#[derive(SecurityScheme)]
#[allow(dead_code, clippy::upper_case_acronyms, clippy::large_enum_variant)]
/// Endpoint allows Authorization with or without RBAC Token.
pub(crate) enum NoneOrRBAC {
    /// Has RBAC Token.
    RBAC(CatalystRBACSecurityScheme),
    /// Has No Authorization.
    None(NoAuthorization),
}

impl From<NoneOrRBAC> for Option<CatalystRBACTokenV1> {
    fn from(value: NoneOrRBAC) -> Self {
        match value {
            NoneOrRBAC::RBAC(auth) => Some(auth.into()),
            NoneOrRBAC::None(_) => None,
        }
    }
}
