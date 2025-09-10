//! OpenAPI Object for Problem Report

use poem_openapi::Object;

/// Represents an OpenAPI object for Problem Report.
#[derive(Object, Default)]
// #[oai(example = true)]
pub(crate) struct ErrorReport {
    /// The kind of problem we are recording.
    pub(crate) kind: String,
    /// The message describing the problem.
    pub(crate) msg: String,
    /// The field name that causes the problem.
    #[oai(skip_serializing_if_is_none)]
    pub(crate) field: Option<String>,
    /// The value of the field.
    #[oai(skip_serializing_if_is_none)]
    pub(crate) value: Option<String>,
    /// The constraint of what is expected for a valid value
    #[oai(skip_serializing_if_is_none)]
    pub(crate) constraint: Option<String>,
    /// Detected encoding
    #[oai(skip_serializing_if_is_none)]
    pub(crate) encoded: Option<String>,
    /// Expected encoding
    #[oai(skip_serializing_if_is_none)]
    pub(crate) expected: Option<String>,
    #[oai(skip_serializing_if_is_none)]
    /// Explanation of the failed or problematic validation
    pub(crate) explanation: Option<String>,
    #[oai(skip_serializing_if_is_none)]
    /// Additional information about the duplicate field.
    pub(crate) description: Option<String>,
    #[oai(skip_serializing_if_is_none)]
    /// The type that the value was expected to convert to
    pub(crate) expected_type: Option<String>,
}
