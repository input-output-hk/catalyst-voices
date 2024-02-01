//! Database Queries
use self::{
    event::{
        ballot::BallotQueries, config::ConfigQueries, follower::FollowerQueries,
        objective::ObjectiveQueries, proposal::ProposalQueries, review::ReviewQueries,
        EventQueries,
    },
    registration::RegistrationQueries,
    search::SearchQueries,
};
use crate::event_db::{schema_check::SchemaVersion, EventDB};

pub(crate) mod event;
pub(crate) mod registration;
pub(crate) mod search;
// DEPRECATED, added as a backward compatibility with the VIT-SS
pub(crate) mod vit_ss;

#[allow(clippy::module_name_repetitions)]
/// Event DB Queries Trait
pub(crate) trait EventDbQueries:
    RegistrationQueries
    + EventQueries
    + ObjectiveQueries
    + ProposalQueries
    + ReviewQueries
    + SearchQueries
    + BallotQueries
    + vit_ss::fund::VitSSFundQueries
    + SchemaVersion
    + ConfigQueries
    + FollowerQueries
{
}

impl EventDbQueries for EventDB {}
