//! Follower Queries

use async_trait::async_trait;
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
/// Uniuque follower id
pub type MachineId = String;
/// Time when a follower last indexed
pub type LastUpdate = chrono::DateTime<chrono::offset::Utc>;

#[async_trait]
#[allow(clippy::module_name_repetitions)]
/// Follower Queries Trait
pub(crate) trait FollowerQueries: Sync + Send + 'static {
    async fn index_follower_data(
        &self, slot_no: SlotNumber, network: Network, epoch_no: EpochNumber, block_time: BlockTime,
        block_hash: BlockHash,
    ) -> Result<(), Error>;

    async fn last_updated_metadata(
        &self, network: String,
    ) -> Result<(SlotNumber, BlockHash, LastUpdate), Error>;

    async fn refresh_last_updated(
        &self, last_updated: LastUpdate, slot_no: SlotNumber, block_hash: BlockHash,
        network: Network, machine_id: &MachineId,
    ) -> Result<(), Error>;
}

impl EventDB {
    /// Update db with follower data
    const INDEX_FOLLOWER_QUERY: &'static str =
        "INSERT INTO cardano_slot_index(slot_no, network, epoch_no, block_time, block_hash) VALUES($1, $2, $3, $4, $5)";
    /// If no last updated metadata, init with metadata. If present update metadata.
    const LAST_UPDATED_QUERY: &'static str =
        "INSERT INTO cardano_update_state(id, started, ended, updater_id ,slot_no, network, block_hash, update) VALUES($1, $2, $3 , $4, $5, $6, $7, $8) ON CONFLICT(id) DO UPDATE SET ended = $2, slot_no = $5, block_hash = $7;";
    /// Start follower from where previous follower left off.
    const START_FROM_QUERY: &'static str =
        "SELECT network, slot_no, block_hash, ended FROM cardano_update_state WHERE network = $1;";
}

#[async_trait]
impl FollowerQueries for EventDB {
    /// Index follower block stream
    async fn index_follower_data(
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
            .query(Self::INDEX_FOLLOWER_QUERY, &[
                &slot_no,
                &network,
                &epoch_no,
                &timestamp,
                &hex::decode(block_hash).map_err(|e| Error::DecodeHex(e.to_string()))?,
            ])
            .await?;

        Ok(())
    }

    /// Check when last update occurred
    async fn last_updated_metadata(
        &self, network: String,
    ) -> Result<(SlotNumber, BlockHash, LastUpdate), Error> {
        let conn = self.pool.get().await?;

        let rows = conn.query(Self::START_FROM_QUERY, &[&network]).await?;
        if rows.is_empty() {
            return Err(Error::NoLastUpdateMetadata("No metadata".to_string()));
        }

        let slot_no: SlotNumber = match rows[0].try_get("slot_no") {
            Ok(slot) => slot,
            Err(e) => return Err(Error::NoLastUpdateMetadata(e.to_string())),
        };

        let block_hash: BlockHash = match rows[0].try_get("block_hash") {
            Ok(block_hash) => block_hash,
            Err(e) => return Err(Error::NoLastUpdateMetadata(e.to_string())),
        };
        let last_updated: LastUpdate = match rows[0].try_get("ended") {
            Ok(last_updated) => last_updated,
            Err(e) => return Err(Error::NoLastUpdateMetadata(e.to_string())),
        };

        Ok((slot_no, block_hash, last_updated))
    }

    /// Mark point in time where the last follower finished indexing in order for future
    /// followers to pick up from this point
    async fn refresh_last_updated(
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
            .query(Self::LAST_UPDATED_QUERY, &[
                &i64::from(id),
                &last_updated,
                &last_updated,
                &machine_id,
                &slot_no,
                &network,
                &block_hash,
                &update,
            ])
            .await?;

        Ok(())
    }
}
