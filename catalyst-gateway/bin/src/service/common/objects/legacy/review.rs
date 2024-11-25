use poem_openapi::Object;

/// The review object.
#[allow(clippy::missing_docs_in_private_items)]
#[derive(Object, Default)]
pub(crate) struct Review {
    /// The identifier of the review object.
    #[oai(validator(max_length = 256, min_length = 0, pattern = "[A-Za-z0-9_-]"))]
    id: String,
    /// The assessor name.
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    assessor: String,
    /// Impact alignment note.
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    impact_alignment_note: String,
    /// Impact alignment rating given.
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    impact_alignment_rating_given: String,
    /// Auditability note.
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    auditability_note: String,
    /// Auditability rating given.
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    auditability_rating_given: String,
    /// Feasibility note.
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    feasibility_note: String,
    /// Feasibility rating given.
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    feasibility_rating_given: String,
}
