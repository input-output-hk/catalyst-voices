//! A shared implementation for V1 and V2 endpoints.

pub use self::{
    v1::{AllResponsesV1, endpoint_v1},
    v2::{AllResponsesV2, endpoint_v2},
};

mod invalid_registration;
mod invalid_registration_list;
mod key_type;
mod pem;
mod purpose_list;
mod role_id;
mod unprocessable_content;
mod v1;
mod v2;
