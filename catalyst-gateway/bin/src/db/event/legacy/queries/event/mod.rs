//! Event Queries
use chrono::{NaiveDateTime, Utc};

use crate::db::event::{
    error::NotFoundError,
    legacy::types::event::{
        Event, EventDetails, EventGoal, EventId, EventRegistration, EventSchedule, EventSummary,
        VotingPowerAlgorithm, VotingPowerSettings,
    },
    EventDB,
};

pub(crate) mod ballot;
pub(crate) mod objective;
pub(crate) mod proposal;
pub(crate) mod review;

impl EventDB {
    /// Events query template
    const EVENTS_QUERY: &'static str =
        "SELECT event.row_id, event.name, event.start_time, event.end_time, snapshot.last_updated
        FROM event
        LEFT JOIN snapshot ON event.row_id = snapshot.event
        ORDER BY event.row_id ASC
        LIMIT $1 OFFSET $2;";
    /// Event goals query template
    const EVENT_GOALS_QUERY: &'static str = "SELECT goal.idx, goal.name 
                                            FROM goal 
                                            WHERE goal.event_id = $1;";
    /// Event details query template
    const EVENT_QUERY: &'static str =
        "SELECT event.row_id, event.name, event.start_time, event.end_time,
        event.snapshot_start, event.registration_snapshot_time,
        event.voting_power_threshold, event.max_voting_power_pct,
        event.insight_sharing_start, event.proposal_submission_start, event.refine_proposals_start, event.finalize_proposals_start, event.proposal_assessment_start, event.assessment_qa_start, event.voting_start, event.voting_end, event.tallying_end,
        snapshot.last_updated
        FROM event
        LEFT JOIN snapshot ON event.row_id = snapshot.event
        WHERE event.row_id = $1;";
}

impl EventDB {
    /// Get events query
    #[allow(dead_code)]
    pub(crate) async fn get_events(
        &self, limit: Option<i64>, offset: Option<i64>,
    ) -> anyhow::Result<Vec<EventSummary>> {
        let rows = Self::query(Self::EVENTS_QUERY, &[&limit, &offset.unwrap_or(0)]).await?;

        let mut events = Vec::new();
        for row in rows {
            let ends = row
                .try_get::<&'static str, Option<NaiveDateTime>>("end_time")?
                .map(|val| val.and_local_timezone(Utc).unwrap());
            let is_final = ends.map_or(false, |ends| Utc::now() > ends);
            events.push(EventSummary {
                id: EventId(row.try_get("row_id")?),
                name: row.try_get("name")?,
                starts: row
                    .try_get::<&'static str, Option<NaiveDateTime>>("start_time")?
                    .map(|val| val.and_local_timezone(Utc).unwrap()),
                reg_checked: row
                    .try_get::<&'static str, Option<NaiveDateTime>>("last_updated")?
                    .map(|val| val.and_local_timezone(Utc).unwrap()),
                ends,
                is_final,
            });
        }

        Ok(events)
    }

    /// Get event query
    #[allow(dead_code)]
    pub(crate) async fn get_event(event: EventId) -> anyhow::Result<Event> {
        let rows = Self::query(Self::EVENT_QUERY, &[&event.0]).await?;
        let row = rows.first().ok_or(NotFoundError)?;

        let ends = row
            .try_get::<&'static str, Option<NaiveDateTime>>("end_time")?
            .map(|val| val.and_local_timezone(Utc).unwrap());
        let is_final = ends.map_or(false, |ends| Utc::now() > ends);

        let voting_power = VotingPowerSettings {
            alg: VotingPowerAlgorithm::ThresholdStakedADA,
            min_ada: row.try_get("voting_power_threshold")?,
            max_pct: row.try_get("max_voting_power_pct")?,
        };

        let registration = EventRegistration {
            purpose: None,
            deadline: row
                .try_get::<&'static str, Option<NaiveDateTime>>("snapshot_start")?
                .map(|val| val.and_local_timezone(Utc).unwrap()),
            taken: row
                .try_get::<&'static str, Option<NaiveDateTime>>("registration_snapshot_time")?
                .map(|val| val.and_local_timezone(Utc).unwrap()),
        };

        let schedule = EventSchedule {
            insight_sharing: row
                .try_get::<&'static str, Option<NaiveDateTime>>("insight_sharing_start")?
                .map(|val| val.and_local_timezone(Utc).unwrap()),
            proposal_submission: row
                .try_get::<&'static str, Option<NaiveDateTime>>("proposal_submission_start")?
                .map(|val| val.and_local_timezone(Utc).unwrap()),
            refine_proposals: row
                .try_get::<&'static str, Option<NaiveDateTime>>("refine_proposals_start")?
                .map(|val| val.and_local_timezone(Utc).unwrap()),
            finalize_proposals: row
                .try_get::<&'static str, Option<NaiveDateTime>>("finalize_proposals_start")?
                .map(|val| val.and_local_timezone(Utc).unwrap()),
            proposal_assessment: row
                .try_get::<&'static str, Option<NaiveDateTime>>("proposal_assessment_start")?
                .map(|val| val.and_local_timezone(Utc).unwrap()),
            assessment_qa_start: row
                .try_get::<&'static str, Option<NaiveDateTime>>("assessment_qa_start")?
                .map(|val| val.and_local_timezone(Utc).unwrap()),
            voting: row
                .try_get::<&'static str, Option<NaiveDateTime>>("voting_start")?
                .map(|val| val.and_local_timezone(Utc).unwrap()),
            tallying: row
                .try_get::<&'static str, Option<NaiveDateTime>>("voting_end")?
                .map(|val| val.and_local_timezone(Utc).unwrap()),
            tallying_end: row
                .try_get::<&'static str, Option<NaiveDateTime>>("tallying_end")?
                .map(|val| val.and_local_timezone(Utc).unwrap()),
        };

        let rows = Self::query(Self::EVENT_GOALS_QUERY, &[&event.0]).await?;
        let mut goals = Vec::new();
        for row in rows {
            goals.push(EventGoal {
                idx: row.try_get("idx")?,
                name: row.try_get("name")?,
            });
        }

        Ok(Event {
            summary: EventSummary {
                id: EventId(row.try_get("row_id")?),
                name: row.try_get("name")?,
                starts: row
                    .try_get::<&'static str, Option<NaiveDateTime>>("start_time")?
                    .map(|val| val.and_local_timezone(Utc).unwrap()),
                reg_checked: row
                    .try_get::<&'static str, Option<NaiveDateTime>>("last_updated")?
                    .map(|val| val.and_local_timezone(Utc).unwrap()),
                ends,
                is_final,
            },
            details: EventDetails {
                voting_power,
                registration,
                schedule,
                goals,
            },
        })
    }
}
