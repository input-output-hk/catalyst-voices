//! Integration tests of the `IndexDB` queries
//! This module contains utility functions used with different testing modules.

use std::{process, sync::Arc};

use tokio::sync::OnceCell;

use super::session::CassandraSession;

mod scylla_queries;
mod scylla_session;

static SHARED_SESSION: OnceCell<Result<(), String>> = OnceCell::const_new();

async fn setup_test_database() -> Result<(), String> {
    CassandraSession::init();

    if let Err(err) =
        CassandraSession::wait_until_ready(core::time::Duration::from_secs(1), false).await
    {
        return Err(format!("{:?}", err));
    }

    if !CassandraSession::is_ready() {
        return Err(String::from("Cassandra session is not ready"));
    }

    Ok(())
}

fn get_session() -> Result<(Arc<CassandraSession>, Arc<CassandraSession>), String> {
    let Some(persistent) = CassandraSession::get(true) else {
        return Err(String::from("Failed to acquire db session"));
    };
    let Some(volatile) = CassandraSession::get(false) else {
        return Err(String::from("Failed to acquire db session"));
    };

    Ok((persistent, volatile))
}

async fn get_shared_session() -> Result<(Arc<CassandraSession>, Arc<CassandraSession>), String> {
    SHARED_SESSION.get_or_init(setup_test_database).await;

    if let Some(Err(err)) = SHARED_SESSION.get() {
        println!("{:?}", err);
        process::exit(1);
    }

    get_session()
}
