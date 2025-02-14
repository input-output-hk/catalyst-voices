//! Integration tests of the `IndexDB` queries testing on its session.
//! This is mainly to test whether the defined queries work with the database or not.

use futures::StreamExt;

use super::*;
use crate::{
    db::index::queries::{
        rbac::{get_chain_root::*, get_registrations::*, get_role0_chain_root::*},
        registrations::{
            get_from_stake_addr::*, get_from_stake_hash::*, get_from_vote_key::*, get_invalid::*,
        },
        staked_ada::{
            get_assets_by_stake_address::*, get_txi_by_txn_hash::*, get_txo_by_stake_address::*,
            update_txo_spent::*,
        },
        sync_status::update::*,
    },
    service::common::types::cardano::slot_no::SlotNo,
};

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_get_assets_by_stake_addr() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream = GetAssetsByStakeAddressQuery::execute(
        &session,
        GetAssetsByStakeAddressParams::new(vec![], num_bigint::BigInt::from(i64::MAX)),
    )
    .await
    .unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_get_chain_root() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream = GetChainRootQuery::execute(&session, GetChainRootQueryParams {
        stake_address: vec![],
    })
    .await
    .unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_get_invalid_registration_w_stake_addr() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream = GetInvalidRegistrationQuery::execute(
        &session,
        GetInvalidRegistrationParams::new(vec![], SlotNo::default()),
    )
    .await
    .unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_get_registrations_by_chain_root() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream = GetRegistrationsByChainRootQuery::execute(
        &session,
        GetRegistrationsByChainRootQueryParams { chain_root: vec![] },
    )
    .await
    .unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_get_registrations_w_stake_addr() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream = GetRegistrationQuery::execute(&session, GetRegistrationParams {
        stake_address: vec![],
    })
    .await
    .unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_get_role0_key_chain_root() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream = GetRole0ChainRootQuery::execute(&session, GetRole0ChainRootQueryParams {
        role0_key: vec![],
    })
    .await
    .unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_get_stake_addr_w_stake_key_hash() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream =
        GetStakeAddrQuery::execute(&session, GetStakeAddrParams { stake_hash: vec![] })
            .await
            .unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_get_stake_addr_w_vote_key() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream =
        GetStakeAddrFromVoteKeyQuery::execute(&session, GetStakeAddrFromVoteKeyParams {
            vote_key: vec![],
        })
        .await
        .unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }
}

// Note: `get_sync_status` query is not available.
// #[ignore = "An integration test which requires a running Scylla node instance, disabled
// from `testunit` CI run"] #[tokio::test]
// async fn test_get_sync_status() {
//     let (session, _) =
// get_shared_session().await

//     Ok(())
// }

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_get_txi_by_txn_hashes() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream =
        GetTxiByTxnHashesQuery::execute(&session, GetTxiByTxnHashesQueryParams::new(vec![]))
            .await
            .unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_get_txo_by_stake_address() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream = GetTxoByStakeAddressQuery::execute(
        &session,
        GetTxoByStakeAddressQueryParams::new(vec![], num_bigint::BigInt::from(i64::MAX)),
    )
    .await
    .unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_insert_sync_status() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    SyncStatusInsertQuery::execute(
        &session,
        row::SyncStatusQueryParams::new(u64::MAX, u64::MAX),
    )
    .await
    .unwrap();
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_update_txo_spent() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    UpdateTxoSpentQuery::execute(&session, vec![])
        .await
        .unwrap();
}
