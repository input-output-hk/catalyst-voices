use crate::{
    error::Error,
    types::event::{
        Event, EventDetails, EventGoal, EventId, EventRegistration, EventSchedule, EventSummary,
        VotingPowerAlgorithm, VotingPowerSettings,
    },
    EventDB,
};
use async_trait::async_trait;
use chrono::{NaiveDateTime, Utc};

pub mod ballot;
pub mod objective;
pub mod proposal;
pub mod review;

#[async_trait]
pub trait EventQueries: Sync + Send + 'static {
    async fn get_events(
        &self,
        limit: Option<i64>,
        offset: Option<i64>,
    ) -> Result<Vec<EventSummary>, Error>;
    async fn get_event(&self, event: EventId) -> Result<Event, Error>;
}

impl EventDB {
    const EVENTS_QUERY: &'static str =
        "SELECT event.row_id, event.name, event.start_time, event.end_time, snapshot.last_updated
        FROM event
        LEFT JOIN snapshot ON event.row_id = snapshot.event
        ORDER BY event.row_id ASC
        LIMIT $1 OFFSET $2;";

    const EVENT_QUERY: &'static str =
        "SELECT event.row_id, event.name, event.start_time, event.end_time,
        event.snapshot_start, event.registration_snapshot_time,
        event.voting_power_threshold, event.max_voting_power_pct,
        event.insight_sharing_start, event.proposal_submission_start, event.refine_proposals_start, event.finalize_proposals_start, event.proposal_assessment_start, event.assessment_qa_start, event.voting_start, event.voting_end, event.tallying_end,
        snapshot.last_updated
        FROM event
        LEFT JOIN snapshot ON event.row_id = snapshot.event
        WHERE event.row_id = $1;";

    const EVENT_GOALS_QUERY: &'static str = "SELECT goal.idx, goal.name 
                                            FROM goal 
                                            WHERE goal.event_id = $1;";
}

#[async_trait]
impl EventQueries for EventDB {
    async fn get_events(
        &self,
        limit: Option<i64>,
        offset: Option<i64>,
    ) -> Result<Vec<EventSummary>, Error> {
        let conn = self.pool.get().await?;

        let rows = conn
            .query(Self::EVENTS_QUERY, &[&limit, &offset.unwrap_or(0)])
            .await?;

        let mut events = Vec::new();
        for row in rows {
            let ends = row
                .try_get::<&'static str, Option<NaiveDateTime>>("end_time")?
                .map(|val| val.and_local_timezone(Utc).unwrap());
            let is_final = ends.map(|ends| Utc::now() > ends).unwrap_or(false);
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
            })
        }

        Ok(events)
    }

    async fn get_event(&self, event: EventId) -> Result<Event, Error> {
        let conn = self.pool.get().await?;

        let rows = conn.query(Self::EVENT_QUERY, &[&event.0]).await?;
        let row = rows
            .get(0)
            .ok_or_else(|| Error::NotFound("can not find event value".to_string()))?;

        let ends = row
            .try_get::<&'static str, Option<NaiveDateTime>>("end_time")?
            .map(|val| val.and_local_timezone(Utc).unwrap());
        let is_final = ends.map(|ends| Utc::now() > ends).unwrap_or(false);

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

        let rows = conn.query(Self::EVENT_GOALS_QUERY, &[&event.0]).await?;
        let mut goals = Vec::new();
        for row in rows {
            goals.push(EventGoal {
                idx: row.try_get("idx")?,
                name: row.try_get("name")?,
            })
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
                schedule,
                goals,
                registration,
            },
        })
    }
}

/// Need to setup and run a test event db instance
/// To do it you can use the following commands:
/// Prepare docker images
/// ```
/// earthly ./containers/event-db-migrations+docker --data=test
/// ```
/// Run event-db container
/// ```
/// docker-compose -f src/event-db/docker-compose.yml up migrations
/// ```
/// Also need establish `EVENT_DB_URL` env variable with the following value
/// ```
/// EVENT_DB_URL="postgres://catalyst-event-dev:CHANGE_ME@localhost/CatalystEventDev"
/// ```
/// https://github.com/input-output-hk/catalyst-core/tree/main/src/event-db/Readme.md
#[cfg(test)]
mod tests {
    use super::*;
    use crate::establish_connection;
    use chrono::{DateTime, NaiveDate, NaiveTime};
    use rust_decimal::Decimal;

