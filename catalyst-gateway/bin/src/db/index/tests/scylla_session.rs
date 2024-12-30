//! Integration tests of the `IndexDB` queries testing on its session

use super::*;
use crate::db::index::session::CassandraSession;

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_session() -> Result<(), String> {
    setup_test_database().await?;
    get_session()?;

    Ok(())
}
