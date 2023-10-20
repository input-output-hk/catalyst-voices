use chrono::{DateTime, Utc};
use serde::Serializer;
use std::ops::Deref;

pub(crate) mod ballot;
pub(crate) mod event;
pub(crate) mod objective;
pub(crate) mod proposal;
pub(crate) mod registration;
pub(crate) mod review;
pub(crate) mod search;
pub(crate) mod voting_status;
// DEPRECATED, added as a backward compatibility with the VIT-SS
pub(crate) mod vit_ss;

#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct SerdeType<T>(pub(crate) T);

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

pub(crate) fn serialize_datetime_as_rfc3339<S: Serializer>(
    time: &DateTime<Utc>,
    serializer: S,
) -> Result<S::Ok, S::Error> {
    serializer.serialize_str(&time.to_rfc3339())
}

pub(crate) fn serialize_option_datetime_as_rfc3339<S: Serializer>(
    time: &Option<DateTime<Utc>>,
    serializer: S,
) -> Result<S::Ok, S::Error> {
    if let Some(time) = time {
        serializer.serialize_str(&time.to_rfc3339())
    } else {
        serializer.serialize_none()
    }
}
