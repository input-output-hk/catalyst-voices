//! Types and methods related to the `/rbac/registrations` V2 endpoint.

mod endpoint;
mod extended_data;
mod extended_data_list;
mod key_data;
mod key_data_list;
mod key_value;
mod payment_data;
mod payment_data_list;
mod registration_chain;
mod response;
mod role_data;
mod role_list;

pub use self::{endpoint::endpoint_v2, response::AllResponsesV2};
