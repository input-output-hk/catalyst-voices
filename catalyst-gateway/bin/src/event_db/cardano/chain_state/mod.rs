//! Follower Queries

use cardano_chain_follower::Network;
use handlebars::Handlebars;

use crate::event_db::{error::NotFoundError, EventDB};

/// Block time
pub type DateTime = chrono::DateTime<chrono::offset::Utc>;
/// Slot
pub type SlotNumber = i64;
/// Epoch
pub type EpochNumber = i64;
/// Block hash
pub type BlockHash = Vec<u8>;
/// Unique follower id
pub type MachineId = String;

/// `slot_no` column name
const SLOT_NO_COLUMN: &str = "slot_no";
/// `block_hash` column name
const BLOCK_HASH_COLUMN: &str = "block_hash";
/// `block_time` column name
const BLOCK_TIME_COLUMN: &str = "block_time";
/// `ended` column name
const ENDED_COLUMN: &str = "ended";

/// `insert_slot_index.sql`
const INSERT_SLOT_INDEX_SQL: &str = include_str!("insert_slot_index.sql");
/// `insert_update_state.sql`
const INSERT_UPDATE_STATE_SQL: &str = include_str!("insert_update_state.sql");
/// `select_update_state.sql`
const SELECT_UPDATE_STATE_SQL: &str = include_str!("select_update_state.sql");
/// `select_slot_info_by_datetime.sql.hbs`
const SLOT_INFO_SQL_HBS: &str = include_str!("select_slot_info_by_datetime.sql.hbs");

/// Query type
pub(crate) enum SlotInfoQueryType {
    /// Previous slot info query type
    Previous,
    /// Current slot info query type
    Current,
    /// Next slot info query type
    Next,
}

/// Slot info query template fields
#[derive(serde::Serialize)]
struct SlotInfoQueryTmplFields {
    /// `sign` field from the sql template
    sign: &'static str,
    /// `ordering` field from the sql template
    ordering: Option<&'static str>,
}

impl SlotInfoQueryType {
    /// Get SQL query
    fn get_sql_query(&self) -> anyhow::Result<String> {
        let tmpl_fields = match self {
            SlotInfoQueryType::Previous => {
                SlotInfoQueryTmplFields {
                    sign: "<",
                    ordering: Some("DESC"),
                }
            },
            SlotInfoQueryType::Current => {
                SlotInfoQueryTmplFields {
                    sign: "=",
                    ordering: None,
                }
            },
            SlotInfoQueryType::Next => {
                SlotInfoQueryTmplFields {
                    sign: ">",
                    ordering: None,
                }
            },
        };

        let mut reg = Handlebars::new();
        // disable default `html_escape` function
        // which transforms `<`, `>` symbols to `&lt`, `&gt`
        reg.register_escape_fn(|s| s.into());
        Ok(reg.render_template(SLOT_INFO_SQL_HBS, &tmpl_fields)?)
    }
}

impl EventDB {
    /// Index follower block stream
    pub(crate) async fn index_follower_data(
        &self, slot_no: SlotNumber, network: Network, epoch_no: EpochNumber, block_time: DateTime,
        block_hash: BlockHash,
    ) -> anyhow::Result<()> {
        self.modify(INSERT_SLOT_INDEX_SQL, &[
            &slot_no,
            &network.to_string(),
            &epoch_no,
            &block_time,
            &block_hash,
        ])
        .await?;

        Ok(())
    }

    /// Get slot info for the provided date-time and network and query type
    pub(crate) async fn get_slot_info(
        &self, date_time: DateTime, network: Network, query_type: SlotInfoQueryType,
    ) -> anyhow::Result<(SlotNumber, BlockHash, DateTime)> {
        let rows = self
            .query(&query_type.get_sql_query()?, &[
                &network.to_string(),
                &date_time,
            ])
            .await?;

        let row = rows.first().ok_or(NotFoundError)?;

        let slot_number: SlotNumber = row.try_get(SLOT_NO_COLUMN)?;
        let block_hash = row.try_get(BLOCK_HASH_COLUMN)?;
        let block_time = row.try_get(BLOCK_TIME_COLUMN)?;
        Ok((slot_number, block_hash, block_time))
    }

    /// Check when last update chain state occurred.
    pub(crate) async fn last_updated_state(
        &self, network: Network,
    ) -> anyhow::Result<(SlotNumber, BlockHash, DateTime)> {
        let rows = self
            .query(SELECT_UPDATE_STATE_SQL, &[&network.to_string()])
            .await?;

        let row = rows.first().ok_or(NotFoundError)?;

        let slot_no = row.try_get(SLOT_NO_COLUMN)?;
        let block_hash = row.try_get(BLOCK_HASH_COLUMN)?;
        let last_updated = row.try_get(ENDED_COLUMN)?;

        Ok((slot_no, block_hash, last_updated))
    }

    /// Mark point in time where the last follower finished indexing in order for future
    /// followers to pick up from this point
    pub(crate) async fn refresh_last_updated(
        &self, last_updated: DateTime, slot_no: SlotNumber, block_hash: BlockHash,
        network: Network, machine_id: &MachineId,
    ) -> anyhow::Result<()> {
        // Rollback or update
        let update = true;

        let network_id: u64 = network.into();

        // An insert only happens once when there is no update metadata available
        // All future additions are just updates on ended, slot_no and block_hash
        self.modify(INSERT_UPDATE_STATE_SQL, &[
            &i64::try_from(network_id)?,
            &last_updated,
            &last_updated,
            &machine_id,
            &slot_no,
            &network.to_string(),
            &block_hash,
            &update,
        ])
        .await?;

        Ok(())
    }
}
