//! Types and methods related to the `/rbac/registrations` V1 endpoint.

mod endpoint;
mod registration_chain;
mod response;
mod role_data;
mod role_map;

pub use self::{endpoint::endpoint_v1, response::AllResponsesV1};
