//! JSON related utilities.

use serde_json::{json, Value};
use tracing::error;

/// Convert a JSON string to a JSON value.
pub(crate) fn load_json(data: &str) -> Value {
    serde_json::from_str(data).unwrap_or_else(|err| {
        error!(id="load_json", error=?err, "Error parsing JSON");
        json!({})
    })
}

/// Serialize a JSON value to a byte vector.
pub(crate) fn serialize_to_bytes(value: &Value) -> Vec<u8> {
    serde_json::to_vec(value).unwrap_or_else(|err| {
        error!(id="json_serialize_to_bytes", error=?err, "Error serializing JSON");
        vec![]
    })
}
