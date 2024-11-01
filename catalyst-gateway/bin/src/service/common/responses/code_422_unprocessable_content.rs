//! Define `Unprocessable Content` response type.

use poem_openapi::{types::Example, Object};

#[derive(Debug, Object)]
#[oai(example, skip_serializing_if_is_none)]
/// Individual details of a single error that was detected with the content of the
/// request.
pub(crate) struct ContentErrorDetail {
    /// The location of the error
    #[oai(validator(max_items = 100, max_length = "1000", pattern = "^[0-9a-zA-Z].*$"))]
    loc: Option<Vec<String>>,
    /// The error message.
    #[oai(validator(max_length = "1000", pattern = "^[0-9a-zA-Z].*$"))]
    msg: Option<String>,
    /// The type of error
    #[oai(
        rename = "type",
        validator(max_length = "1000", pattern = "^[0-9a-zA-Z].*$")
    )]
    err_type: Option<String>,
}

impl Example for ContentErrorDetail {
    /// Example for the `ContentErrorDetail` Payload.
    fn example() -> Self {
        Self {
            loc: Some(vec!["body".to_owned()]),
            msg: Some("Value is not a valid dict.".to_owned()),
            err_type: Some("type_error.dict".to_owned()),
        }
    }
}

impl ContentErrorDetail {
    /// Create a new `ContentErrorDetail` Response Payload.
    pub(crate) fn new(error: &poem::Error) -> Self {
        // TODO: See if we can get more info from the error than this.
        Self {
            loc: None,
            msg: Some(error.to_string()),
            err_type: None,
        }
    }
}

#[derive(Debug, Object)]
#[oai(example, skip_serializing_if_is_none)]
/// Server Error response to a Bad request.
pub(crate) struct UnprocessableContent {
    #[oai(validator(max_items = "1000", min_items = "1"))]
    /// Details of each error in the content that was detected.
    ///
    /// Note: This may not be ALL errors in the content, as validation of content can stop
    /// at any point an error is detected.
    detail: Vec<ContentErrorDetail>,
}

impl UnprocessableContent {
    /// Create a new `ContentErrorDetail` Response Payload.
    pub(crate) fn new(errors: Vec<poem::Error>) -> Self {
        let mut detail = vec![];
        for error in errors {
            detail.push(ContentErrorDetail::new(&error));
        }

        Self { detail }
    }
}

impl Example for UnprocessableContent {
    /// Example for the Too Many Requests Payload.
    fn example() -> Self {
        Self {
            detail: vec![ContentErrorDetail::example()],
        }
    }
}
