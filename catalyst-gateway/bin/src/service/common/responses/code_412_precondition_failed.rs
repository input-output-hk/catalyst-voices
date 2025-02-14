//! Define `Precondition Failed` response type.

use poem_openapi::{
    types::{Example, ToJSON},
    Object,
};

use crate::service::{common, common::types::array_types::impl_array_types};

/// The client has not sent valid data in its request, headers, parameters or body.
#[derive(Object, Debug, Clone)]
#[oai(example)]
pub(crate) struct PreconditionFailed {
    /// Details of each error in the content that was detected.
    ///
    /// Note: This may not be ALL errors in the content, as validation of content can stop
    /// at any point an error is detected.
    detail: ContentErrorDetailList,
}

impl PreconditionFailed {
    /// Create a new `ContentErrorDetail` Response Payload.
    pub(crate) fn new(errors: Vec<poem::Error>) -> Self {
        let mut detail = vec![];
        for error in errors {
            detail.push(ContentErrorDetail::new(&error));
        }

        Self {
            detail: detail.into(),
        }
    }
}

impl Example for PreconditionFailed {
    /// Example for the Too Many Requests Payload.
    fn example() -> Self {
        Self {
            detail: Example::example(),
        }
    }
}

// List of Content Error Details
impl_array_types!(
    ContentErrorDetailList,
    ContentErrorDetail,
    Some(poem_openapi::registry::MetaSchema {
        example: Self::example().to_json(),
        min_items: Some(1),
        max_items: Some(1000),
        items: Some(Box::new(ContentErrorDetail::schema_ref())),
        ..poem_openapi::registry::MetaSchema::ANY
    })
);

impl Example for ContentErrorDetailList {
    fn example() -> Self {
        Self(vec![Example::example()])
    }
}

//--------------------------------------------------------------------------------------

#[derive(Object, Debug, Clone)]
#[oai(example)]
/// Individual details of a single error that was detected with the content of the
/// request.
pub(crate) struct ContentErrorDetail {
    /// The location of the error
    #[oai(nullable)]
    loc: Option<common::types::generic::error_list::ErrorList>,
    /// The error message.
    #[oai(validator(max_length = "1000", pattern = "^[0-9a-zA-Z].*$"), nullable)]
    msg: Option<common::types::generic::error_msg::ErrorMessage>,
    /// The type of error
    #[oai(
        rename = "type",
        validator(max_length = "1000", pattern = "^[0-9a-zA-Z].*$"),
        nullable
    )]
    err_type: Option<common::types::generic::error_msg::ErrorMessage>,
}

impl Example for ContentErrorDetail {
    /// Example for the `ContentErrorDetail` Payload.
    fn example() -> Self {
        Self {
            loc: Some(vec!["body".into()].into()),
            msg: Some("Value is not a valid dict.".into()),
            err_type: Some("type_error.dict".into()),
        }
    }
}

impl ContentErrorDetail {
    /// Create a new `ContentErrorDetail` Response Payload.
    pub(crate) fn new(error: &poem::Error) -> Self {
        // TODO: See if we can get more info from the error than this.
        Self {
            loc: None,
            msg: Some(error.to_string().into()),
            err_type: None,
        }
    }
}
