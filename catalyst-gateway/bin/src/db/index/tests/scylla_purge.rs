//! Integration tests of the `IndexDB` queries testing on its session.
//! This is mainly to test whether the defined queries work with the database or not.

use futures::StreamExt;

use super::*;
use crate::db::index::queries::purge::*;

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_chain_root_for_role0_key() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream = chain_root_for_role0_key::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }

    let row_stream = chain_root_for_role0_key::DeleteQuery::execute(&session, vec![])
        .await
        .unwrap();

    for row in row_stream {
        drop(row.into_rows_result().unwrap());
    }
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_chain_root_for_stake_address() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream = chain_root_for_stake_address::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }

    let row_stream = chain_root_for_stake_address::DeleteQuery::execute(&session, vec![])
        .await
        .unwrap();

    for row in row_stream {
        drop(row.into_rows_result().unwrap());
    }
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_chain_root_for_txn_id() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream = chain_root_for_txn_id::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }

    let row_stream = chain_root_for_txn_id::DeleteQuery::execute(&session, vec![])
        .await
        .unwrap();

    for row in row_stream {
        drop(row.into_rows_result().unwrap());
    }
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_cip36_registration_for_vote_key() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream = cip36_registration_for_vote_key::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }

    let row_stream = cip36_registration_for_vote_key::DeleteQuery::execute(&session, vec![])
        .await
        .unwrap();

    for row in row_stream {
        drop(row.into_rows_result().unwrap());
    }
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_cip36_registration_invalid() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream = cip36_registration_invalid::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }

    let row_stream = cip36_registration_invalid::DeleteQuery::execute(&session, vec![])
        .await
        .unwrap();

    for row in row_stream {
        drop(row.into_rows_result().unwrap());
    }
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_cip36_registration() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream = cip36_registration::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }

    let row_stream = cip36_registration::DeleteQuery::execute(&session, vec![])
        .await
        .unwrap();

    for row in row_stream {
        drop(row.into_rows_result().unwrap());
    }
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_rbac509_registration() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream = rbac509_registration::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }

    let row_stream = rbac509_registration::DeleteQuery::execute(&session, vec![])
        .await
        .unwrap();

    for row in row_stream {
        drop(row.into_rows_result().unwrap());
    }
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_stake_registration() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream = stake_registration::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }

    let row_stream = stake_registration::DeleteQuery::execute(&session, vec![])
        .await
        .unwrap();

    for row in row_stream {
        drop(row.into_rows_result().unwrap());
    }
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_txi_by_hash() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream = txi_by_hash::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }

    let row_stream = txi_by_hash::DeleteQuery::execute(&session, vec![])
        .await
        .unwrap();

    for row in row_stream {
        drop(row.into_rows_result().unwrap());
    }
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_txo_ada() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream = txo_ada::PrimaryKeyQuery::execute(&session).await.unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }

    let row_stream = txo_ada::DeleteQuery::execute(&session, vec![])
        .await
        .unwrap();

    for row in row_stream {
        drop(row.into_rows_result().unwrap());
    }
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_txo_assets() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream = txo_assets::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }

    let row_stream = txo_assets::DeleteQuery::execute(&session, vec![])
        .await
        .unwrap();

    for row in row_stream {
        drop(row.into_rows_result().unwrap());
    }
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_unstaked_txo_ada() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream = unstaked_txo_ada::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }

    let row_stream = unstaked_txo_ada::DeleteQuery::execute(&session, vec![])
        .await
        .unwrap();

    for row in row_stream {
        drop(row.into_rows_result().unwrap());
    }
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_unstaked_txo_assets() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream = unstaked_txo_assets::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }

    let row_stream = unstaked_txo_assets::DeleteQuery::execute(&session, vec![])
        .await
        .unwrap();

    for row in row_stream {
        drop(row.into_rows_result().unwrap());
    }
}
