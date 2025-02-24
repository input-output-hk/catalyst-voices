//! Common types
//!
//! These should be simple types, not objects.
//! For example, types derived from strings or integers and vectors of simple types only.
//!
//! Objects are objects, and not types.
//!
//! Simple types can be enums, if the intended underlying type is simple, such as a string
//! or integer.

pub(crate) mod array_types;
pub(crate) mod cardano;
pub(crate) mod document;
pub(crate) mod generic;
pub(crate) mod headers;
pub(crate) mod payload;
pub(crate) mod string_types;
