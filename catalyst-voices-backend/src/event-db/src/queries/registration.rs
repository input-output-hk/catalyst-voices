use crate::{
    types::{
        event::EventId,
        registration::{Delegation, Delegator, RewardAddress, Voter, VoterGroupId, VoterInfo},
    },
    Error, EventDB,
};
use async_trait::async_trait;
use chrono::{NaiveDateTime, Utc};

#[async_trait]
pub trait RegistrationQueries: Sync + Send + 'static {
    async fn get_voter(
        &self,
        event: &Option<EventId>,
        voting_key: String,
        with_delegations: bool,
    ) -> Result<Voter, Error>;
    async fn get_delegator(
        &self,
        event: &Option<EventId>,
        stake_public_key: String,
    ) -> Result<Delegator, Error>;
}

impl EventDB {
    const VOTER_BY_EVENT_QUERY: &'static str = "SELECT voter.voting_key, voter.voting_group, voter.voting_power, snapshot.as_at, snapshot.last_updated, snapshot.final, SUM(contribution.value)::BIGINT as delegations_power, COUNT(contribution.value) AS delegations_count
                                            FROM voter
                                            INNER JOIN snapshot ON voter.snapshot_id = snapshot.row_id
                                            INNER JOIN contribution ON contribution.snapshot_id = snapshot.row_id
                                            WHERE voter.voting_key = $1 AND contribution.voting_key = $1 AND snapshot.event = $2
                                            GROUP BY voter.voting_key, voter.voting_group, voter.voting_power, snapshot.as_at, snapshot.last_updated, snapshot.final;";

    const VOTER_BY_LAST_EVENT_QUERY: &'static str = "SELECT snapshot.event, voter.voting_key, voter.voting_group, voter.voting_power, snapshot.as_at, snapshot.last_updated, snapshot.final, SUM(contribution.value)::BIGINT as delegations_power, COUNT(contribution.value) AS delegations_count
                                                FROM voter
                                                INNER JOIN snapshot ON voter.snapshot_id = snapshot.row_id
                                                INNER JOIN contribution ON contribution.snapshot_id = snapshot.row_id
                                                WHERE voter.voting_key = $1 AND contribution.voting_key = $1 AND snapshot.last_updated = (SELECT MAX(snapshot.last_updated) as last_updated from snapshot)
                                                GROUP BY snapshot.event, voter.voting_key, voter.voting_group, voter.voting_power, snapshot.as_at, snapshot.last_updated, snapshot.final;";

    const VOTER_DELEGATORS_LIST_QUERY: &'static str = "SELECT contribution.stake_public_key
                                                FROM contribution
                                                INNER JOIN snapshot ON contribution.snapshot_id = snapshot.row_id
                                                WHERE contribution.voting_key = $1 AND snapshot.event = $2;";

    const TOTAL_BY_EVENT_VOTING_QUERY: &'static str =
        "SELECT SUM(voter.voting_power)::BIGINT as total_voting_power
        FROM voter
        INNER JOIN snapshot ON voter.snapshot_id = snapshot.row_id
        WHERE voter.voting_group = $1 AND snapshot.event = $2;";

    const TOTAL_BY_LAST_EVENT_VOTING_QUERY: &'static str =
        "SELECT SUM(voter.voting_power)::BIGINT as total_voting_power
        FROM voter
        INNER JOIN snapshot ON voter.snapshot_id = snapshot.row_id AND snapshot.last_updated = (SELECT MAX(snapshot.last_updated) as last_updated from snapshot)
        WHERE voter.voting_group = $1;";

    const DELEGATOR_SNAPSHOT_INFO_BY_EVENT_QUERY: &'static str = "
                                                SELECT snapshot.as_at, snapshot.last_updated, snapshot.final
                                                FROM snapshot
                                                WHERE snapshot.event = $1
                                                LIMIT 1;";

    const DELEGATOR_SNAPSHOT_INFO_BY_LAST_EVENT_QUERY: &'static str = "SELECT snapshot.event, snapshot.as_at, snapshot.last_updated, snapshot.final
                                                FROM snapshot
                                                WHERE snapshot.last_updated = (SELECT MAX(snapshot.last_updated) as last_updated from snapshot)
                                                LIMIT 1;";

