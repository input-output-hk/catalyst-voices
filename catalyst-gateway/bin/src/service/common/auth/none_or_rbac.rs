//! Either has No Authorization, or RBAC Token.

use poem_openapi::SecurityScheme;

use super::{none::NoAuthorization, rbac::scheme::CatalystRBACSecurityScheme};

#[derive(SecurityScheme)]
#[allow(dead_code, clippy::upper_case_acronyms)]
/// Endpoint allows Authorization with or without RBAC Token.
pub(crate) enum NoneOrRBAC {
    /// Has RBAC Token.
    RBAC(CatalystRBACSecurityScheme),
    /// Has No Authorization.
    None(NoAuthorization),
}
