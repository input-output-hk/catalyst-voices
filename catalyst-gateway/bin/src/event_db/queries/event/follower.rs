//! Follower Queries
use async_trait::async_trait;

use chrono::DateTime;
use chrono::TimeZone;
use chrono::Utc;

use crate::event_db::Error;
use crate::event_db::EventDB;

#[async_trait]
#[allow(clippy::module_name_repetitions)]
/// Follower Queries Trait
pub(crate) trait FollowerQueries: Sync + Send + 'static {
    async fn updates_from_follower(
        &self, slot_no: i64, network: String, epoch_no: i64, block_time: i64, block_hash: String,
    ) -> Result<(), Error>;

    async fn bootstrap_follower_from(
        &self, network: String,
    ) -> Result<(i64, String, DateTime<Utc>), Error>;

    async fn last_updated(&self, last_updated: DateTime<Utc>) -> Result<(), Error>;
}

impl EventDB {
    /// Update db with follower data
    const INDEX_FOLLOWER_QUERY: &'static str =
        "INSERT INTO cardano_slot_index(slot_no, network, epoch_no, block_time, block_hash) VALUES($1, $2, $3, $4, $5)";
    /// Bootstrap follower from last stopping point in the context of epoch and slot.
    const START_FROM_QUERY: &'static str =
        "SELECT network, slot_no, block_hash, ended FROM cardano_update_state WHERE network = $1;";
    /// Last updated
    const LAST_UPDATED_QUERY: &'static str = " update cardano_update_state set ended = $;"; // update slot nos for both networks
}

#[async_trait]
impl FollowerQueries for EventDB {
    /// Index follower block stream
    async fn updates_from_follower(
        &self, slot_no: i64, network: String, epoch_no: i64, block_time: i64, block_hash: String,
    ) -> Result<(), Error> {
        let conn = self.pool.get().await?;

        let ts: chrono::DateTime<chrono::Utc> = chrono::Utc.timestamp_nanos(block_time);

        let _rows = conn
            .query(
                Self::INDEX_FOLLOWER_QUERY,
                &[
                    &i64::from(slot_no),
                    &network,
                    &i64::from(epoch_no),
                    &ts,
                    &hex::decode(block_hash).unwrap(),
                ],
            )
            .await?;

        Ok(())
    }

    /// Check when last update occurred
    async fn bootstrap_follower_from(
        &self, network: String,
    ) -> Result<(i64, String, DateTime<Utc>), Error> {
        let conn = self.pool.get().await?;

        let rows = conn.query(Self::START_FROM_QUERY, &[&network]).await?;

        let slot_no: i64 = rows[0].try_get("slot_no").unwrap();
        let block_hash: String = rows[0].try_get("block_hash").unwrap();
        let last_updated: chrono::DateTime<chrono::offset::Utc> = rows[0].try_get("ended").unwrap();

        Ok((slot_no, block_hash, last_updated))
    }

    /// Last updated
    async fn last_updated(&self, last_updated: DateTime<Utc>) -> Result<(), Error> {
        let conn = self.pool.get().await?;

        let _rows = conn
            .query(Self::LAST_UPDATED_QUERY, &[&last_updated])
            .await?;

        Ok(())
    }
}
