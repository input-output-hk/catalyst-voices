//! Types and methods related to the `/rbac/registrations` V2 endpoint.

mod endpoint;
mod registration_chain;
mod response;
mod role_data;
mod role_list;

pub use self::{endpoint::endpoint_v2, response::AllResponsesV2};
