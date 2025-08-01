//! Integration tests of the `IndexDB` queries testing on its session.
//! This is mainly to test whether the defined queries work with the database or not.

// cSpell:ignoreRegExp cardano/Fftx

use cardano_blockchain_types::TransactionId;
use catalyst_types::catalyst_id::CatalystId;
use ed25519_dalek::VerifyingKey;
use futures::StreamExt;

use super::*;
use crate::{
    db::index::{
        queries::{
            rbac,
            registrations::{
                get_from_stake_addr::*, get_from_stake_address::*, get_from_vote_key::*,
                get_invalid::*,
            },
            staked_ada::{
                get_assets_by_stake_address::*, get_txi_by_txn_hash::*,
                get_txo_by_stake_address::*, update_txo_spent::*,
            },
            sync_status::update::*,
        },
        tests::test_utils::stake_address_1,
    },
    service::common::types::cardano::slot_no::SlotNo,
};

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_get_assets_by_stake_addr() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let _row_stream = GetAssetsByStakeAddressQuery::execute(
        &session,
        GetAssetsByStakeAddressParams::new(stake_address_1()),
    )
    .await
    .unwrap();
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn get_catalyst_id_by_stake_address() {
    use rbac::get_catalyst_id_from_stake_address::{Query, QueryParams};

    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream = Query::execute(&session, QueryParams {
        stake_address: stake_address_1().into(),
    })
    .await
    .unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }

    Query::latest(&session, &stake_address_1()).await.unwrap();
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn get_catalyst_id_by_transaction_id() {
    use rbac::get_catalyst_id_from_transaction_id::Query;

    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let txn_id = TransactionId::new(&[1, 2, 3]);
    Query::get(&session, txn_id).await.unwrap();
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn get_catalyst_id_by_public_key() {
    use rbac::get_catalyst_id_from_public_key::Query;

    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let key = VerifyingKey::from_bytes(&[
        51, 200, 245, 181, 232, 166, 86, 58, 48, 33, 72, 162, 85, 30, 7, 28, 12, 87, 113, 3, 68,
        233, 104, 179, 113, 196, 59, 4, 155, 225, 74, 149,
    ])
    .unwrap();
    Query::get(&session, key).await.unwrap();
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
async fn get_rbac_registrations_by_catalyst_id() {
    use rbac::get_rbac_registrations::{Query, QueryParams};

    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let id: CatalystId = "cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE"
        .parse()
        .unwrap();
    let mut row_stream = Query::execute(&session, QueryParams {
        catalyst_id: id.into(),
    })
    .await
    .unwrap();

    while let Some(row_res) = row_stream.next().await {
        row_res.unwrap();
    }
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn get_rbac_invalid_registrations_by_catalyst_id() {
    use rbac::get_rbac_invalid_registrations::{Query, QueryParams};

    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let id: CatalystId = "cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE"
        .parse()
        .unwrap();
    let mut row_stream = Query::execute(&session, QueryParams {
        catalyst_id: id.into(),
    })
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
        stake_public_key: vec![],
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

    let mut row_stream = GetStakeAddrQuery::execute(&session, GetStakeAddrParams {
        stake_address: stake_address_1().into(),
    })
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
        row_res.unwrap();
    }
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_get_txo_by_stake_address() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let row_stream = GetTxoByStakeAddressQuery::execute(
        &session,
        GetTxoByStakeAddressQueryParams::new(stake_address_1()),
    )
    .await
    .unwrap();

    let rows = Arc::into_inner(row_stream).unwrap();
    rows.into_iter().for_each(drop);
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_insert_sync_status() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    SyncStatusInsertQuery::execute(
        &session,
        row::SyncStatusQueryParams::new(u64::MAX.into(), u64::MAX.into()),
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
