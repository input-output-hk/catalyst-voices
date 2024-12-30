//! Integration tests of the `IndexDB` queries testing on its schema setup and integrity

use super::*;
use crate::db::index::session::CassandraSession;

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_schema() -> Result<(), String> {
    setup_test_database().await?;
    let (persistent,) = get_session()?;

    Ok(())
}
