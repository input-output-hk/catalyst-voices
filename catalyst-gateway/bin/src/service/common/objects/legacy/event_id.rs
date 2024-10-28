//! Define the ID of an Event
use poem_openapi::{types::Example, NewType};
use serde::Deserialize;

/// The Numeric Index of a Voting Event
#[derive(NewType, Deserialize)]
#[oai(example = true)]
pub(crate) struct EventId(pub(crate) i32);

impl Example for EventId {
    fn example() -> Self {
        Self(11)
    }
}

impl From<EventId> for crate::db::event::legacy::types::event::EventId {
    fn from(event_id: EventId) -> Self {
        crate::db::event::legacy::types::event::EventId(event_id.0)
    }
}
