//! Integration tests of the `IndexDB` queries testing on its session

use crate::db::index::session::CassandraSession;

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_session() -> Result<(), String> {
    CassandraSession::init();

    CassandraSession::wait_is_ready(core::time::Duration::from_secs(1)).await;

    if !CassandraSession::is_ready() {
        return Err(String::from("Cassandra session is not ready"));
    }

    let Some(_) = CassandraSession::get(true) else {
        return Err(String::from("Failed to acquire db session"));
    };

    Ok(())
}
