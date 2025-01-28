//! Integration tests of the `IndexDB` queries testing on its session.
//! This is mainly to test whether the defined purge queries work with the database or
//! not.

use futures::StreamExt;

use super::*;
use crate::db::index::{
    block::*,
    queries::{purge::*, PreparedQuery},
};

mod helper {
    use cardano_chain_follower::Metadata::cip36::{Cip36, VotingPubKey};
    use ed25519_dalek::VerifyingKey;

    pub(super) fn create_dummy_cip39(number: u32) -> (Cip36, VotingPubKey) {
        let empty_cip36 = Cip36 {
            cip36: None,
            voting_keys: vec![],
            stake_pk: Some(VerifyingKey::from_bytes(&[u8::try_from(number).unwrap(); 32]).unwrap()),
            payment_addr: vec![],
            payable: false,
            raw_nonce: 0,
            nonce: 0,
            purpose: 0,
            signed: false,
            strict_catalyst: true,
        };

        let pub_key = VotingPubKey {
            voting_pk: VerifyingKey::from_bytes(&[u8::try_from(number).unwrap(); 32]).unwrap(),
            weight: 0,
        };

        (empty_cip36, pub_key)
    }
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_chain_root_for_role0_key() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    // data
    let data = vec![
        rbac509::insert_chain_root_for_role0_key::Params::new(&[0], &[0], 0, 0),
        rbac509::insert_chain_root_for_role0_key::Params::new(&[1], &[1], 1, 1),
    ];
    let data_len = data.len();

    // insert
    session
        .execute_batch(PreparedQuery::ChainRootForRole0KeyInsertQuery, data)
        .await
        .unwrap();

    // read
    let mut row_stream = chain_root_for_role0_key::PrimaryKeyQuery::execute(&session)
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
        .map(chain_root_for_role0_key::Params::from)
        .collect();
    let row_results = chain_root_for_role0_key::DeleteQuery::execute(&session, delete_params)
        .await
        .unwrap()
        .into_iter()
        .all(|r| r.result_not_rows().is_ok());

    assert!(row_results);

    // re-read
    let mut row_stream = chain_root_for_role0_key::PrimaryKeyQuery::execute(&session)
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
async fn test_chain_root_for_stake_address() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    // data
    let data = vec![
        rbac509::insert_chain_root_for_stake_address::Params::new(&[0], &[0], 0, 0),
        rbac509::insert_chain_root_for_stake_address::Params::new(&[1], &[1], 1, 1),
    ];
    let data_len = data.len();

    // insert
    session
        .execute_batch(PreparedQuery::ChainRootForStakeAddressInsertQuery, data)
        .await
        .unwrap();

    // read
    let mut row_stream = chain_root_for_stake_address::PrimaryKeyQuery::execute(&session)
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
        .map(chain_root_for_stake_address::Params::from)
        .collect();
    let row_results = chain_root_for_stake_address::DeleteQuery::execute(&session, delete_params)
        .await
        .unwrap()
        .into_iter()
        .all(|r| r.result_not_rows().is_ok());

    assert!(row_results);

    // re-read
    let mut row_stream = chain_root_for_stake_address::PrimaryKeyQuery::execute(&session)
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
async fn test_chain_root_for_txn_id() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    // data
    let data = vec![
        rbac509::insert_chain_root_for_txn_id::Params::new(&[0], &[0]),
        rbac509::insert_chain_root_for_txn_id::Params::new(&[1], &[1]),
    ];
    let data_len = data.len();

    // insert
    session
        .execute_batch(PreparedQuery::ChainRootForTxnIdInsertQuery, data)
        .await
        .unwrap();

    // read
    let mut row_stream = chain_root_for_txn_id::PrimaryKeyQuery::execute(&session)
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
        .map(chain_root_for_txn_id::Params::from)
        .collect();
    let row_results = chain_root_for_txn_id::DeleteQuery::execute(&session, delete_params)
        .await
        .unwrap()
        .into_iter()
        .all(|r| r.result_not_rows().is_ok());

    assert!(row_results);

    // re-read
    let mut row_stream = chain_root_for_txn_id::PrimaryKeyQuery::execute(&session)
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
    let dummy0 = helper::create_dummy_cip39(0);
    let dummy1 = helper::create_dummy_cip39(1);

    let data = vec![
        cip36::insert_cip36_for_vote_key::Params::new(&dummy0.1, 0, 0, &dummy0.0, false),
        cip36::insert_cip36_for_vote_key::Params::new(&dummy1.1, 1, 1, &dummy1.0, true),
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
    let dummy0 = helper::create_dummy_cip39(0);
    let dummy1 = helper::create_dummy_cip39(1);

    let data = vec![
        cip36::insert_cip36_invalid::Params::new(Some(&dummy0.1), 0, 0, &dummy0.0, vec![]),
        cip36::insert_cip36_invalid::Params::new(Some(&dummy1.1), 1, 1, &dummy1.0, vec![]),
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
    let dummy0 = helper::create_dummy_cip39(0);
    let dummy1 = helper::create_dummy_cip39(1);

    let data = vec![
        cip36::insert_cip36::Params::new(&dummy0.1, 0, 0, &dummy0.0),
        cip36::insert_cip36::Params::new(&dummy1.1, 1, 1, &dummy1.0),
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
