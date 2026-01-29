//! `OpenAPI` Objects for Problem Report

use catalyst_types::problem_report;
use poem_openapi::{
    Object,
    types::{Example, ToJSON},
};

use crate::service::common::types::{
    array_types::impl_array_types, generic::error_msg::ErrorMessage,
};

/// Represents an `OpenAPI` object for a Problem Report entry.
#[derive(Debug, Clone, Object, Default)]
#[oai(example = true)]
pub(crate) struct ProblemReportEntry {
    /// The kind of problem we are recording.
    pub(crate) kind: ErrorMessage,
    /// The message describing the problem.
    pub(crate) msg: ErrorMessage,
    /// The field name that causes the problem.
    #[oai(skip_serializing_if_is_none)]
    pub(crate) field: Option<ErrorMessage>,
    /// The value of the field.
    #[oai(skip_serializing_if_is_none)]
    pub(crate) value: Option<ErrorMessage>,
    /// The constraint of what is expected for a valid value
    #[oai(skip_serializing_if_is_none)]
    pub(crate) constraint: Option<ErrorMessage>,
    /// Detected encoding
    #[oai(skip_serializing_if_is_none)]
    pub(crate) encoded: Option<ErrorMessage>,
    /// Expected encoding
    #[oai(skip_serializing_if_is_none)]
    pub(crate) expected: Option<ErrorMessage>,
    #[oai(skip_serializing_if_is_none)]
    /// Explanation of the failed or problematic validation
    pub(crate) explanation: Option<ErrorMessage>,
    #[oai(skip_serializing_if_is_none)]
    /// Additional information about the duplicate field.
    pub(crate) description: Option<ErrorMessage>,
    #[oai(skip_serializing_if_is_none)]
    /// The type that the value was expected to convert to
    pub(crate) expected_type: Option<ErrorMessage>,
}

impl From<problem_report::Entry> for ProblemReportEntry {
    fn from(value: problem_report::Entry) -> Self {
        let default = Self {
            msg: ErrorMessage::from(value.context().as_str()),
            ..Self::default()
        };

        match value.kind() {
            problem_report::Kind::MissingField { field } => {
                Self {
                    kind: ErrorMessage::from("MissingField"),
                    field: Some(&ErrorMessage::from(field.as_str())).cloned(),
                    ..default
                }
            },
            problem_report::Kind::UnknownField { field, value } => {
                Self {
                    kind: ErrorMessage::from("UnknownField"),
                    field: Some(&ErrorMessage::from(field.as_str())).cloned(),
                    value: Some(&ErrorMessage::from(value.as_str())).cloned(),
                    ..default
                }
            },
            problem_report::Kind::InvalidValue {
                field,
                value,
                constraint,
            } => {
                Self {
                    kind: ErrorMessage::from("InvalidValue"),
                    field: Some(&ErrorMessage::from(field.as_str())).cloned(),
                    value: Some(&ErrorMessage::from(value.as_str())).cloned(),
                    constraint: Some(&ErrorMessage::from(constraint.as_str())).cloned(),
                    ..default
                }
            },
            problem_report::Kind::InvalidEncoding {
                field,
                encoded,
                expected,
            } => {
                Self {
                    kind: ErrorMessage::from("InvalidEncoding"),
                    field: Some(&ErrorMessage::from(field.as_str())).cloned(),
                    encoded: Some(&ErrorMessage::from(encoded.as_str())).cloned(),
                    expected: Some(&ErrorMessage::from(expected.as_str())).cloned(),
                    ..default
                }
            },
            problem_report::Kind::FunctionalValidation { explanation } => {
                Self {
                    kind: ErrorMessage::from("FunctionalValidation"),
                    explanation: Some(&ErrorMessage::from(explanation.as_str())).cloned(),
                    ..default
                }
            },
            problem_report::Kind::DuplicateField { field, description } => {
                Self {
                    kind: ErrorMessage::from("DuplicateField"),
                    field: Some(&ErrorMessage::from(field.as_str())).cloned(),
                    description: Some(&ErrorMessage::from(description.as_str())).cloned(),
                    ..default
                }
            },
            problem_report::Kind::ConversionError {
                field,
                value,
                expected_type,
            } => {
                Self {
                    kind: ErrorMessage::from("ConversionError"),
                    field: Some(&ErrorMessage::from(field.as_str())).cloned(),
                    value: Some(&ErrorMessage::from(value.as_str())).cloned(),
                    expected_type: Some(&ErrorMessage::from(expected_type.as_str())).cloned(),
                    ..default
                }
            },
            problem_report::Kind::Other { description } => {
                Self {
                    kind: ErrorMessage::from("Other"),
                    description: Some(&ErrorMessage::from(description.as_str())).cloned(),
                    ..default
                }
            },
        }
    }
}

impl Example for ProblemReportEntry {
    fn example() -> Self {
        Self {
            kind: ErrorMessage::from("InvalidValue"),
            msg: ErrorMessage::from("context"),
            field: Some(ErrorMessage::from("field name")),
            value: Some(ErrorMessage::from("field value")),
            constraint: Some(ErrorMessage::from("constraint")),
            ..Self::default()
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

impl From<&problem_report::ProblemReport> for ProblemReport {
    fn from(value: &problem_report::ProblemReport) -> Self {
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