    const DELEGATIONS_BY_EVENT_QUERY: &'static str = "SELECT contribution.voting_key, contribution.voting_group, contribution.voting_weight, contribution.value, contribution.reward_address
                                                FROM contribution
                                                INNER JOIN snapshot ON contribution.snapshot_id = snapshot.row_id
                                                WHERE contribution.stake_public_key = $1 AND snapshot.event = $2;";

    const TOTAL_POWER_BY_EVENT_QUERY: &'static str = "SELECT SUM(voter.voting_power)::BIGINT as total_voting_power
                                                FROM voter
                                                INNER JOIN snapshot ON voter.snapshot_id = snapshot.row_id
                                                WHERE snapshot.event = $1;";

    const TOTAL_POWER_BY_LAST_EVENT_QUERY: &'static str = "SELECT SUM(voter.voting_power)::BIGINT as total_voting_power
                                                FROM voter
                                                INNER JOIN snapshot ON voter.snapshot_id = snapshot.row_id
                                                WHERE snapshot.last_updated = (SELECT MAX(snapshot.last_updated) as last_updated from snapshot);";
}

#[async_trait]
impl RegistrationQueries for EventDB {
    async fn get_voter(
        &self,
        event: &Option<EventId>,
        voting_key: String,
        with_delegations: bool,
    ) -> Result<Voter, Error> {
        let conn = self.pool.get().await?;

        let rows = if let Some(event) = event {
            conn.query(Self::VOTER_BY_EVENT_QUERY, &[&voting_key, &event.0])
                .await?
        } else {
            conn.query(Self::VOTER_BY_LAST_EVENT_QUERY, &[&voting_key])
                .await?
        };
        let voter = rows
            .get(0)
            .ok_or_else(|| Error::NotFound("can not find voter value".to_string()))?;

        let voting_group = VoterGroupId(voter.try_get("voting_group")?);
        let voting_power = voter.try_get("voting_power")?;

        let rows = if let Some(event) = event {
            conn.query(
                Self::TOTAL_BY_EVENT_VOTING_QUERY,
                &[&voting_group.0, &event.0],
            )
            .await?
        } else {
            conn.query(Self::TOTAL_BY_LAST_EVENT_VOTING_QUERY, &[&voting_group.0])
                .await?
        };

        let total_voting_power_per_group: i64 = rows
            .get(0)
            .ok_or_else(|| {
                Error::NotFound("can not find total voting power per group value".to_string())
            })?
            .try_get("total_voting_power")?;

        let voting_power_saturation = if total_voting_power_per_group as f64 != 0_f64 {
            voting_power as f64 / total_voting_power_per_group as f64
        } else {
            0_f64
        };

        let delegator_addresses = if with_delegations {
            let rows = if let Some(event) = event {
                conn.query(Self::VOTER_DELEGATORS_LIST_QUERY, &[&voting_key, &event.0])
                    .await?
            } else {
                conn.query(
                    Self::VOTER_DELEGATORS_LIST_QUERY,
                    &[&voting_key, &voter.try_get::<_, i32>("event")?],
                )
                .await?
            };

            let mut delegator_addresses = Vec::new();
            for row in rows {
                delegator_addresses.push(row.try_get("stake_public_key")?);
            }
            Some(delegator_addresses)
        } else {
            None
        };

        Ok(Voter {
            voter_info: VoterInfo {
                delegations_power: voter.try_get("delegations_power")?,
                delegations_count: voter.try_get("delegations_count")?,
                voting_power_saturation,
                voting_power,
                voting_group,
                delegator_addresses,
            },
            as_at: voter
                .try_get::<_, NaiveDateTime>("as_at")?
                .and_local_timezone(Utc)
                .unwrap(),
            last_updated: voter
                .try_get::<_, NaiveDateTime>("last_updated")?
                .and_local_timezone(Utc)
                .unwrap(),
            is_final: voter.try_get("final")?,
        })
    }

