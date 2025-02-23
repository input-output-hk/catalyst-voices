//! RBAC indexing tests that require a database connection.

use std::collections::HashMap;

use crate::db::index::{
    block::rbac509::Rbac509InsertQuery,
    tests::{get_shared_session, test_utils, SESSION_ERR_MSG},
};

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn index() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let block = test_utils::block_3();
    let mut query = Rbac509InsertQuery::new();
    let txn_hash = "1bf8eb4da8fe5910cc890025deb9740ba5fa4fd2ac418ccbebfd6a09ed10e88b"
        .parse()
        .unwrap();
    let mut catalyst_id_by_txn_id = HashMap::new();
    query
        .index(
            &session,
            txn_hash,
            0.into(),
            &block,
            &mut catalyst_id_by_txn_id,
        )
        .await;
    assert!(query.invalid.is_empty());
    assert_eq!(1, query.registrations.len());
    assert_eq!(1, query.catalyst_id_for_txn_id.len());
    assert_eq!(1, query.catalyst_id_for_stake_address.len());
}

// This block contains a registration without a Catalyst ID, so it wouldn't be indexed at
// all.
#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn index_invalid() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let block = test_utils::block_4();
    let mut query = Rbac509InsertQuery::new();
    let txn_hash = "337d35026efaa48b5ee092d38419e102add1b535364799eb8adec8ac6d573b79"
        .parse()
        .unwrap();
    let mut catalyst_id_by_txn_id = HashMap::new();
    query
        .index(
            &session,
            txn_hash,
            0.into(),
            &block,
            &mut catalyst_id_by_txn_id,
        )
        .await;
    assert!(query.invalid.is_empty());
    assert!(query.registrations.is_empty());
    assert!(query.catalyst_id_for_txn_id.is_empty());
    assert!(query.catalyst_id_for_stake_address.is_empty());
}
