//! Follower Queries
use async_trait::async_trait;
use chrono::TimeZone;

use crate::event_db::Error;
use crate::event_db::EventDB;

#[async_trait]
#[allow(clippy::module_name_repetitions)]
/// Follower Queries Trait
pub(crate) trait FollowerQueries: Sync + Send + 'static {
    async fn updates_from_follower(&self) -> Result<(), Error>;
}

impl EventDB {
    /// Update db with follower data
    const FOLLOWER_QUERY: &'static str =
        "INSERT INTO cardano_slot_index(slot_no, network, epoch_no, block_time, block_hash) VALUES($1, $2, $3, $4, $5)";
}

#[async_trait]
impl FollowerQueries for EventDB {
    async fn updates_from_follower(&self) -> Result<(), Error> {
        let conn = self.pool.get().await?;

        let ts: chrono::DateTime<chrono::Utc> = chrono::Utc.timestamp_nanos(1234567890);

        let _rows = conn
            .query(
                Self::FOLLOWER_QUERY,
                &[
                    &i64::from(1),
                    &"mainnet",
                    &i64::from(1),
                    &ts,
                    &hex::decode(
                        "f2f25bc19b8eb450a63faa4115be199ec2b1e1902ebb82f8d1455146bbfa6d87",
                    )
                    .unwrap(),
                ],
            )
            .await?;

        Ok(())
    }
}
