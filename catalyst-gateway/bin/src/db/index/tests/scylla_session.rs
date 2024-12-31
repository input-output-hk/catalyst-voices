//! Integration tests of the `IndexDB` queries testing on its session

use super::*;

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_session() -> Result<(), String> {
    get_shared_session().await?;

    Ok(())
}
