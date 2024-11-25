//! Define the Review

use poem_openapi::Object;

/// The proposal review object from a reviewer.
#[allow(clippy::missing_docs_in_private_items)]
#[derive(Object, Default)]
pub(crate) struct Review {
    #[oai(validator(max_length = 256, min_length = 0, pattern = "[A-Za-z0-9_-]"))]
    id: String,
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    assessor: String,
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    impact_alignment_note: String,
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    impact_alignment_rating_given: String,
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    auditability_note: String,
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    auditability_rating_given: String,
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    feasibility_note: String,
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    feasibility_rating_given: String,
}
