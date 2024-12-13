//! Integration tests of the `signed docs` queries

use super::*;
use crate::db::event::establish_connection;

#[ignore = "An integration test which requires a running EventDB instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn some_test() {
    establish_connection();

    let docs = [
        SignedDoc {
            id: uuid::Uuid::now_v7(),
            ver: uuid::Uuid::now_v7(),
            doc_type: uuid::Uuid::new_v4(),
            author: "Alex".to_string(),
            metadata: Some(serde_json::Value::Null),
            payload: Some(serde_json::Value::Null),
            raw: vec![1, 2, 3, 4],
        },
        SignedDoc {
            id: uuid::Uuid::now_v7(),
            ver: uuid::Uuid::now_v7(),
            doc_type: uuid::Uuid::new_v4(),
            author: "Steven".to_string(),
            metadata: Some(serde_json::Value::Null),
            payload: Some(serde_json::Value::Null),
            raw: vec![5, 6, 7, 8],
        },
        SignedDoc {
            id: uuid::Uuid::now_v7(),
            ver: uuid::Uuid::now_v7(),
            doc_type: uuid::Uuid::new_v4(),
            author: "Sasha".to_string(),
            metadata: None,
            payload: None,
            raw: vec![9, 10, 11, 12],
        },
    ];

    for doc in &docs {
        insert_signed_docs(doc).await.unwrap();
        // try to insert the same data again
        insert_signed_docs(doc).await.unwrap();
        // try another doc with different `author` and same other fields
        let another_doc = SignedDoc {
            author: "Neil".to_string(),
            ..doc.clone()
        };
        assert!(insert_signed_docs(&another_doc).await.is_err());

        let res_doc = select_signed_docs(&doc.id, &None).await.unwrap();
        assert_eq!(doc, &res_doc);
        let res_doc = select_signed_docs(&doc.id, &Some(doc.ver)).await.unwrap();
        assert_eq!(doc, &res_doc);
    }
}
