//! Integration tests of the `signed docs` queries

use super::*;
use crate::db::event::{common::query_limits::QueryLimits, establish_connection};

#[ignore = "An integration test which requires a running EventDB instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn some_test() {
    establish_connection();

    let doc_type = uuid::Uuid::new_v4();

    let docs = vec![
        FullSignedDoc::new(
            SignedDocBody::new(
                uuid::Uuid::now_v7(),
                uuid::Uuid::now_v7(),
                doc_type,
                "Alex".to_string(),
                Some(serde_json::Value::Null),
            ),
            Some(serde_json::Value::Null),
            vec![1, 2, 3, 4],
        ),
        FullSignedDoc::new(
            SignedDocBody::new(
                uuid::Uuid::now_v7(),
                uuid::Uuid::now_v7(),
                doc_type,
                "Steven".to_string(),
                Some(serde_json::Value::Null),
            ),
            Some(serde_json::Value::Null),
            vec![5, 6, 7, 8],
        ),
        FullSignedDoc::new(
            SignedDocBody::new(
                uuid::Uuid::now_v7(),
                uuid::Uuid::now_v7(),
                doc_type,
                "Sasha".to_string(),
                None,
            ),
            None,
            vec![9, 10, 11, 12],
        ),
    ];

    for doc in &docs {
        insert_signed_docs(doc).await.unwrap();
        // try to insert the same data again
        insert_signed_docs(doc).await.unwrap();
        // try another doc with the same `id` and `ver` and with different other fields
        let another_doc = FullSignedDoc::new(
            SignedDocBody::new(*doc.id(), *doc.ver(), doc_type, "Neil".to_string(), None),
            None,
            vec![],
        );
        assert!(insert_signed_docs(&another_doc).await.is_err());

        let res_doc = select_signed_docs(doc.id(), Some(doc.ver())).await.unwrap();
        assert_eq!(doc, &res_doc);

        let res_doc = select_signed_docs(doc.id(), None).await.unwrap();
        assert_eq!(doc, &res_doc);

        let res_docs =
            SignedDocBody::load_from_db(&DocsQueryFilter::DocId(*doc.id()), &QueryLimits::ALL)
                .await
                .unwrap();
        assert_eq!(res_docs.len(), 1);
        assert_eq!(doc.body(), res_docs.first().unwrap());

        let res_docs = SignedDocBody::load_from_db(
            &DocsQueryFilter::DocVer(*doc.id(), *doc.ver()),
            &QueryLimits::ALL,
        )
        .await
        .unwrap();
        assert_eq!(res_docs.len(), 1);
        assert_eq!(doc.body(), res_docs.first().unwrap());

        let res_docs = SignedDocBody::load_from_db(
            &DocsQueryFilter::Author(doc.author().clone()),
            &QueryLimits::ALL,
        )
        .await
        .unwrap();
        assert_eq!(res_docs.len(), 1);
        assert_eq!(doc.body(), res_docs.first().unwrap());
    }

    let res_docs =
        SignedDocBody::load_from_db(&DocsQueryFilter::DocType(doc_type), &QueryLimits::ALL)
            .await
            .unwrap();
    assert_eq!(
        docs.iter().map(FullSignedDoc::body).collect::<Vec<_>>(),
        res_docs.iter().rev().collect::<Vec<_>>()
    );

    let res_docs = SignedDocBody::load_from_db(&DocsQueryFilter::All, &QueryLimits::ALL)
        .await
        .unwrap();
    assert_eq!(
        docs.iter().map(FullSignedDoc::body).collect::<Vec<_>>(),
        res_docs.iter().rev().collect::<Vec<_>>()
    );
}
