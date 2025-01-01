//! Integration tests of the `IndexDB` queries testing on its session.
//! This is mainly to test whether the defined queries work with the database or not.

use pallas::ledger::addresses::StakeAddress;

use super::*;
use crate::{
    db::index::queries::staked_ada::get_assets_by_stake_address::*,
    service::common::types::cardano::cip19_stake_address::Cip19StakeAddress,
};

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_get_assets_by_stake_addr() -> Result<(), String> {
    let (session, _) = get_shared_session().await?;

    // cspell: disable
    let stake_addr_1: StakeAddress = Cip19StakeAddress::try_from(
        "stake_test1ursne3ndzr4kz8gmhmstu5026erayrnqyj46nqkkfcn0ufss2t7vt",
    )
    .map_err(|_| String::from("Failed decoding string into cip19 stake address"))?
    .try_into()
    .map_err(|_| String::from("Failed converting cip19 stake address into hash"))?;
    let stake_addr_1 = stake_addr_1.payload().as_hash().to_vec();
    // cspell: enable

    GetAssetsByStakeAddressQuery::execute(
        &session,
        GetAssetsByStakeAddressParams::new(stake_addr_1, num_bigint::BigInt::from(i64::MAX)),
    )
    .await
    .map_err(|_| String::from("Failed executing query"))?;

    Ok(())
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_get_chain_root() -> Result<(), String> {
    let (..) = get_shared_session().await?;

    Ok(())
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_get_invalid_registration_w_stake_addr() -> Result<(), String> {
    let (..) = get_shared_session().await?;
    
    Ok(())
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_get_registrations_by_chain_root() -> Result<(), String> {
    let (..) = get_shared_session().await?;
    
    Ok(())
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_get_registrations_w_stake_addr() -> Result<(), String> {
    let (..) = get_shared_session().await?;
    
    Ok(())
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_get_role0_key_chain_root() -> Result<(), String> {
    let (..) = get_shared_session().await?;
    
    Ok(())
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_get_stake_addr_w_stake_key_hash() -> Result<(), String> {
    let (..) = get_shared_session().await?;
    
    Ok(())
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_get_stake_addr_w_vote_key() -> Result<(), String> {
    let (..) = get_shared_session().await?;
    
    Ok(())
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_get_sync_status() -> Result<(), String> {
    let (..) = get_shared_session().await?;
    
    Ok(())
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_get_txi_by_txn_hashes() -> Result<(), String> {
    let (..) = get_shared_session().await?;
    
    Ok(())
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_get_txo_by_stake_address() -> Result<(), String> {
    let (..) = get_shared_session().await?;
    
    Ok(())
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_insert_sync_status() -> Result<(), String> {
    let (..) = get_shared_session().await?;
    
    Ok(())
}

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_update_txo_spent() -> Result<(), String> {
    let (..) = get_shared_session().await?;
    
    Ok(())
}
