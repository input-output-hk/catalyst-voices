//! Signed docs queries

mod doc_ref;
mod full_signed_doc;
mod query_filter;
mod signed_doc_body;
#[cfg(test)]
mod tests;

pub(crate) use doc_ref::DocumentRef;
pub(crate) use full_signed_doc::{FullSignedDoc, StoreError, SELECT_SIGNED_DOCS_TEMPLATE};
pub(crate) use query_filter::DocsQueryFilter;
pub(crate) use signed_doc_body::{
    SignedDocBody, FILTERED_COUNT_SIGNED_DOCS_TEMPLATE, FILTERED_SELECT_SIGNED_DOCS_TEMPLATE,
};
