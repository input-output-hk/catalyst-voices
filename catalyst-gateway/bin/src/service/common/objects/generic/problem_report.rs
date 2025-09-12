//! OpenAPI Objects for Problem Report

use catalyst_types::problem_report;
use poem_openapi::{
    types::{Example, ToJSON},
    Object,
};

use crate::service::common::types::array_types::impl_array_types;

/// Represents an OpenAPI object for a Problem Report entry.
#[derive(Debug, Clone, Object, Default)]
#[oai(example = true)]
pub(crate) struct ProblemReportEntry {
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

impl From<problem_report::Entry> for ProblemReportEntry {
    fn from(value: problem_report::Entry) -> Self {
        let default = Self {
            msg: value.context().clone(),
            ..Default::default()
        };

        match value.kind() {
            problem_report::Kind::MissingField { field } => {
                Self {
                    kind: "MissingField".to_string(),
                    field: Some(field).cloned(),
                    ..default
                }
            },
            problem_report::Kind::UnknownField { field, value } => {
                Self {
                    kind: "UnknownField".to_string(),
                    field: Some(field).cloned(),
                    value: Some(value).cloned(),
                    ..default
                }
            },
            problem_report::Kind::InvalidValue {
                field,
                value,
                constraint,
            } => {
                Self {
                    kind: "InvalidValue".to_string(),
                    field: Some(field).cloned(),
                    value: Some(value).cloned(),
                    constraint: Some(constraint).cloned(),
                    ..default
                }
            },
            problem_report::Kind::InvalidEncoding {
                field,
                encoded,
                expected,
            } => {
                Self {
                    kind: "InvalidEncoding".to_string(),
                    field: Some(field).cloned(),
                    encoded: Some(encoded).cloned(),
                    expected: Some(expected).cloned(),
                    ..default
                }
            },
            problem_report::Kind::FunctionalValidation { explanation } => {
                Self {
                    kind: "FunctionalValidation".to_string(),
                    explanation: Some(explanation).cloned(),
                    ..default
                }
            },
            problem_report::Kind::DuplicateField { field, description } => {
                Self {
                    kind: "DuplicateField".to_string(),
                    field: Some(field).cloned(),
                    description: Some(description).cloned(),
                    ..default
                }
            },
            problem_report::Kind::ConversionError {
                field,
                value,
                expected_type,
            } => {
                Self {
                    kind: "ConversionError".to_string(),
                    field: Some(field).cloned(),
                    value: Some(value).cloned(),
                    expected_type: Some(expected_type).cloned(),
                    ..default
                }
            },
            problem_report::Kind::Other { description } => {
                Self {
                    kind: "Other".to_string(),
                    description: Some(description).cloned(),
                    ..default
                }
            },
        }
    }
}

impl Example for ProblemReportEntry {
    fn example() -> Self {
        Self {
            kind: "InvalidValue".to_string(),
            msg: "context".to_string(),
            field: Some("field name".to_string()),
            value: Some("field valeu".to_string()),
            constraint: Some("constraint".to_string()),
            ..Default::default()
        }
    }
}

impl_array_types!(
    ProblemReport,
    ProblemReportEntry,
    Some(poem_openapi::registry::MetaSchema {
        example: Self::example().to_json(),
        max_items: Some(10),
        items: Some(Box::new(ProblemReportEntry::schema_ref())),
        ..poem_openapi::registry::MetaSchema::ANY
    })
);

impl From<problem_report::ProblemReport> for ProblemReport {
    fn from(value: problem_report::ProblemReport) -> Self {
        Self(
            value
                .entries()
                .map(|entry| entry.map(|entry| entry.clone().into()))
                .collect(),
        )
    }
}

impl Example for ProblemReport {
    fn example() -> Self {
        Self(vec![ProblemReportEntry::example()])
    }
}
