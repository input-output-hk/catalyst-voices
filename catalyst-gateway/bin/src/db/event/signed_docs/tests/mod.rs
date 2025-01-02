//! Integration tests of the `signed docs` queries

use std::pin::pin;

use futures::TryStreamExt;

use super::*;
use crate::db::event::{common::query_limits::QueryLimits, establish_connection};

#[ignore = "An integration test which requires a running EventDB instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn queries_test() {
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
        doc.store().await.unwrap();
        // try to insert the same data again
        doc.store().await.unwrap();
        // try another doc with the same `id` and `ver` and with different other fields
        let another_doc = FullSignedDoc::new(
            SignedDocBody::new(*doc.id(), *doc.ver(), doc_type, "Neil".to_string(), None),
            None,
            vec![],
        );
        assert!(another_doc.store().await.is_err());

        let res_doc = FullSignedDoc::retrieve(doc.id(), Some(doc.ver()))
            .await
            .unwrap();
        assert_eq!(doc, &res_doc);

        let res_doc = FullSignedDoc::retrieve(doc.id(), None).await.unwrap();
        assert_eq!(doc, &res_doc);

        let mut res_docs = pin!(SignedDocBody::retrieve(
            &DocsQueryFilter::DocId(*doc.id()),
            &QueryLimits::ALL
        )
        .await
        .unwrap());
        let res_doc = res_docs.try_next().await.unwrap().unwrap();
        assert_eq!(doc.body(), &res_doc);
        assert!(res_docs.try_next().await.unwrap().is_none());

        let mut res_docs = pin!(SignedDocBody::retrieve(
            &DocsQueryFilter::DocVer(*doc.id(), *doc.ver()),
            &QueryLimits::ALL,
        )
        .await
        .unwrap());
        let res_doc = res_docs.try_next().await.unwrap().unwrap();
        assert_eq!(doc.body(), &res_doc);
        assert!(res_docs.try_next().await.unwrap().is_none());

        let mut res_docs = pin!(SignedDocBody::retrieve(
            &DocsQueryFilter::Author(doc.author().clone()),
            &QueryLimits::ALL,
        )
        .await
        .unwrap());
        let res_doc = res_docs.try_next().await.unwrap().unwrap();
        assert_eq!(doc.body(), &res_doc);
        assert!(res_docs.try_next().await.unwrap().is_none());
    }

    let mut res_docs = pin!(SignedDocBody::retrieve(
        &DocsQueryFilter::DocType(doc_type),
        &QueryLimits::ALL
    )
    .await
    .unwrap());
    for exp_doc in docs.iter().rev() {
        let res_doc = res_docs.try_next().await.unwrap().unwrap();
        assert_eq!(exp_doc.body(), &res_doc);
    }

    let mut res_docs = pin!(
        SignedDocBody::retrieve(&DocsQueryFilter::All, &QueryLimits::ALL)
            .await
            .unwrap()
    );
    for exp_doc in docs.iter().rev() {
        let res_doc = res_docs.try_next().await.unwrap().unwrap();
        assert_eq!(exp_doc.body(), &res_doc);
    }
}
