//! Registration Queries
use chrono::{NaiveDateTime, Utc};

use crate::db::event::{
    error::NotFoundError,
    legacy::types::{
        event::EventId,
        registration::{Delegation, Delegator, RewardAddress, Voter, VoterGroupId, VoterInfo},
    },
    EventDB,
};

impl EventDB {
    /// Delegations by event query template
    const DELEGATIONS_BY_EVENT_QUERY: &'static str = "SELECT contribution.voting_key, contribution.voting_group, contribution.voting_weight, contribution.value, contribution.reward_address
                                                FROM contribution
                                                INNER JOIN snapshot ON contribution.snapshot_id = snapshot.row_id
                                                WHERE contribution.stake_public_key = $1 AND snapshot.event = $2;";
    /// Delegator snapshot info by event query template
    const DELEGATOR_SNAPSHOT_INFO_BY_EVENT_QUERY: &'static str = "
                                                SELECT snapshot.as_at, snapshot.last_updated, snapshot.final
                                                FROM snapshot
                                                WHERE snapshot.event = $1
                                                LIMIT 1;";
    /// Delegator snapshot info by last event query template
    const DELEGATOR_SNAPSHOT_INFO_BY_LAST_EVENT_QUERY: &'static str = "SELECT snapshot.event, snapshot.as_at, snapshot.last_updated, snapshot.final
                                                FROM snapshot
                                                WHERE snapshot.last_updated = (SELECT MAX(snapshot.last_updated) as last_updated from snapshot)
                                                LIMIT 1;";
    /// Total By Event Query template
    const TOTAL_BY_EVENT_VOTING_QUERY: &'static str =
        "SELECT SUM(voter.voting_power)::BIGINT as total_voting_power
        FROM voter
        INNER JOIN snapshot ON voter.snapshot_id = snapshot.row_id
        WHERE voter.voting_group = $1 AND snapshot.event = $2;";
    /// Total By Last Event Query template
    const TOTAL_BY_LAST_EVENT_VOTING_QUERY: &'static str =
        "SELECT SUM(voter.voting_power)::BIGINT as total_voting_power
        FROM voter
        INNER JOIN snapshot ON voter.snapshot_id = snapshot.row_id AND snapshot.last_updated = (SELECT MAX(snapshot.last_updated) as last_updated from snapshot)
        WHERE voter.voting_group = $1;";
    /// Total voting power by event query template
    const TOTAL_POWER_BY_EVENT_QUERY: &'static str = "SELECT SUM(voter.voting_power)::BIGINT as total_voting_power
                                                FROM voter
                                                INNER JOIN snapshot ON voter.snapshot_id = snapshot.row_id
                                                WHERE snapshot.event = $1;";
    /// Total voting power by last event query template
    const TOTAL_POWER_BY_LAST_EVENT_QUERY: &'static str = "SELECT SUM(voter.voting_power)::BIGINT as total_voting_power
                                                FROM voter
                                                INNER JOIN snapshot ON voter.snapshot_id = snapshot.row_id
                                                WHERE snapshot.last_updated = (SELECT MAX(snapshot.last_updated) as last_updated from snapshot);";
    /// Voter By Event Query template
    const VOTER_BY_EVENT_QUERY: &'static str = "SELECT voter.voting_key, voter.voting_group, voter.voting_power, snapshot.as_at, snapshot.last_updated, snapshot.final, SUM(contribution.value)::BIGINT as delegations_power, COUNT(contribution.value) AS delegations_count
                                            FROM voter
                                            INNER JOIN snapshot ON voter.snapshot_id = snapshot.row_id
                                            INNER JOIN contribution ON contribution.snapshot_id = snapshot.row_id
                                            WHERE voter.voting_key = $1 AND contribution.voting_key = $1 AND snapshot.event = $2
                                            GROUP BY voter.voting_key, voter.voting_group, voter.voting_power, snapshot.as_at, snapshot.last_updated, snapshot.final;";
    /// Voter By Last Event Query template
    const VOTER_BY_LAST_EVENT_QUERY: &'static str = "SELECT snapshot.event, voter.voting_key, voter.voting_group, voter.voting_power, snapshot.as_at, snapshot.last_updated, snapshot.final, SUM(contribution.value)::BIGINT as delegations_power, COUNT(contribution.value) AS delegations_count
                                                FROM voter
                                                INNER JOIN snapshot ON voter.snapshot_id = snapshot.row_id
                                                INNER JOIN contribution ON contribution.snapshot_id = snapshot.row_id
                                                WHERE voter.voting_key = $1 AND contribution.voting_key = $1 AND snapshot.last_updated = (SELECT MAX(snapshot.last_updated) as last_updated from snapshot)
                                                GROUP BY snapshot.event, voter.voting_key, voter.voting_group, voter.voting_power, snapshot.as_at, snapshot.last_updated, snapshot.final;";
    /// Voter Delegators List Query template
    const VOTER_DELEGATORS_LIST_QUERY: &'static str = "SELECT contribution.stake_public_key
                                                FROM contribution
                                                INNER JOIN snapshot ON contribution.snapshot_id = snapshot.row_id
                                                WHERE contribution.voting_key = $1 AND snapshot.event = $2;";
}

