//! Integration tests of the `signed docs` queries

use futures::TryStreamExt;
use query_filter::EqOrRangedUuid;

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
                vec!["Alex".to_string()],
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
                vec!["Steven".to_string()],
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
                vec!["Sasha".to_string()],
                None,
            ),
            None,
            vec![9, 10, 11, 12],
        ),
    ];

    for doc in &docs {
        assert!(doc.store().await.unwrap());
        // try to insert the same data again
        assert!(!doc.store().await.unwrap());
        // try another doc with the same `id` and `ver` and with different other fields
        let another_doc = FullSignedDoc::new(
            SignedDocBody::new(
                *doc.id(),
                *doc.ver(),
                doc_type,
                vec!["Neil".to_string()],
                None,
            ),
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

        let filter = DocsQueryFilter {
            id: Some(EqOrRangedUuid::Eq(*doc.id())),
        };
        let mut res_docs = SignedDocBody::retrieve(&filter, &QueryLimits::ALL)
            .await
            .unwrap();
        let res_doc = res_docs.try_next().await.unwrap().unwrap();
        assert_eq!(doc.body(), &res_doc);
        assert!(res_docs.try_next().await.unwrap().is_none());

        // let mut res_docs = SignedDocBody::retrieve(
        //     &DocsQueryFilter::DocVer(*doc.id(), *doc.ver()),
        //     &QueryLimits::ALL,
        // )
        // .await
        // .unwrap();
        // let res_doc = res_docs.try_next().await.unwrap().unwrap();
        // assert_eq!(doc.body(), &res_doc);
        // assert!(res_docs.try_next().await.unwrap().is_none());

        // let mut res_docs = SignedDocBody::retrieve(
        //     &DocsQueryFilter::Author(doc.authors().first().unwrap().clone()),
        //     &QueryLimits::ALL,
        // )
        // .await
        // .unwrap();
        // let res_doc = res_docs.try_next().await.unwrap().unwrap();
        // assert_eq!(doc.body(), &res_doc);
        // assert!(res_docs.try_next().await.unwrap().is_none());
    }

    // let mut res_docs =
    //     SignedDocBody::retrieve(&DocsQueryFilter::DocType(doc_type), &QueryLimits::ALL)
    //         .await
    //         .unwrap();
    // for exp_doc in docs.iter().rev() {
    //     let res_doc = res_docs.try_next().await.unwrap().unwrap();
    //     assert_eq!(exp_doc.body(), &res_doc);
    // }

    // let mut res_docs = SignedDocBody::retrieve(&DocsQueryFilter::All,
    // &QueryLimits::ALL)     .await
    //     .unwrap();
    // for exp_doc in docs.iter().rev() {
    //     let res_doc = res_docs.try_next().await.unwrap().unwrap();
    //     assert_eq!(exp_doc.body(), &res_doc);
    // }
}
