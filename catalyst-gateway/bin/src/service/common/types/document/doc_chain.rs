//! A reference to the previous signed document in a sequence.

use catalyst_signed_doc::Chain;
use poem_openapi::types::Example;
use poem_openapi_derive::{NewType, Object};

use crate::service::common::types::document::{
    doc_height::DocumentHeight, doc_ref_v2::FilteredDocumentReferenceV2,
};

/// A reference to the previous signed document in a sequence.
#[derive(Object, Debug, Clone)]
#[oai(example)]
pub struct DocumentChain {
    /// A consecutive sequence number of the current document in the chain.
    height: DocumentHeight,
    /// A reference to a single signed document.
    document_ref: Option<FilteredDocumentReferenceV2>,
}

/// A reference to the previous signed document in a sequence.
#[derive(NewType, Debug, Clone)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
pub(crate) struct DocumentChainDocumented(DocumentChain);

impl Example for DocumentChain {
    fn example() -> Self {
        Self {
            height: DocumentHeight::example(),
            document_ref: Some(FilteredDocumentReferenceV2::example()),
        }
    }
}

impl From<&Chain> for DocumentChainDocumented {
    fn from(chain: &Chain) -> Self {
        DocumentChainDocumented(DocumentChain {
            height: chain.height().into(),
            document_ref: chain.document_ref().cloned().map(Into::into),
        })
    }
}

impl Example for DocumentChainDocumented {
    fn example() -> Self {
        Self(DocumentChain::example())
    }
}
