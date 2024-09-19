//! Follower Queries

use cardano_chain_follower::Network;
use handlebars::Handlebars;
use pallas::ledger::traverse::{wellknown::GenesisValues, MultiEraBlock};
use tokio_postgres::{binary_copy::BinaryCopyInWriter, types::Type};
use tracing::error;

use crate::db::event::{error::NotFoundError, Error, EventDB, EVENT_DB_POOL};

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

/// Params required for indexing follower data.
pub(crate) struct IndexedFollowerDataParams<'a> {
    /// Block's slot number.
    pub slot_no: SlotNumber,
    /// Block's epoch number.
    pub epoch_no: EpochNumber,
    /// Block's network.
    pub network: &'a str,
    /// Block's time.
    pub block_time: DateTime,
    /// Block's hash.
    pub block_hash: Vec<u8>,
}

impl<'a> IndexedFollowerDataParams<'a> {
    /// Creates a [`IndexedFollowerDataParams`] from block data.
    #[allow(dead_code)]
    pub(crate) fn from_block_data(
        genesis_values: &GenesisValues, network: &'a str, block: &MultiEraBlock<'a>,
    ) -> Option<Self> {
        let epoch = match block.epoch(genesis_values).0.try_into() {
            Ok(epoch) => epoch,
            Err(err) => {
                error!("Cannot parse epoch from {network:?} block {err} - skip..");
                return None;
            },
        };

        let wallclock = match block.wallclock(genesis_values).try_into() {
            Ok(time) => chrono::DateTime::from_timestamp(time, 0).unwrap_or_default(),
            Err(err) => {
                error!("Cannot parse wall time from {network:?} block {err} - skip..");
                return None;
            },
        };

        let slot = match block.slot().try_into() {
            Ok(slot) => slot,
            Err(err) => {
                error!("Cannot parse slot from {network:?} block {err} - skip..");
                return None;
            },
        };

        Some(IndexedFollowerDataParams {
            slot_no: slot,
            network,
            epoch_no: epoch,
            block_time: wallclock,
            block_hash: block.hash().to_vec(),
        })
    }
}

impl EventDB {
    /// Batch writes follower data.
    #[allow(dead_code)]
    pub(crate) async fn index_many_follower_data(
        values: &[IndexedFollowerDataParams<'_>],
    ) -> anyhow::Result<()> {
        if values.is_empty() {
            return Ok(());
        }

        let pool = EVENT_DB_POOL.get().ok_or(Error::DbPoolUninitialized)?;
        let mut conn = pool.get().await?;
        let tx = conn.transaction().await?;

        tx.execute(
            "CREATE TEMPORARY TABLE tmp_cardano_slot_index (LIKE cardano_slot_index) ON COMMIT DROP",
            &[],
        )
        .await?;

        {
            let sink = tx
                .copy_in("COPY tmp_cardano_slot_index (slot_no, network, epoch_no, block_time, block_hash) FROM STDIN BINARY")
                .await?;
            let writer = BinaryCopyInWriter::new(sink, &[
                Type::INT8,
                Type::TEXT,
                Type::INT8,
                Type::TIMESTAMPTZ,
                Type::BYTEA,
            ]);
            tokio::pin!(writer);

            for params in values {
                #[allow(trivial_casts)]
                writer
                    .as_mut()
                    .write(&[
                        &params.slot_no as &(dyn tokio_postgres::types::ToSql + Sync),
                        &params.network,
                        &params.epoch_no,
                        &params.block_time,
                        &params.block_hash,
                    ])
                    .await?;
            }

            writer.finish().await?;
        }

        tx.execute("INSERT INTO cardano_slot_index (slot_no, network, epoch_no, block_time, block_hash) SELECT slot_no, network, epoch_no, block_time, block_hash FROM tmp_cardano_slot_index ON CONFLICT DO NOTHING", &[]).await?;
        tx.commit().await?;

        Ok(())
    }

    /// Get slot info for the provided date-time and network and query type
    pub(crate) async fn get_slot_info(
        date_time: DateTime, network: Network, query_type: SlotInfoQueryType,
    ) -> anyhow::Result<(SlotNumber, BlockHash, DateTime)> {
        let rows = Self::query(&query_type.get_sql_query()?, &[
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
        network: Network,
    ) -> anyhow::Result<(SlotNumber, BlockHash, DateTime)> {
        let rows = Self::query(SELECT_UPDATE_STATE_SQL, &[&network.to_string()]).await?;

        let row = rows.first().ok_or(NotFoundError)?;

        let slot_no = row.try_get(SLOT_NO_COLUMN)?;
        let block_hash = row.try_get(BLOCK_HASH_COLUMN)?;
        let last_updated = row.try_get(ENDED_COLUMN)?;

        Ok((slot_no, block_hash, last_updated))
    }

    /// Mark point in time where the last follower finished indexing in order for future
    /// followers to pick up from this point
    #[allow(dead_code)]
    pub(crate) async fn refresh_last_updated(
        last_updated: DateTime, slot_no: SlotNumber, block_hash: BlockHash, network: Network,
        machine_id: &MachineId,
    ) -> anyhow::Result<()> {
        // Rollback or update
        let update = true;

        let network_id: u64 = network.into();

        // An insert only happens once when there is no update metadata available
        // All future additions are just updates on ended, slot_no and block_hash
        Self::modify(INSERT_UPDATE_STATE_SQL, &[
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
