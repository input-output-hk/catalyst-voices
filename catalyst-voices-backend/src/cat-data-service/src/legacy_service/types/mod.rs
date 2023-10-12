use chrono::{DateTime, Utc};
use serde::Serializer;
use std::ops::Deref;

pub mod ballot;
pub mod event;
pub mod objective;
pub mod proposal;
pub mod registration;
pub mod review;
pub mod search;
pub mod voting_status;
// DEPRECATED, addded as a backward compatibility with the VIT-SS
pub mod vit_ss;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct SerdeType<T>(pub T);

impl<T> From<T> for SerdeType<T> {
    fn from(val: T) -> Self {
        Self(val)
    }
}

impl<T> Deref for SerdeType<T> {
    type Target = T;
    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

pub fn serialize_datetime_as_rfc3339<S: Serializer>(
    time: &DateTime<Utc>,
    serializer: S,
) -> Result<S::Ok, S::Error> {
    serializer.serialize_str(&time.to_rfc3339())
}

pub fn serialize_option_datetime_as_rfc3339<S: Serializer>(
    time: &Option<DateTime<Utc>>,
    serializer: S,
) -> Result<S::Ok, S::Error> {
    if let Some(time) = time {
        serializer.serialize_str(&time.to_rfc3339())
    } else {
        serializer.serialize_none()
    }
}
