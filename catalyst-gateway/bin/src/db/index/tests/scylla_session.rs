//! Integration tests of the `IndexDB` queries testing on its session

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_session() -> Result<(), String> {
    use crate::db::index::session::CassandraSession;

    let Some(_) = CassandraSession::get(true) else {
        return Err(String::from("Failed to acquire db session"));
    };

    Ok(())
}
