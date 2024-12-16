//! Integration tests of the `signed docs` queries

use super::*;
use crate::db::event::establish_connection;

#[ignore = "An integration test which requires a running EventDB instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn some_test() {
    establish_connection();

    let doc_type = uuid::Uuid::new_v4();

    let docs = vec![
        SignedDoc {
            id: uuid::Uuid::now_v7(),
            ver: uuid::Uuid::now_v7(),
            doc_type,
            author: "Alex".to_string(),
            metadata: Some(serde_json::Value::Null),
            payload: Some(serde_json::Value::Null),
            raw: vec![1, 2, 3, 4],
        },
        SignedDoc {
            id: uuid::Uuid::now_v7(),
            ver: uuid::Uuid::now_v7(),
            doc_type,
            author: "Steven".to_string(),
            metadata: Some(serde_json::Value::Null),
            payload: Some(serde_json::Value::Null),
            raw: vec![5, 6, 7, 8],
        },
        SignedDoc {
            id: uuid::Uuid::now_v7(),
            ver: uuid::Uuid::now_v7(),
            doc_type,
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

        let res_docs =
            filtered_select_signed_docs(&DocsQueryFilter::DocId(doc.id), &QueryLimits::All)
                .await
                .unwrap();
        assert_eq!(res_docs.len(), 1);
        assert_eq!(doc, res_docs.first().unwrap());

        let res_docs = filtered_select_signed_docs(
            &DocsQueryFilter::DocVer(doc.id, doc.ver),
            &QueryLimits::All,
        )
        .await
        .unwrap();
        assert_eq!(res_docs.len(), 1);
        assert_eq!(doc, res_docs.first().unwrap());

        let res_docs =
            filtered_select_signed_docs(&DocsQueryFilter::DocType(doc.doc_type), &QueryLimits::All)
                .await
                .unwrap();
        assert_eq!(res_docs.len(), 1);
        assert_eq!(doc, res_docs.first().unwrap());

        let res_docs = filtered_select_signed_docs(
            &DocsQueryFilter::Author(doc.author.clone()),
            &QueryLimits::All,
        )
        .await
        .unwrap();
        assert_eq!(res_docs.len(), 1);
        assert_eq!(doc, res_docs.first().unwrap());
    }

    let res_docs = filtered_select_signed_docs(&DocsQueryFilter::All, &QueryLimits::All)
        .await
        .unwrap();
    assert_eq!(docs, res_docs.into_iter().rev().collect::<Vec<_>>());
}
