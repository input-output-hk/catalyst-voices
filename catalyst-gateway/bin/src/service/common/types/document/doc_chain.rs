//! A reference to the previous signed document in a sequence.

use catalyst_signed_doc::Chain;
use poem_openapi::types::Example;
use poem_openapi_derive::Object;

use crate::service::common::types::document::{
    doc_height::DocumentHeight, doc_ref_v2::DocumentReferenceV2,
};

/// A reference to the previous signed document in a sequence.
#[derive(Object, Debug, Clone)]
pub struct DocumentChain {
    /// A consecutive sequence number of the current document in the chain.
    height: DocumentHeight,
    /// A reference to a single signed document.
    document_ref: Option<DocumentReferenceV2>,
}

impl Example for DocumentChain {
    fn example() -> Self {
        Self {
            height: DocumentHeight::example(),
            document_ref: Some(DocumentReferenceV2::example()),
        }
    }
}

impl From<&Chain> for DocumentChain {
    fn from(chain: &Chain) -> Self {
        Self {
            height: chain.height().into(),
            document_ref: chain.document_ref().cloned().map(Into::into),
        }
    }
}