    async fn get_delegator(
        &self,
        event: &Option<EventId>,
        stake_public_key: String,
    ) -> Result<Delegator, Error> {
        let conn = self.pool.get().await?;
        let rows = if let Some(event) = event {
            conn.query(Self::DELEGATOR_SNAPSHOT_INFO_BY_EVENT_QUERY, &[&event.0])
                .await?
        } else {
            conn.query(Self::DELEGATOR_SNAPSHOT_INFO_BY_LAST_EVENT_QUERY, &[])
                .await?
        };
        let delegator_snapshot_info = rows
            .get(0)
            .ok_or_else(|| Error::NotFound("can not find delegator value".to_string()))?;

        let delegation_rows = if let Some(event) = event {
            conn.query(
                Self::DELEGATIONS_BY_EVENT_QUERY,
                &[&stake_public_key, &event.0],
            )
            .await?
        } else {
            conn.query(
                Self::DELEGATIONS_BY_EVENT_QUERY,
                &[
                    &stake_public_key,
                    &delegator_snapshot_info.try_get::<_, i32>("event")?,
                ],
            )
            .await?
        };
        if delegation_rows.is_empty() {
            return Err(Error::NotFound("can not find delegator value".to_string()));
        }

        let mut delegations = Vec::new();
        for row in &delegation_rows {
            delegations.push(Delegation {
                voting_key: row.try_get("voting_key")?,
                group: VoterGroupId(row.try_get("voting_group")?),
                weight: row.try_get("voting_weight")?,
                value: row.try_get("value")?,
            })
        }

        let rows = if let Some(version) = event {
            conn.query(Self::TOTAL_POWER_BY_EVENT_QUERY, &[&version.0])
                .await?
        } else {
            conn.query(Self::TOTAL_POWER_BY_LAST_EVENT_QUERY, &[])
                .await?
        };
        let total_power: i64 = rows
            .get(0)
            .ok_or_else(|| Error::NotFound("can not find total power value".to_string()))?
            .try_get("total_voting_power")?;

        Ok(Delegator {
            raw_power: delegations.iter().map(|delegation| delegation.value).sum(),
            reward_address: RewardAddress::new(delegation_rows[0].try_get("reward_address")?),
            as_at: delegator_snapshot_info
                .try_get::<_, NaiveDateTime>("as_at")?
                .and_local_timezone(Utc)
                .unwrap(),
            last_updated: delegator_snapshot_info
                .try_get::<_, NaiveDateTime>("last_updated")?
                .and_local_timezone(Utc)
                .unwrap(),
            is_final: delegator_snapshot_info.try_get("final")?,
            delegations,
            total_power,
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

    #[tokio::test]
    async fn get_voter_test() {
        let event_db = establish_connection(None).await.unwrap();

        let voter = event_db
            .get_voter(&Some(EventId(1)), "voting_key_1".to_string(), true)
            .await
            .unwrap();

        assert_eq!(
            voter,
            Voter {
                voter_info: VoterInfo {
                    voting_power: 250,
                    voting_group: VoterGroupId("rep".to_string()),
                    delegations_power: 250,
                    delegations_count: 2,
                    voting_power_saturation: 0.625,
                    delegator_addresses: Some(vec![
                        "stake_public_key_1".to_string(),
                        "stake_public_key_2".to_string()
                    ]),
                },
                as_at: DateTime::<Utc>::from_utc(
                    NaiveDateTime::new(
                        NaiveDate::from_ymd_opt(2020, 3, 31).unwrap(),
                        NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                    ),
                    Utc
                ),
                last_updated: DateTime::<Utc>::from_utc(
                    NaiveDateTime::new(
                        NaiveDate::from_ymd_opt(2020, 3, 31).unwrap(),
                        NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                    ),
                    Utc
                ),
                is_final: true,
            }
        );

        let voter = event_db
            .get_voter(&Some(EventId(1)), "voting_key_1".to_string(), false)
            .await
            .unwrap();

        assert_eq!(
            voter,
            Voter {
                voter_info: VoterInfo {
                    voting_power: 250,
                    voting_group: VoterGroupId("rep".to_string()),
                    delegations_power: 250,
                    delegations_count: 2,
                    voting_power_saturation: 0.625,
                    delegator_addresses: None,
                },
                as_at: DateTime::<Utc>::from_utc(
                    NaiveDateTime::new(
                        NaiveDate::from_ymd_opt(2020, 3, 31).unwrap(),
                        NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                    ),
                    Utc
                ),
                last_updated: DateTime::<Utc>::from_utc(
                    NaiveDateTime::new(
                        NaiveDate::from_ymd_opt(2020, 3, 31).unwrap(),
                        NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                    ),
                    Utc
                ),
                is_final: true,
            }
        );

        let voter = event_db
            .get_voter(&None, "voting_key_1".to_string(), true)
            .await
            .unwrap();

        assert_eq!(
            voter,
            Voter {
                voter_info: VoterInfo {
                    voting_power: 250,
                    voting_group: VoterGroupId("rep".to_string()),
                    delegations_power: 250,
                    delegations_count: 2,
                    voting_power_saturation: 0.625,
                    delegator_addresses: Some(vec![
                        "stake_public_key_1".to_string(),
                        "stake_public_key_2".to_string()
                    ]),
                },
                as_at: DateTime::<Utc>::from_utc(
                    NaiveDateTime::new(
                        NaiveDate::from_ymd_opt(2022, 3, 31).unwrap(),
                        NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                    ),
                    Utc
                ),
                last_updated: DateTime::<Utc>::from_utc(
                    NaiveDateTime::new(
                        NaiveDate::from_ymd_opt(2022, 3, 31).unwrap(),
                        NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                    ),
                    Utc
                ),
                is_final: true,
            }
        );

        let voter = event_db
            .get_voter(&None, "voting_key_1".to_string(), false)
            .await
            .unwrap();

        assert_eq!(
            voter,
            Voter {
                voter_info: VoterInfo {
                    voting_power: 250,
                    voting_group: VoterGroupId("rep".to_string()),
                    delegations_power: 250,
                    delegations_count: 2,
                    voting_power_saturation: 0.625,
                    delegator_addresses: None,
                },
                as_at: DateTime::<Utc>::from_utc(
                    NaiveDateTime::new(
                        NaiveDate::from_ymd_opt(2022, 3, 31).unwrap(),
                        NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                    ),
                    Utc
                ),
                last_updated: DateTime::<Utc>::from_utc(
                    NaiveDateTime::new(
                        NaiveDate::from_ymd_opt(2022, 3, 31).unwrap(),
                        NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                    ),
                    Utc
                ),
                is_final: true,
            }
        );

        assert_eq!(
            event_db
                .get_voter(&None, "voting_key".to_string(), true)
                .await,
            Err(Error::NotFound("can not find voter value".to_string()))
        );
    }

    #[tokio::test]
    async fn get_delegator_test() {
        let event_db = establish_connection(None).await.unwrap();

        let delegator = event_db
            .get_delegator(&Some(EventId(1)), "stake_public_key_1".to_string())
            .await
            .unwrap();

        assert_eq!(
            delegator,
            Delegator {
                delegations: vec![
                    Delegation {
                        voting_key: "voting_key_1".to_string(),
                        group: VoterGroupId("rep".to_string()),
                        weight: 1,
                        value: 140,
                    },
                    Delegation {
                        voting_key: "voting_key_2".to_string(),
                        group: VoterGroupId("rep".to_string()),
                        weight: 1,
                        value: 100,
                    }
                ],
                reward_address: RewardAddress::new("addrrreward_address_1".to_string()),
                raw_power: 240,
                total_power: 1000,
                as_at: DateTime::<Utc>::from_utc(
                    NaiveDateTime::new(
                        NaiveDate::from_ymd_opt(2020, 3, 31).unwrap(),
                        NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                    ),
                    Utc
                ),
                last_updated: DateTime::<Utc>::from_utc(
                    NaiveDateTime::new(
                        NaiveDate::from_ymd_opt(2020, 3, 31).unwrap(),
                        NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                    ),
                    Utc
                ),
                is_final: true
            }
        );

        let delegator = event_db
            .get_delegator(&None, "stake_public_key_1".to_string())
            .await
            .unwrap();

        assert_eq!(
            delegator,
            Delegator {
                delegations: vec![
                    Delegation {
                        voting_key: "voting_key_1".to_string(),
                        group: VoterGroupId("rep".to_string()),
                        weight: 1,
                        value: 140,
                    },
                    Delegation {
                        voting_key: "voting_key_2".to_string(),
                        group: VoterGroupId("rep".to_string()),
                        weight: 1,
                        value: 100,
                    }
                ],
                reward_address: RewardAddress::new("addrrreward_address_1".to_string()),
                raw_power: 240,
                total_power: 1000,
                as_at: DateTime::<Utc>::from_utc(
                    NaiveDateTime::new(
                        NaiveDate::from_ymd_opt(2022, 3, 31).unwrap(),
                        NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                    ),
                    Utc
                ),
                last_updated: DateTime::<Utc>::from_utc(
                    NaiveDateTime::new(
                        NaiveDate::from_ymd_opt(2022, 3, 31).unwrap(),
                        NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                    ),
                    Utc
                ),
                is_final: true
            }
        );

        assert_eq!(
            event_db
                .get_delegator(&None, "stake_public_key".to_string())
                .await,
            Err(Error::NotFound("can not find delegator value".to_string()))
        );
    }
}
