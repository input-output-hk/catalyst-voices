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

impl EventDB {
    /// Index follower block stream
    pub(crate) async fn index_follower_data(
        &self, slot_no: SlotNumber, network: Network, epoch_no: EpochNumber, block_time: DateTime,
        block_hash: BlockHash,
    ) -> Result<(), Error> {
        let conn = self.pool.get().await?;

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
                    &block_time,
                    &hex::decode(block_hash).map_err(|e| Error::DecodeHex(e.to_string()))?,
                ],
            )
            .await?;

        Ok(())
    }

    /// Get current slot info for the provided date-time and network
    pub(crate) async fn current_slot_info(
        &self, date_time: DateTime, network: Network,
    ) -> Result<(SlotNumber, BlockHash), Error> {
        let conn = self.pool.get().await?;

        let network = match network {
            Network::Mainnet => "mainnet".to_string(),
            Network::Preview => "preview".to_string(),
            Network::Preprod => "preprod".to_string(),
            Network::Testnet => "testnet".to_string(),
        };

        let row = conn
            .query_one(
                include_str!(
                    "../../../event-db/queries/follower/select_slot_index_by_datetime/current_slot_no.sql"
                ),
                &[&network, &date_time],
            )
            .await?;

        let slot_number: Option<SlotNumber> = row.try_get("slot_no")?;
        if let Some(slot_number) = slot_number {
            let block_hash = hex::encode(row.try_get::<_, Vec<u8>>("block_hash")?);
            Ok((slot_number, block_hash))
        } else {
            Err(Error::NotFound)
        }
    }

    /// Get next slot info for the provided date-time and network
    pub(crate) async fn next_slot_info(
        &self, date_time: DateTime, network: Network,
    ) -> Result<(SlotNumber, BlockHash), Error> {
        let conn = self.pool.get().await?;

        let network = match network {
            Network::Mainnet => "mainnet".to_string(),
            Network::Preview => "preview".to_string(),
            Network::Preprod => "preprod".to_string(),
            Network::Testnet => "testnet".to_string(),
        };

        let row = conn
            .query_one(
                include_str!(
                    "../../../event-db/queries/follower/select_slot_index_by_datetime/next_slot_no.sql"
                ),
                &[&network, &date_time],
            )
            .await?;

        let slot_number: Option<SlotNumber> = row.try_get("slot_no")?;
        if let Some(slot_number) = slot_number {
            let block_hash = hex::encode(row.try_get::<_, Vec<u8>>("block_hash")?);
            Ok((slot_number, block_hash))
        } else {
            Err(Error::NotFound)
        }
    }

    /// Check when last update occurred.
    /// Start follower from where previous follower left off.
    pub(crate) async fn last_updated_metadata(
        &self, network: Network,
    ) -> Result<(SlotNumber, BlockHash, DateTime), Error> {
        let conn = self.pool.get().await?;

        let network = match network {
            Network::Mainnet => "mainnet".to_string(),
            Network::Preview => "preview".to_string(),
            Network::Preprod => "preprod".to_string(),
            Network::Testnet => "testnet".to_string(),
        };

        let rows = conn
            .query(
                include_str!("../../../event-db/queries/follower/select_update_state.sql"),
                &[&network],
            )
            .await?;

        let Some(row) = rows.first() else {
            return Err(Error::NotFound);
        };

        let slot_no = row.try_get("slot_no")?;
        let block_hash = hex::encode(row.try_get::<_, Vec<u8>>("block_hash")?);
        let last_updated = row.try_get("ended")?;

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
                ],
            )
            .await?;

        Ok(())
    }
}