impl EventDB {
    /// Get voter query
    #[allow(dead_code)]
    pub(crate) async fn get_voter(
        event: &Option<EventId>, voting_key: String, with_delegations: bool,
    ) -> anyhow::Result<Voter> {
        let rows = if let Some(event) = event {
            Self::query(Self::VOTER_BY_EVENT_QUERY, &[&voting_key, &event.0]).await?
        } else {
            Self::query(Self::VOTER_BY_LAST_EVENT_QUERY, &[&voting_key]).await?
        };
        let voter = rows.first().ok_or(NotFoundError)?;

        let voting_group = VoterGroupId(voter.try_get("voting_group")?);
        let voting_power = voter.try_get("voting_power")?;

        let rows = if let Some(event) = event {
            Self::query(Self::TOTAL_BY_EVENT_VOTING_QUERY, &[
                &voting_group.0,
                &event.0,
            ])
            .await?
        } else {
            Self::query(Self::TOTAL_BY_LAST_EVENT_VOTING_QUERY, &[&voting_group.0]).await?
        };

        let total_voting_power_per_group: i64 = rows
            .first()
            .ok_or(NotFoundError)?
            .try_get("total_voting_power")?;

        let voting_power_saturation = if total_voting_power_per_group == 0 {
            0_f64
        } else {
            #[allow(clippy::cast_precision_loss)]
            let vp = voting_power as f64;

            #[allow(clippy::cast_precision_loss)]
            let vp_per_group = total_voting_power_per_group as f64;

            vp / vp_per_group
        };

        let delegator_addresses = if with_delegations {
            let rows = if let Some(event) = event {
                Self::query(Self::VOTER_DELEGATORS_LIST_QUERY, &[&voting_key, &event.0]).await?
            } else {
                Self::query(Self::VOTER_DELEGATORS_LIST_QUERY, &[
                    &voting_key,
                    &voter.try_get::<_, i32>("event")?,
                ])
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
            info: VoterInfo {
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

    /// Get delegator query
    #[allow(dead_code)]
    pub(crate) async fn get_delegator(
        event: &Option<EventId>, stake_public_key: String,
    ) -> anyhow::Result<Delegator> {
        let rows = if let Some(event) = event {
            Self::query(Self::DELEGATOR_SNAPSHOT_INFO_BY_EVENT_QUERY, &[&event.0]).await?
        } else {
            Self::query(Self::DELEGATOR_SNAPSHOT_INFO_BY_LAST_EVENT_QUERY, &[]).await?
        };
        let delegator_snapshot_info = rows.first().ok_or(NotFoundError)?;

        let delegation_rows = if let Some(event) = event {
            Self::query(Self::DELEGATIONS_BY_EVENT_QUERY, &[
                &stake_public_key,
                &event.0,
            ])
            .await?
        } else {
            Self::query(Self::DELEGATIONS_BY_EVENT_QUERY, &[
                &stake_public_key,
                &delegator_snapshot_info.try_get::<_, i32>("event")?,
            ])
            .await?
        };
        if delegation_rows.is_empty() {
            return Err(NotFoundError.into());
        }

        let mut delegations = Vec::new();
        for row in &delegation_rows {
            delegations.push(Delegation {
                voting_key: row.try_get("voting_key")?,
                group: VoterGroupId(row.try_get("voting_group")?),
                weight: row.try_get("voting_weight")?,
                value: row.try_get("value")?,
            });
        }

        let rows = if let Some(version) = event {
            Self::query(Self::TOTAL_POWER_BY_EVENT_QUERY, &[&version.0]).await?
        } else {
            Self::query(Self::TOTAL_POWER_BY_LAST_EVENT_QUERY, &[]).await?
        };
        let total_power: i64 = rows
            .first()
            .ok_or(NotFoundError)?
            .try_get("total_voting_power")?;

        #[allow(clippy::indexing_slicing)] // delegation_rows already checked to be not empty.
        let reward_address = RewardAddress::new(delegation_rows[0].try_get("reward_address")?);

        Ok(Delegator {
            raw_power: delegations.iter().map(|delegation| delegation.value).sum(),
            reward_address,
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
