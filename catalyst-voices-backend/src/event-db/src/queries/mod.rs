use self::{
    event::{
        ballot::BallotQueries, objective::ObjectiveQueries, proposal::ProposalQueries,
        review::ReviewQueries, EventQueries,
    },
    registration::RegistrationQueries,
    search::SearchQueries,
};
use crate::EventDB;

pub mod event;
pub mod registration;
pub mod search;
// DEPRECATED, addded as a backward compatibility with the VIT-SS
pub mod vit_ss;

pub trait EventDbQueries:
    RegistrationQueries
    + EventQueries
    + ObjectiveQueries
    + ProposalQueries
    + ReviewQueries
    + SearchQueries
    + BallotQueries
    + vit_ss::fund::VitSSFundQueries
{
}

impl EventDbQueries for EventDB {}
