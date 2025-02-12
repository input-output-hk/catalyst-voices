//! Integration tests of the `IndexDB` queries testing on its session.
//! This is mainly to test whether the defined purge queries work with the database or
//! not.

// cSpell:ignoreRegExp cardano/Fftx

use cardano_blockchain_types::{TransactionHash, VotingPubKey};
use catalyst_types::{problem_report::ProblemReport, uuid::UuidV4};
use ed25519_dalek::VerifyingKey;
use futures::StreamExt;
use pallas::ledger::addresses::{
    ShelleyAddress, ShelleyDelegationPart, ShelleyPaymentPart, StakeAddress,
};

use super::*;
use crate::db::index::{
    block::*,
    queries::{purge::*, PreparedQuery},
    tests::test_utils,
};

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn catalyst_id_for_stake_address() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    // data
    let data = vec![
        rbac509::insert_catalyst_id_for_stake_address::Params::new(
            stake_address_1(),
            0.into(),
            0.into(),
            "cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE"
                .parse()
                .unwrap(),
        ),
        rbac509::insert_catalyst_id_for_stake_address::Params::new(
            stake_address_2(),
            1.into(),
            1.into(),
            "cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE"
                .parse()
                .unwrap(),
        ),
    ];
    let data_len = data.len();

    // insert
    session
        .execute_batch(PreparedQuery::CatalystIdForStakeAddressInsertQuery, data)
        .await
        .unwrap();

    // read
    let mut row_stream = catalyst_id_for_stake_address::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert_eq!(read_rows.len(), data_len);

    // delete
    let delete_params = read_rows
        .into_iter()
        .map(catalyst_id_for_stake_address::Params::from)
        .collect();
    let row_results = catalyst_id_for_stake_address::DeleteQuery::execute(&session, delete_params)
        .await
        .unwrap()
        .into_iter()
        .all(|r| r.result_not_rows().is_ok());

    assert!(row_results);

    // re-read
    let mut row_stream = catalyst_id_for_stake_address::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert!(read_rows.is_empty());
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn catalyst_id_for_txn_id() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    // data
    let data = vec![
        rbac509::insert_catalyst_id_for_txn_id::Params::new(
            "cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE"
                .parse()
                .unwrap(),
            TransactionHash::new(&[0]),
            0.into(),
            0.into(),
        ),
        rbac509::insert_catalyst_id_for_txn_id::Params::new(
            "cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE"
                .parse()
                .unwrap(),
            TransactionHash::new(&[1]),
            1.into(),
            1.into(),
        ),
    ];
    let data_len = data.len();

    // insert
    session
        .execute_batch(PreparedQuery::CatalystIdForTxnIdInsertQuery, data)
        .await
        .unwrap();

    // read
    let mut row_stream = catalyst_id_for_txn_id::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert_eq!(read_rows.len(), data_len);

    // delete
    let delete_params = read_rows
        .into_iter()
        .map(catalyst_id_for_txn_id::Params::from)
        .collect();
    let row_results = catalyst_id_for_txn_id::DeleteQuery::execute(&session, delete_params)
        .await
        .unwrap()
        .into_iter()
        .all(|r| r.result_not_rows().is_ok());

    assert!(row_results);

    // re-read
    let mut row_stream = catalyst_id_for_txn_id::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert!(read_rows.is_empty());
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn rbac509_registration() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    // data
    let data = vec![
        rbac509::insert_rbac509::Params::new(
            "cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE"
                .parse()
                .unwrap(),
            TransactionHash::new(&[0]),
            0.into(),
            0.into(),
            UuidV4::new(),
            None,
        ),
        rbac509::insert_rbac509::Params::new(
            "cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE"
                .parse()
                .unwrap(),
            TransactionHash::new(&[1]),
            1.into(),
            1.into(),
            UuidV4::new(),
            None,
        ),
    ];
    let data_len = data.len();

    // insert
    session
        .execute_batch(PreparedQuery::Rbac509InsertQuery, data)
        .await
        .unwrap();

    // read
    let mut row_stream = rbac509_registration::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert_eq!(read_rows.len(), data_len);

    // delete
    let delete_params = read_rows
        .into_iter()
        .map(rbac509_registration::Params::from)
        .collect();
    let row_results = rbac509_registration::DeleteQuery::execute(&session, delete_params)
        .await
        .unwrap()
        .into_iter()
        .all(|r| r.result_not_rows().is_ok());

    assert!(row_results);

    // re-read
    let mut row_stream = rbac509_registration::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert!(read_rows.is_empty());
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn rbac509_invalid_registration() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    // data
    let report = ProblemReport::new("test context");
    let data = vec![
        rbac509::insert_rbac509_invalid::Params::new(
            "cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE"
                .parse()
                .unwrap(),
            TransactionHash::new(&[0]),
            0.into(),
            0.into(),
            Some(UuidV4::new()),
            None,
            &report,
        ),
        rbac509::insert_rbac509_invalid::Params::new(
            "cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE"
                .parse()
                .unwrap(),
            TransactionHash::new(&[1]),
            1.into(),
            1.into(),
            Some(UuidV4::new()),
            None,
            &report,
        ),
    ];
    let data_len = data.len();

    // insert
    session
        .execute_batch(PreparedQuery::Rbac509InvalidInsertQuery, data)
        .await
        .unwrap();

    // read
    let mut row_stream = rbac509_invalid_registration::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert_eq!(read_rows.len(), data_len);

    // delete
    let delete_params = read_rows
        .into_iter()
        .map(rbac509_registration::Params::from)
        .collect();
    let row_results = rbac509_registration::DeleteQuery::execute(&session, delete_params)
        .await
        .unwrap()
        .into_iter()
        .all(|r| r.result_not_rows().is_ok());

    assert!(row_results);

    // re-read
    let mut row_stream = rbac509_invalid_registration::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert!(read_rows.is_empty());
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_cip36_registration_for_vote_key() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    // data
    let data = vec![
        cip36::insert_cip36_for_vote_key::Params::new(
            &voting_pub_key(0),
            0.into(),
            0.into(),
            &test_utils::cip_36_1(),
            false,
        ),
        cip36::insert_cip36_for_vote_key::Params::new(
            &voting_pub_key(1),
            1.into(),
            1.into(),
            &test_utils::cip_36_2(),
            true,
        ),
    ];
    let data_len = data.len();

    // insert
    session
        .execute_batch(
            PreparedQuery::Cip36RegistrationForStakeAddrInsertQuery,
            data,
        )
        .await
        .unwrap();

    // read
    let mut row_stream = cip36_registration_for_vote_key::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert_eq!(read_rows.len(), data_len);

    // delete
    let delete_params = read_rows
        .into_iter()
        .map(cip36_registration_for_vote_key::Params::from)
        .collect();
    let row_results =
        cip36_registration_for_vote_key::DeleteQuery::execute(&session, delete_params)
            .await
            .unwrap()
            .into_iter()
            .all(|r| r.result_not_rows().is_ok());

    assert!(row_results);

    // re-read
    let mut row_stream = cip36_registration_for_vote_key::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert!(read_rows.is_empty());
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_cip36_registration_invalid() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    // data
    let data = vec![
        cip36::insert_cip36_invalid::Params::new(
            Some(&voting_pub_key(0)),
            0.into(),
            0.into(),
            &test_utils::cip_36_1(),
        ),
        cip36::insert_cip36_invalid::Params::new(
            Some(&voting_pub_key(1)),
            1.into(),
            1.into(),
            &test_utils::cip_36_2(),
        ),
    ];
    let data_len = data.len();

    // insert
    session
        .execute_batch(PreparedQuery::Cip36RegistrationInsertErrorQuery, data)
        .await
        .unwrap();

    // read
    let mut row_stream = cip36_registration_invalid::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert_eq!(read_rows.len(), data_len);

    // delete
    let delete_params = read_rows
        .into_iter()
        .map(cip36_registration_invalid::Params::from)
        .collect();
    let row_results = cip36_registration_invalid::DeleteQuery::execute(&session, delete_params)
        .await
        .unwrap()
        .into_iter()
        .all(|r| r.result_not_rows().is_ok());

    assert!(row_results);

    // re-read
    let mut row_stream = cip36_registration_invalid::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert!(read_rows.is_empty());
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_cip36_registration() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    // data
    let data = vec![
        cip36::insert_cip36::Params::new(
            &voting_pub_key(0),
            0.into(),
            0.into(),
            &test_utils::cip_36_1(),
        ),
        cip36::insert_cip36::Params::new(
            &voting_pub_key(1),
            1.into(),
            1.into(),
            &test_utils::cip_36_2(),
        ),
    ];
    let data_len = data.len();

    // insert
    session
        .execute_batch(PreparedQuery::Cip36RegistrationInsertQuery, data)
        .await
        .unwrap();

    // read
    let mut row_stream = cip36_registration::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert_eq!(read_rows.len(), data_len);

    // delete
    let delete_params = read_rows
        .into_iter()
        .map(cip36_registration::Params::from)
        .collect();
    let row_results = cip36_registration::DeleteQuery::execute(&session, delete_params)
        .await
        .unwrap()
        .into_iter()
        .all(|r| r.result_not_rows().is_ok());

    assert!(row_results);

    // re-read
    let mut row_stream = cip36_registration::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert!(read_rows.is_empty());
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_stake_registration() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    // data
    let stake_address_1 = VerifyingKey::from_bytes(&[
        51, 200, 245, 181, 232, 166, 86, 58, 48, 33, 72, 162, 85, 30, 7, 28, 12, 87, 113, 3, 68,
        233, 104, 179, 113, 196, 59, 4, 155, 225, 74, 149,
    ])
    .unwrap();
    let stake_address_2 = VerifyingKey::from_bytes(&[
        203, 12, 200, 203, 42, 30, 255, 236, 0, 171, 68, 163, 116, 199, 128, 6, 177, 15, 47, 74,
        188, 81, 43, 244, 51, 2, 161, 145, 195, 236, 188, 75,
    ])
    .unwrap();
    let data = vec![
        certs::StakeRegistrationInsertQuery::new(
            vec![0],
            0.into(),
            0.into(),
            Some(stake_address_1),
            false,
            false,
            false,
            None,
        ),
        certs::StakeRegistrationInsertQuery::new(
            vec![1],
            1.into(),
            1.into(),
            Some(stake_address_2),
            true,
            true,
            true,
            None,
        ),
    ];
    let data_len = data.len();

    // insert
    session
        .execute_batch(PreparedQuery::StakeRegistrationInsertQuery, data)
        .await
        .unwrap();

    // read
    let mut row_stream = stake_registration::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert_eq!(read_rows.len(), data_len);

    // delete
    let delete_params = read_rows
        .into_iter()
        .map(stake_registration::Params::from)
        .collect();
    let row_results = stake_registration::DeleteQuery::execute(&session, delete_params)
        .await
        .unwrap()
        .into_iter()
        .all(|r| r.result_not_rows().is_ok());

    assert!(row_results);

    // re-read
    let mut row_stream = stake_registration::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert!(read_rows.is_empty());
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_txi_by_hash() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    // data
    let data = vec![
        txi::TxiInsertParams::new(&[0], 0, 0.into()),
        txi::TxiInsertParams::new(&[1], 1, 1.into()),
    ];
    let data_len = data.len();

    // insert
    session
        .execute_batch(PreparedQuery::TxiInsertQuery, data)
        .await
        .unwrap();

    // read
    let mut row_stream = txi_by_hash::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert_eq!(read_rows.len(), data_len);

    // delete
    let delete_params = read_rows
        .into_iter()
        .map(txi_by_hash::Params::from)
        .collect();
    let row_results = txi_by_hash::DeleteQuery::execute(&session, delete_params)
        .await
        .unwrap()
        .into_iter()
        .all(|r| r.result_not_rows().is_ok());

    assert!(row_results);

    // re-read
    let mut row_stream = txi_by_hash::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert!(read_rows.is_empty());
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_txo_ada() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    // data
    let data = vec![
        txo::insert_txo::Params::new(
            &[0],
            0.into(),
            0.into(),
            0.into(),
            "addr0",
            0,
            TransactionHash::new(&[0]),
        ),
        txo::insert_txo::Params::new(
            &[1],
            1.into(),
            1.into(),
            1.into(),
            "addr1",
            1,
            TransactionHash::new(&[1]),
        ),
    ];
    let data_len = data.len();

    // insert
    session
        .execute_batch(PreparedQuery::TxoAdaInsertQuery, data)
        .await
        .unwrap();

    // read
    let mut row_stream = txo_ada::PrimaryKeyQuery::execute(&session).await.unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert_eq!(read_rows.len(), data_len);

    // delete
    let delete_params = read_rows.into_iter().map(txo_ada::Params::from).collect();
    let row_results = txo_ada::DeleteQuery::execute(&session, delete_params)
        .await
        .unwrap()
        .into_iter()
        .all(|r| r.result_not_rows().is_ok());

    assert!(row_results);

    // re-read
    let mut row_stream = txo_ada::PrimaryKeyQuery::execute(&session).await.unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert!(read_rows.is_empty());
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_txo_assets() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    // data
    let data = vec![
        txo::insert_txo_asset::Params::new(&[0], 0.into(), 0.into(), 0.into(), &[0], &[0], 0),
        txo::insert_txo_asset::Params::new(&[1], 1.into(), 1.into(), 1.into(), &[1], &[1], 1),
    ];
    let data_len = data.len();

    // insert
    session
        .execute_batch(PreparedQuery::TxoAssetInsertQuery, data)
        .await
        .unwrap();

    // read
    let mut row_stream = txo_assets::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert_eq!(read_rows.len(), data_len);

    // delete
    let delete_params = read_rows
        .into_iter()
        .map(txo_assets::Params::from)
        .collect();
    let row_results = txo_assets::DeleteQuery::execute(&session, delete_params)
        .await
        .unwrap()
        .into_iter()
        .all(|r| r.result_not_rows().is_ok());

    assert!(row_results);

    // re-read
    let mut row_stream = txo_assets::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert!(read_rows.is_empty());
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_unstaked_txo_ada() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    // data
    let data = vec![
        txo::insert_unstaked_txo::Params::new(
            TransactionHash::new(&[0]),
            0.into(),
            0.into(),
            0.into(),
            "addr0",
            0,
        ),
        txo::insert_unstaked_txo::Params::new(
            TransactionHash::new(&[1]),
            1.into(),
            1.into(),
            1.into(),
            "addr1",
            1,
        ),
    ];
    let data_len = data.len();

    // insert
    session
        .execute_batch(PreparedQuery::UnstakedTxoAdaInsertQuery, data)
        .await
        .unwrap();

    // read
    let mut row_stream = unstaked_txo_ada::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert_eq!(read_rows.len(), data_len);

    // delete
    let delete_params = read_rows
        .into_iter()
        .map(unstaked_txo_ada::Params::from)
        .collect();
    let row_results = unstaked_txo_ada::DeleteQuery::execute(&session, delete_params)
        .await
        .unwrap()
        .into_iter()
        .all(|r| r.result_not_rows().is_ok());

    assert!(row_results);

    // re-read
    let mut row_stream = unstaked_txo_ada::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert!(read_rows.is_empty());
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_unstaked_txo_assets() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    // data
    let data = vec![
        txo::insert_unstaked_txo_asset::Params::new(
            TransactionHash::new(&[0]),
            0.into(),
            &[0],
            &[0],
            0.into(),
            0.into(),
            0,
        ),
        txo::insert_unstaked_txo_asset::Params::new(
            TransactionHash::new(&[1]),
            1.into(),
            &[1],
            &[1],
            1.into(),
            1.into(),
            1,
        ),
    ];
    let data_len = data.len();

    // insert
    session
        .execute_batch(PreparedQuery::UnstakedTxoAssetInsertQuery, data)
        .await
        .unwrap();

    // read
    let mut row_stream = unstaked_txo_assets::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert_eq!(read_rows.len(), data_len);

    // delete
    let delete_params = read_rows
        .into_iter()
        .map(unstaked_txo_assets::Params::from)
        .collect();
    let row_results = unstaked_txo_assets::DeleteQuery::execute(&session, delete_params)
        .await
        .unwrap()
        .into_iter()
        .all(|r| r.result_not_rows().is_ok());

    assert!(row_results);

    // re-read
    let mut row_stream = unstaked_txo_assets::PrimaryKeyQuery::execute(&session)
        .await
        .unwrap();

    let mut read_rows = vec![];
    while let Some(row_res) = row_stream.next().await {
        read_rows.push(row_res.unwrap());
    }

    assert!(read_rows.is_empty());
}

