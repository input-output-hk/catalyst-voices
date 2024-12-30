//! Integration tests of the `signed docs` queries

use super::*;
use crate::db::event::establish_connection;

#[ignore = "An integration test which requires a running EventDB instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn some_test() {
    establish_connection();

    let docs = [
        (
            uuid::Uuid::now_v7(),
            uuid::Uuid::now_v7(),
            uuid::Uuid::new_v4(),
            "Alex".to_string(),
            &Some(serde_json::Value::Null),
            &Some(serde_json::Value::Null),
            vec![1, 2, 3, 4],
        ),
        (
            uuid::Uuid::now_v7(),
            uuid::Uuid::now_v7(),
            uuid::Uuid::new_v4(),
            "Steven".to_string(),
            &Some(serde_json::Value::Null),
            &Some(serde_json::Value::Null),
            vec![5, 6, 7, 8],
        ),
        (
            uuid::Uuid::now_v7(),
            uuid::Uuid::now_v7(),
            uuid::Uuid::new_v4(),
            "Sasha".to_string(),
            &None,
            &None,
            vec![9, 10, 11, 12],
        ),
    ];

    for (id, ver, doc_type, author, metadata, payload, raw) in &docs {
        insert_signed_docs(id, ver, doc_type, author, metadata, payload, raw)
            .await
            .unwrap();
        // // try to insert the same data again
        // insert_signed_docs(id, ver, doc_type, author, metadata, payload, raw)
        //     .await
        //     .unwrap();
    }
}
