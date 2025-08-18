//! A shared implementation for V1 and V2 endpoints.

pub use self::{
    v1::{endpoint_v1, AllResponsesV1},
    v2::{endpoint_v2, AllResponsesV2},
};

mod binary_data;
mod extended_data;
mod invalid_registration;
mod invalid_registration_list;
mod key_data;
mod key_data_list;
mod key_type;
mod payment_data;
mod payment_data_list;
mod purpose_list;
mod role_id;
mod unprocessable_content;
mod v1;
mod v2;