/// Returns a stake address.
fn stake_address_1() -> StakeAddress {
    let payment = ShelleyPaymentPart::Key(
        "276fd18711931e2c0e21430192dbeac0e458093cd9d1fcd7210f64b3"
            .parse()
            .unwrap(),
    );
    let delegation = ShelleyDelegationPart::Key(
        "276fd18711931e2c0e21430192dbeac0e458093cd9d1fcd7210f64b3"
            .parse()
            .unwrap(),
    );
    ShelleyAddress::new(
        pallas::ledger::addresses::Network::Mainnet,
        payment,
        delegation,
    )
    .try_into()
    .unwrap()
}

/// Returns a different stake address.
fn stake_address_2() -> StakeAddress {
    let payment = ShelleyPaymentPart::Key(
        "0d8d00cdd4657ac84d82f0a56067634a7adfdf43da41cb534bcaa45060973d21"
            .parse()
            .unwrap(),
    );
    let delegation = ShelleyDelegationPart::Key(
        "0d8d00cdd4657ac84d82f0a56067634a7adfdf43da41cb534bcaa45060973d21"
            .parse()
            .unwrap(),
    );
    ShelleyAddress::new(
        pallas::ledger::addresses::Network::Mainnet,
        payment,
        delegation,
    )
    .try_into()
    .unwrap()
}

/// Creates `VotingPubKey` from the given number.
fn voting_pub_key(number: u32) -> VotingPubKey {
    VotingPubKey::new(
        Some(VerifyingKey::from_bytes(&[u8::try_from(number).unwrap(); 32]).unwrap()),
        0,
    )
}