    #[tokio::test]
    async fn get_events_test() {
        let event_db = establish_connection(None).await.unwrap();

        let events = event_db.get_events(None, None).await.unwrap();
        assert_eq!(
            events,
            vec![
                EventSummary {
                    id: EventId(0),
                    name: "Test Fund".to_string(),
                    starts: Some(DateTime::<Utc>::from_utc(NaiveDateTime::default(), Utc)),
                    ends: Some(DateTime::<Utc>::from_utc(NaiveDateTime::default(), Utc)),
                    reg_checked: None,
                    is_final: true,
                },
                EventSummary {
                    id: EventId(1),
                    name: "Test Fund 1".to_string(),
                    starts: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2020, 5, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    ends: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2020, 6, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    reg_checked: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2020, 3, 31).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    is_final: true,
                },
                EventSummary {
                    id: EventId(2),
                    name: "Test Fund 2".to_string(),
                    starts: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2021, 5, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    ends: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2021, 6, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    reg_checked: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2021, 3, 31).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    is_final: true,
                },
                EventSummary {
                    id: EventId(3),
                    name: "Test Fund 3".to_string(),
                    starts: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2022, 5, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    ends: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2022, 6, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    reg_checked: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2022, 3, 31).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    is_final: true,
                },
                EventSummary {
                    id: EventId(4),
                    name: "Test Fund 4".to_string(),
                    starts: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2022, 5, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    ends: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2024, 6, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    reg_checked: None,
                    is_final: false,
                },
                EventSummary {
                    id: EventId(5),
                    name: "Test Fund 5".to_string(),
                    starts: None,
                    ends: None,
                    reg_checked: None,
                    is_final: false,
                },
            ]
        );

        let events = event_db.get_events(Some(2), None).await.unwrap();
        assert_eq!(
            events,
            vec![
                EventSummary {
                    id: EventId(0),
                    name: "Test Fund".to_string(),
                    starts: Some(DateTime::<Utc>::from_utc(NaiveDateTime::default(), Utc)),
                    ends: Some(DateTime::<Utc>::from_utc(NaiveDateTime::default(), Utc)),
                    reg_checked: None,
                    is_final: true,
                },
                EventSummary {
                    id: EventId(1),
                    name: "Test Fund 1".to_string(),
                    starts: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2020, 5, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    ends: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2020, 6, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    reg_checked: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2020, 3, 31).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    is_final: true,
                },
            ]
        );

        let events = event_db.get_events(Some(1), Some(1)).await.unwrap();
        assert_eq!(
            events,
            vec![EventSummary {
                id: EventId(1),
                name: "Test Fund 1".to_string(),
                starts: Some(DateTime::<Utc>::from_utc(
                    NaiveDateTime::new(
                        NaiveDate::from_ymd_opt(2020, 5, 1).unwrap(),
                        NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                    ),
                    Utc
                )),
                ends: Some(DateTime::<Utc>::from_utc(
                    NaiveDateTime::new(
                        NaiveDate::from_ymd_opt(2020, 6, 1).unwrap(),
                        NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                    ),
                    Utc
                )),
                reg_checked: Some(DateTime::<Utc>::from_utc(
                    NaiveDateTime::new(
                        NaiveDate::from_ymd_opt(2020, 3, 31).unwrap(),
                        NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                    ),
                    Utc
                )),
                is_final: true,
            },]
        );

        assert_eq!(
            event_db.get_events(Some(1), Some(10)).await.unwrap(),
            vec![]
        );
    }

    #[tokio::test]
    async fn get_event_test() {
        let event_db = establish_connection(None).await.unwrap();

        let event = event_db.get_event(EventId(1)).await.unwrap();
        assert_eq!(
            event,
            Event {
                summary: EventSummary {
                    id: EventId(1),
                    name: "Test Fund 1".to_string(),
                    starts: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2020, 5, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    ends: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2020, 6, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    reg_checked: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2020, 3, 31).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    is_final: true,
                },
                details: EventDetails {
                    voting_power: VotingPowerSettings {
                        alg: VotingPowerAlgorithm::ThresholdStakedADA,
                        min_ada: Some(1),
                        max_pct: Some(Decimal::new(100, 0)),
                    },
                    registration: EventRegistration {
                        purpose: None,
                        deadline: Some(DateTime::<Utc>::from_utc(
                            NaiveDateTime::new(
                                NaiveDate::from_ymd_opt(2020, 3, 31).unwrap(),
                                NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                            ),
                            Utc
                        )),
                        taken: Some(DateTime::<Utc>::from_utc(
                            NaiveDateTime::new(
                                NaiveDate::from_ymd_opt(2020, 3, 31).unwrap(),
                                NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                            ),
                            Utc
                        ))
                    },
                    schedule: EventSchedule {
                        insight_sharing: Some(DateTime::<Utc>::from_utc(
                            NaiveDateTime::new(
                                NaiveDate::from_ymd_opt(2020, 3, 1).unwrap(),
                                NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                            ),
                            Utc
                        )),
                        proposal_submission: Some(DateTime::<Utc>::from_utc(
                            NaiveDateTime::new(
                                NaiveDate::from_ymd_opt(2020, 3, 1).unwrap(),
                                NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                            ),
                            Utc
                        )),
                        refine_proposals: Some(DateTime::<Utc>::from_utc(
                            NaiveDateTime::new(
                                NaiveDate::from_ymd_opt(2020, 3, 1).unwrap(),
                                NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                            ),
                            Utc
                        )),
                        finalize_proposals: Some(DateTime::<Utc>::from_utc(
                            NaiveDateTime::new(
                                NaiveDate::from_ymd_opt(2020, 3, 1).unwrap(),
                                NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                            ),
                            Utc
                        )),
                        proposal_assessment: Some(DateTime::<Utc>::from_utc(
                            NaiveDateTime::new(
                                NaiveDate::from_ymd_opt(2020, 3, 1).unwrap(),
                                NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                            ),
                            Utc
                        )),
                        assessment_qa_start: Some(DateTime::<Utc>::from_utc(
                            NaiveDateTime::new(
                                NaiveDate::from_ymd_opt(2020, 3, 1).unwrap(),
                                NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                            ),
                            Utc
                        )),
                        voting: Some(DateTime::<Utc>::from_utc(
                            NaiveDateTime::new(
                                NaiveDate::from_ymd_opt(2020, 5, 1).unwrap(),
                                NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                            ),
                            Utc
                        )),
                        tallying: Some(DateTime::<Utc>::from_utc(
                            NaiveDateTime::new(
                                NaiveDate::from_ymd_opt(2020, 6, 1).unwrap(),
                                NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                            ),
                            Utc
                        )),
                        tallying_end: Some(DateTime::<Utc>::from_utc(
                            NaiveDateTime::new(
                                NaiveDate::from_ymd_opt(2020, 7, 1).unwrap(),
                                NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                            ),
                            Utc
                        )),
                    },
                    goals: vec![
                        EventGoal {
                            idx: 1,
                            name: "goal 1".to_string(),
                        },
                        EventGoal {
                            idx: 2,
                            name: "goal 2".to_string(),
                        },
                        EventGoal {
                            idx: 3,
                            name: "goal 3".to_string(),
                        },
                        EventGoal {
                            idx: 4,
                            name: "goal 4".to_string(),
                        }
                    ],
                },
            },
        );

        assert_eq!(
            event_db.get_event(EventId(100)).await,
            Err(Error::NotFound("can not find event value".to_string()))
        );
    }
}
