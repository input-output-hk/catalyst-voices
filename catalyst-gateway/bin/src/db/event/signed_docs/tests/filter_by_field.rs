//! `filter_by_field` macro

/// `filter_by_field` test case
#[macro_export]
macro_rules! filter_by_field {
    ($doc:expr, $field:expr, $with_method:ident) => {
        #[allow(clippy::indexing_slicing)]
        if let Some(meta) = $doc.metadata() {
            let id = uuid::Uuid::from_str(meta[$field]["id"].clone().as_str().unwrap()).unwrap();
            let ver = uuid::Uuid::from_str(meta[$field]["ver"].clone().as_str().unwrap()).unwrap();

            // With id
            let filter = DocsQueryFilter::all().$with_method(DocumentRef {
                id: Some(EqOrRangedUuid::Eq(id)),
                ver: None,
            });
            let mut res_docs = SignedDocBody::retrieve(&filter, &QueryLimits::ALL)
                .await
                .unwrap();
            let res_doc = res_docs.try_next().await.unwrap().unwrap();
            assert_eq!($doc.body(), &res_doc);

            // With ver
            let filter = DocsQueryFilter::all().$with_method(DocumentRef {
                id: None,
                ver: Some(EqOrRangedUuid::Eq(ver)),
            });
            let mut res_docs = SignedDocBody::retrieve(&filter, &QueryLimits::ALL)
                .await
                .unwrap();
            let res_doc = res_docs.try_next().await.unwrap().unwrap();
            assert_eq!($doc.body(), &res_doc);

            // With both id and ver
            let filter = DocsQueryFilter::all().$with_method(DocumentRef {
                id: Some(EqOrRangedUuid::Eq(id)),
                ver: Some(EqOrRangedUuid::Eq(ver)),
            });
            let mut res_docs = SignedDocBody::retrieve(&filter, &QueryLimits::ALL)
                .await
                .unwrap();
            let res_doc = res_docs.try_next().await.unwrap().unwrap();
            assert_eq!($doc.body(), &res_doc);
        }
    };
}

pub(super) use filter_by_field;
