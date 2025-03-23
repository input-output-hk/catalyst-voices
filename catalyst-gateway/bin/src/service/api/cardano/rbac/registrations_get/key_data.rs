//! A role data key information.

use chrono::{DateTime, Utc};
use poem_openapi::{types::Example, Object};
use rbac_registration::cardano::cip509::KeyLocalRef;

use crate::service::common::types::generic::{
    boolean::BooleanFlag, date_time::DateTime as ServiceDateTime,
};

/// A role data key information.
///
/// TODO: FIXME: Add a note that only one key/c509/x509 field can be present.
#[derive(Object, Debug, Clone)]
pub struct KeyData {
    /// Indicates if the data is persistent or volatile.
    is_persistent: BooleanFlag,
    /// A time when the address was added.
    time: ServiceDateTime,
    // TODO: FIXME: key/c509/x509 fields.
}

impl KeyData {
    /// Creates a new `KeyData` instance.
    pub fn new(is_persistent: bool, time: DateTime<Utc>, key_ref: Option<&KeyLocalRef>) -> Self {
        Self {
            is_persistent: is_persistent.into(),
            time: time.into(),
        }
    }
}

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
        Self {
            is_persistent: BooleanFlag::example(),
            time: ServiceDateTime::example(),
        }
    }
}
