//! Integration tests of the `IndexDB` queries testing on its schema setup and integrity

use super::*;

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_schema() -> Result<(), String> {
    setup_test_database().await?;
    let (_, _) = get_session()?;

    Ok(())
}
