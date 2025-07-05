//! A RBAC context used during indexing.

/// A RBAC context used during indexing.
///
/// During indexing the information is written to the database only after processing the
/// whole block. If there are multiple RBAC registrations in one block, then when
/// validating subsequent transactions we wouldn't be able to find information about the
/// previous ones in the database. This context is used to hold such information during
/// block processing in order to mitigate that issue.
pub struct RbacIndexingContext {
    //  TODO: FIXME:
}

impl RbacIndexingContext {
    /// Creates a new context issue.
    pub fn new() -> Self {
        Self {}
    }
}
