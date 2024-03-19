//! Follower Queries

use cardano_chain_follower::Network;
use chrono::TimeZone;

use crate::event_db::{Error, EventDB};

/// Block time
pub type BlockTime = i64;
/// Slot
pub type SlotNumber = i64;
/// Epoch
pub type EpochNumber = i64;
/// Block hash
pub type BlockHash = String;
/// Unique follower id
pub type MachineId = String;
/// Time when a follower last indexed
pub type LastUpdate = chrono::DateTime<chrono::offset::Utc>;

impl EventDB {
    /// Index follower block stream
    pub(crate) async fn index_follower_data(
        &self, slot_no: SlotNumber, network: Network, epoch_no: EpochNumber, block_time: BlockTime,
        block_hash: BlockHash,
    ) -> Result<(), Error> {
        let conn = self.pool.get().await?;

        let timestamp: chrono::DateTime<chrono::Utc> = chrono::Utc.timestamp_nanos(block_time);

        let network = match network {
            Network::Mainnet => "mainnet".to_string(),
            Network::Preview => "preview".to_string(),
            Network::Preprod => "preprod".to_string(),
            Network::Testnet => "testnet".to_string(),
        };

        let _rows = conn
            .query(
                include_str!("../../../event-db/queries/follower/insert_slot_index.sql"),
                &[
                    &slot_no,
                    &network,
                    &epoch_no,
                    &timestamp,
                    &hex::decode(block_hash).map_err(|e| Error::DecodeHex(e.to_string()))?,
                ],
            )
            .await?;

        Ok(())
    }

    /// Check when last update occurred.
    /// Start follower from where previous follower left off.
    pub(crate) async fn last_updated_metadata(
        &self, network: String,
    ) -> Result<(SlotNumber, BlockHash, LastUpdate), Error> {
        let conn = self.pool.get().await?;

        let rows = conn
            .query(
                include_str!("../../../event-db/queries/follower/select_update_state.sql"),
                &[&network],
            )
            .await?;
        if rows.is_empty() {
            return Err(Error::NoLastUpdateMetadata("No metadata".to_string()));
        }

        let Some(row) = rows.first() else {
            return Err(Error::NoLastUpdateMetadata("No metadata".to_string()));
        };

        let slot_no: SlotNumber = match row.try_get("slot_no") {
            Ok(slot) => slot,
            Err(e) => return Err(Error::NoLastUpdateMetadata(e.to_string())),
        };

        let block_hash: BlockHash = match row.try_get::<_, Vec<u8>>("block_hash") {
            Ok(block_hash) => hex::encode(block_hash),
            Err(e) => return Err(Error::NoLastUpdateMetadata(e.to_string())),
        };
        let last_updated: LastUpdate = match row.try_get("ended") {
            Ok(last_updated) => last_updated,
            Err(e) => return Err(Error::NoLastUpdateMetadata(e.to_string())),
        };

        Ok((slot_no, block_hash, last_updated))
    }

    /// Mark point in time where the last follower finished indexing in order for future
    /// followers to pick up from this point
    pub(crate) async fn refresh_last_updated(
        &self, last_updated: LastUpdate, slot_no: SlotNumber, block_hash: BlockHash,
        network: Network, machine_id: &MachineId,
    ) -> Result<(), Error> {
        let conn = self.pool.get().await?;

        // Rollback or update
        let update = true;

        let (id, network) = match network {
            Network::Mainnet => (1, "mainnet".to_string()),
            Network::Preview => (2, "preview".to_string()),
            Network::Preprod => (3, "preprod".to_string()),
            Network::Testnet => (4, "testnet".to_string()),
        };

        // An insert only happens once when there is no update metadata available
        // All future additions are just updates on ended, slot_no and block_hash
        let _rows = conn
            .query(
                include_str!("../../../event-db/queries/follower/insert_update_state.sql"),
                &[
                    &i64::from(id),
                    &last_updated,
                    &last_updated,
                    &machine_id,
                    &slot_no,
                    &network,
                    &hex::decode(block_hash).map_err(|e| Error::DecodeHex(e.to_string()))?,
                    &update,
                    &false,
                ],
            )
            .await?;

        Ok(())
    }
}
