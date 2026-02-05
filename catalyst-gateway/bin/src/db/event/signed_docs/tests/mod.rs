//! Integration tests of the `signed docs` queries

use std::str::FromStr;

use futures::TryStreamExt;

use super::*;
use crate::db::event::{
    common::{query_limits::QueryLimits, uuid_selector::UuidSelector},
    establish_connection_pool,
};

mod filter_by_field;

#[ignore = "An integration test which requires a running EventDB instance, disabled from `testunit` CI run"]
#[tokio::test]
async fn queries_test() {
    establish_connection_pool();

    let doc_type = uuid::Uuid::new_v4();
    let docs = test_docs(doc_type);

    for doc in &docs {
        store_full_signed_doc(doc, doc_type).await;
        retrieve_full_signed_doc(doc).await;
        filter_by_id(doc).await;
        filter_by_ver(doc).await;
        filter_by_id_and_ver(doc).await;

        filter_by_field::filter_by_field!(doc, "ref", with_ref);
        filter_by_field::filter_by_field!(doc, "template", with_template);
        filter_by_field::filter_by_field!(doc, "reply", with_reply);
        filter_by_field::filter_by_field!(doc, "parameters", with_parameters);
    }

    filter_by_type(&docs, doc_type).await;
    filter_all(&docs).await;
    filter_count(&docs).await;
}

fn test_docs(doc_type: uuid::Uuid) -> Vec<FullSignedDoc> {
    vec![
        FullSignedDoc::new(
            SignedDocBody::new(
                uuid::Uuid::now_v7(),
                uuid::Uuid::now_v7(),
                doc_type,
                vec!["Alex".to_string()],
                Some(serde_json::json!(
                    {
                        "ref": [{ "id": uuid::Uuid::now_v7(), "ver": uuid::Uuid::now_v7(), "cid": "0x" }],
                        "template": [{ "id": uuid::Uuid::now_v7(), "ver": uuid::Uuid::now_v7(), "cid": "0x" }],
                        "reply": [{ "id": uuid::Uuid::now_v7(), "ver": uuid::Uuid::now_v7(), "cid": "0x" }],
                        "parameters": [{ "id": uuid::Uuid::now_v7(), "ver": uuid::Uuid::now_v7(), "cid": "0x" }],
                    }
                )),
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
                Some(serde_json::json!(
                    {
                        "ref": [{ "id": uuid::Uuid::now_v7(), "ver": uuid::Uuid::now_v7(), "cid": "0x" }],
                        "template": [{ "id": uuid::Uuid::now_v7(), "ver": uuid::Uuid::now_v7(), "cid": "0x" }],
                        "reply": [{ "id": uuid::Uuid::now_v7(), "ver": uuid::Uuid::now_v7(), "cid": "0x" }],
                        "parameters": [{ "id": uuid::Uuid::now_v7(), "ver": uuid::Uuid::now_v7(), "cid": "0x" }],
                    }
                )),
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
    ]
}

async fn store_full_signed_doc(
    doc: &FullSignedDoc,
    doc_type: uuid::Uuid,
) {
    assert!(doc.store().await.is_ok());
    // try to insert the same data again
    assert!(doc.store().await.is_err());
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
}

async fn retrieve_full_signed_doc(doc: &FullSignedDoc) {
    let res_doc = FullSignedDoc::retrieve_one(doc.id(), Some(doc.ver()))
        .await
        .unwrap()
        .unwrap();
    assert_eq!(doc, &res_doc);
    let res_doc = FullSignedDoc::retrieve_one(doc.id(), None)
        .await
        .unwrap()
        .unwrap();
    assert_eq!(doc, &res_doc);
}

async fn filter_by_id(doc: &FullSignedDoc) {
    let filter = DocsQueryFilter::all().with_id(UuidSelector::Eq(*doc.id()));
    let mut res_docs = SignedDocBody::retrieve(&filter, &QueryLimits::ALL)
        .await
        .unwrap();
    let res_doc = res_docs.try_next().await.unwrap().unwrap();
    assert_eq!(doc.body(), &res_doc);
    assert!(res_docs.try_next().await.unwrap().is_none());

    let filter = DocsQueryFilter::all().with_id(UuidSelector::Range {
        min: *doc.id(),
        max: *doc.id(),
    });
    let mut res_docs = SignedDocBody::retrieve(&filter, &QueryLimits::ALL)
        .await
        .unwrap();
    let res_doc = res_docs.try_next().await.unwrap().unwrap();
    assert_eq!(doc.body(), &res_doc);
    assert!(res_docs.try_next().await.unwrap().is_none());
}

async fn filter_by_ver(doc: &FullSignedDoc) {
    let filter = DocsQueryFilter::all().with_ver(UuidSelector::Eq(*doc.ver()));
    let mut res_docs = SignedDocBody::retrieve(&filter, &QueryLimits::ALL)
        .await
        .unwrap();
    let res_doc = res_docs.try_next().await.unwrap().unwrap();
    assert_eq!(doc.body(), &res_doc);
    assert!(res_docs.try_next().await.unwrap().is_none());

    let filter = DocsQueryFilter::all().with_ver(UuidSelector::Range {
        min: *doc.ver(),
        max: *doc.ver(),
    });
    let mut res_docs = SignedDocBody::retrieve(&filter, &QueryLimits::ALL)
        .await
        .unwrap();
    let res_doc = res_docs.try_next().await.unwrap().unwrap();
    assert_eq!(doc.body(), &res_doc);
    assert!(res_docs.try_next().await.unwrap().is_none());
}

async fn filter_by_id_and_ver(doc: &FullSignedDoc) {
    let filter = DocsQueryFilter::all()
        .with_id(UuidSelector::Eq(*doc.id()))
        .with_ver(UuidSelector::Eq(*doc.ver()));
    let mut res_docs = SignedDocBody::retrieve(&filter, &QueryLimits::ALL)
        .await
        .unwrap();
    let res_doc = res_docs.try_next().await.unwrap().unwrap();
    assert_eq!(doc.body(), &res_doc);
    assert!(res_docs.try_next().await.unwrap().is_none());
}

async fn filter_by_type(
    docs: &[FullSignedDoc],
    doc_type: uuid::Uuid,
) {
    let filter = DocsQueryFilter::all().with_type(vec![doc_type]);
    let mut res_docs = SignedDocBody::retrieve(&filter, &QueryLimits::ALL)
        .await
        .unwrap();
    for exp_doc in docs.iter().rev() {
        let res_doc = res_docs.try_next().await.unwrap().unwrap();
        assert_eq!(exp_doc.body(), &res_doc);
    }
}

/// Pre-seeded documents `f14.sql`, `f15.sql`, `old_format_signed_doc.sql`
const PRE_SEED_DATA: usize = 55;

async fn filter_all(docs: &[FullSignedDoc]) {
    let filter = DocsQueryFilter::all();
    let mut res_docs = SignedDocBody::retrieve(&filter, &QueryLimits::ALL)
        .await
        .unwrap();
    for exp_doc in docs.iter().skip(PRE_SEED_DATA).rev() {
        let res_doc = res_docs.try_next().await.unwrap().unwrap();
        assert_eq!(exp_doc.body(), &res_doc);
    }
}

async fn filter_count(docs: &[FullSignedDoc]) {
    let len: i64 = (docs.len().saturating_add(PRE_SEED_DATA))
        .try_into()
        .unwrap();
    let filter = DocsQueryFilter::all();
    let count = SignedDocBody::retrieve_count(&filter).await.unwrap();
    assert_eq!(len, count);
}
