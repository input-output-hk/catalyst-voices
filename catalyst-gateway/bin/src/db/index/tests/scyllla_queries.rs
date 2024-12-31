//! Integration tests of the `IndexDB` queries testing on its session

use pallas::ledger::addresses::StakeAddress;

use super::*;
use crate::{
    db::index::queries::staked_ada::get_assets_by_stake_address::*,
    service::common::types::cardano::cip19_stake_address::Cip19StakeAddress,
};

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_get_assets_by_stake_addr() -> Result<(), String> {
    setup_test_database().await?;
    let (session, _) = get_session()?;

    let stake_addr1: StakeAddress = Cip19StakeAddress::try_from(
        "stake_test1ursne3ndzr4kz8gmhmstu5026erayrnqyj46nqkkfcn0ufss2t7vt",
    )
    .map_err(|_| String::from("Failed decoding string into cip19 stake address"))?
    .try_into()
    .map_err(|_| String::from("Failed converting cip19 stake address into hash"))?;
    let stake_addr1 = stake_addr1.payload().as_hash().to_vec();

    GetAssetsByStakeAddressQuery::execute(
        &session,
        GetAssetsByStakeAddressParams::new(stake_addr1, num_bigint::BigInt::from(i64::MAX)),
    )
    .await
    .map_err(|_| String::from("Failed executing query"))?;

    Ok(())
}
