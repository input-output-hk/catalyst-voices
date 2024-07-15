//! Index Schema

use std::time::Duration;

use super::session::CassandraSession;

/// The version of the Schema we are using.
pub(crate) const SCHEMA_VERSION: u64 = 1;

/// Create the Schema on the connected Cassandra DB
pub(crate) async fn create_schema(_session: CassandraSession) {
    tokio::time::sleep(Duration::from_secs(2)).await;
}
