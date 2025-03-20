//! TODO: FIXME:

use poem_openapi::{types::Example, Object};

///  TODO: FIXME:
#[derive(Object, Debug, Clone)]
pub(crate) struct KeyData {}

// KeyData {
//     time,
//     key: Option<key>,
//     c509: Option<cert>,
//     x509: Option<cert>,
// }
// /// A persistent flag.
// ///
// /// If it is equal to `true` then the role data is permanent and won't be changed.
// is_persistent: bool,

impl Example for KeyData {
    fn example() -> Self {
        Self {}
    }
}
