//! Integration tests of the `IndexDB` queries

use std::sync::Arc;

use super::session::CassandraSession;

mod scylla_schema;
mod scylla_session;

pub(super) async fn setup_test_database() -> Result<(), String> {
    CassandraSession::init();

    CassandraSession::wait_is_ready(core::time::Duration::from_secs(1)).await;

    if !CassandraSession::is_ready() {
        return Err(String::from("Cassandra session is not ready"));
    }

    Ok(())
}

pub(super) fn get_session() -> Result<(Arc<CassandraSession>, Arc<CassandraSession>), String> {
    let Some(persistent) = CassandraSession::get(true) else {
        return Err(String::from("Failed to acquire db session"));
    };
    let Some(volatile) = CassandraSession::get(false) else {
        return Err(String::from("Failed to acquire db session"));
    };

    Ok((persistent, volatile))
}
