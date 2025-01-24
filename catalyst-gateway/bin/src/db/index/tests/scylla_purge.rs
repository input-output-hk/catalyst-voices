//! Integration tests of the `IndexDB` queries testing on its session.
//! This is mainly to test whether the defined queries work with the database or not.

use futures::StreamExt;

use super::*;
use crate::db::index::queries::purge::chain_root_for_role0_key::*;

#[ignore = "An integration test which requires a running Scylla node instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn test_chain_root_for_role0_key() {
    let Ok((session, _)) = get_shared_session().await else {
        panic!("{SESSION_ERR_MSG}");
    };

    let mut row_stream = PrimaryKeyQuery::execute(&session).await.unwrap();

    while let Some(row_res) = row_stream.next().await {
        drop(row_res.unwrap());
    }

    let row_stream = DeleteQuery::execute(&session, vec![]).await.unwrap();

    for row in row_stream {
        drop(row.into_rows_result().unwrap());
    }
}
