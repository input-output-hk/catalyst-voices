//! Follower Queries

use cardano_chain_follower::Network;

use crate::event_db::{Error, EventDB};

/// Block time
pub type DateTime = chrono::DateTime<chrono::offset::Utc>;
/// Slot
pub type SlotNumber = i64;
/// Epoch
pub type EpochNumber = i64;
/// Block hash
pub type BlockHash = String;
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

/// Query type
pub(crate) enum SlotInfoQueryType {
    Previous,
    Current,
    Next,
}

impl EventDB {
    /// Index follower block stream
    pub(crate) async fn index_follower_data(
        &self, slot_no: SlotNumber, network: Network, epoch_no: EpochNumber, block_time: DateTime,
        block_hash: BlockHash,
    ) -> Result<(), Error> {
        let conn = self.pool.get().await?;

        let _rows = conn
            .query(
                include_str!("../../../event-db/queries/follower/insert_slot_index.sql"),
                &[
                    &slot_no,
                    &network.to_string(),
                    &epoch_no,
                    &block_time,
                    &hex::decode(block_hash).map_err(|e| Error::DecodeHex(e.to_string()))?,
                ],
            )
            .await?;

        Ok(())
    }

    /// Get slot info for the provided date-time and network and query type
    pub(crate) async fn get_slot_info(
        &self, date_time: DateTime, network: Network, query_type: SlotInfoQueryType,
    ) -> Result<(SlotNumber, BlockHash, DateTime), Error> {
        let conn = self.pool.get().await?;

        let rows = conn
            .query(
                match query_type {
                    SlotInfoQueryType::Previous => include_str!(
                        "../../../event-db/queries/follower/select_slot_index_by_datetime/previous_slot_info.sql"
                    ),
                    SlotInfoQueryType::Current => include_str!(
                        "../../../event-db/queries/follower/select_slot_index_by_datetime/current_slot_info.sql"
                    ),
                    SlotInfoQueryType::Next => include_str!(
                        "../../../event-db/queries/follower/select_slot_index_by_datetime/next_slot_info.sql"
                    ),
                },
                &[&network.to_string(), &date_time],
            )
            .await?;

        let Some(row) = rows.first() else {
            return Err(Error::NotFound);
        };

        let slot_number: SlotNumber = row.try_get(SLOT_NO_COLUMN)?;
        let block_hash = hex::encode(row.try_get::<_, Vec<u8>>(BLOCK_HASH_COLUMN)?);
        let block_time = row.try_get(BLOCK_TIME_COLUMN)?;
        Ok((slot_number, block_hash, block_time))
    }

    /// Check when last update occurred.
    /// Start follower from where previous follower left off.
    pub(crate) async fn last_updated_metadata(
        &self, network: Network,
    ) -> Result<(SlotNumber, BlockHash, DateTime), Error> {
        let conn = self.pool.get().await?;

        let rows = conn
            .query(
                include_str!("../../../event-db/queries/follower/select_update_state.sql"),
                &[&network.to_string()],
            )
            .await?;

        let Some(row) = rows.first() else {
            return Err(Error::NotFound);
        };

        let slot_no = row.try_get(SLOT_NO_COLUMN)?;
        let block_hash = hex::encode(row.try_get::<_, Vec<u8>>(BLOCK_HASH_COLUMN)?);
        let last_updated = row.try_get(ENDED_COLUMN)?;

        Ok((slot_no, block_hash, last_updated))
    }

    /// Mark point in time where the last follower finished indexing in order for future
    /// followers to pick up from this point
    pub(crate) async fn refresh_last_updated(
        &self, last_updated: DateTime, slot_no: SlotNumber, block_hash: BlockHash,
        network: Network, machine_id: &MachineId,
    ) -> Result<(), Error> {
        let conn = self.pool.get().await?;

        // Rollback or update
        let update = true;

        let network_id: u64 = network.into();

        // An insert only happens once when there is no update metadata available
        // All future additions are just updates on ended, slot_no and block_hash
        let _rows = conn
            .query(
                include_str!("../../../event-db/queries/follower/insert_update_state.sql"),
                &[
                    &i64::try_from(network_id)
                        .map_err(|_| Error::Unknown("Network id out of range".to_string()))?,
                    &last_updated,
                    &last_updated,
                    &machine_id,
                    &slot_no,
                    &network.to_string(),
                    &hex::decode(block_hash).map_err(|e| Error::DecodeHex(e.to_string()))?,
                    &update,
                ],
            )
            .await?;

        Ok(())
    }
}
