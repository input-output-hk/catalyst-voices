//! Header Types
//!
//! These are types used to define the values of the contents of header fields.
//!
//! There are two kinds of header fields:
//!
//! ## Passive header fields
//!
//! These headers are not created or updated by the responder, or are only read in a
//! request. They could be produced by middleware.
//!
//! ## Active header fields
//!
//! These are produced as part of a response, and it's the responsibility of the responder
//! to set them.

pub(crate) mod access_control_allow_origin;
pub(crate) mod ratelimit;
pub(crate) mod retry_after;
