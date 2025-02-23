//! Document templates list.

use std::sync::LazyLock;

use super::SignedDocTemplate;

/// List of category templates, 12 categories for Fund 14.
#[rustfmt::skip]
// TODO: Fix Content once it is added
const CATEGORY_TEMPLATES: [(&str, &[u8]); 12] = [
    //              ID and Version          |                    Content
    ("0194d490-30bf-7473-81c8-a0eaef369619", include_bytes!("./docs/category/f14_category_1_template.schema.json")),
    ("0194d490-30bf-7043-8c5c-f0e09f8a6d8c", include_bytes!("./docs/category/f14_category_2_template.schema.json")),
    ("0194d490-30bf-7e75-95c1-a6cf0e8086d9", include_bytes!("./docs/category/f14_category_3_template.schema.json")),
    ("0194d490-30bf-7703-a1c0-83a916b001e7", include_bytes!("./docs/category/f14_category_4_template.schema.json")),
    ("0194d490-30bf-79d1-9a0f-84943123ef38", include_bytes!("./docs/category/f14_category_5_template.schema.json")),
    ("0194d490-30bf-706d-91c6-0d4707f74cdf", include_bytes!("./docs/category/f14_category_6_template.schema.json")),
    ("0194d490-30bf-759e-b729-304306fbaa5e", include_bytes!("./docs/category/f14_category_7_template.schema.json")),
    ("0194d490-30bf-7e27-b5fd-de3133b54bf6", include_bytes!("./docs/category/f14_category_8_template.schema.json")),
    ("0194d490-30bf-7f9e-8a5d-91fb67c078f2", include_bytes!("./docs/category/f14_category_9_template.schema.json")),
    ("0194d490-30bf-7676-9658-36c0b67e656e", include_bytes!("./docs/category/f14_category_10_template.schema.json")),
    ("0194d490-30bf-7978-b031-7aa2ccc5e3fd", include_bytes!("./docs/category/f14_category_11_template.schema.json")),
    ("0194d490-30bf-7d34-bba9-8498094bd627", include_bytes!("./docs/category/f14_category_12_template.schema.json")),

];

/// List of proposal templates, 12 proposals each of which is uniquely associated with one of the predefined categories.
#[rustfmt::skip]
const PROPOSAL_TEMPLATES: [(&str, &str); 12] = [
    //        ID and Version                |      Category ID
    ("0194d492-1daa-75b5-b4a4-5cf331cd8d1a", CATEGORY_TEMPLATES[0].0),
    ("0194d492-1daa-7371-8bd3-c15811b2b063", CATEGORY_TEMPLATES[1].0),
    ("0194d492-1daa-79c7-a222-2c3b581443a8", CATEGORY_TEMPLATES[2].0),
    ("0194d492-1daa-716f-a04e-f422f08a99dc", CATEGORY_TEMPLATES[3].0),
    ("0194d492-1daa-78fc-818a-bf20fc3e9b87", CATEGORY_TEMPLATES[4].0),
    ("0194d492-1daa-7d98-a3aa-c57d99121f78", CATEGORY_TEMPLATES[5].0),
    ("0194d492-1daa-77be-a1a5-c238fe25fe4f", CATEGORY_TEMPLATES[6].0),
    ("0194d492-1daa-7254-a512-30a4cdecfb90", CATEGORY_TEMPLATES[7].0),
    ("0194d492-1daa-7de9-b535-1a0b0474ed4e", CATEGORY_TEMPLATES[8].0),
    ("0194d492-1daa-7fce-84ee-b872a4661075", CATEGORY_TEMPLATES[9].0),
    ("0194d492-1daa-7878-9bcc-2c79fef0fc13", CATEGORY_TEMPLATES[10].0),
    ("0194d492-1daa-722f-94f4-687f2c068a5d", CATEGORY_TEMPLATES[11].0),

];

/// List of comment templates, 12 comments each of which is uniquely associated with one of the predefined categories.
#[rustfmt::skip]
const COMMENT_TEMPLATES: [(&str, &str); 12] = [
    //        ID and Version                |      Category ID
    ("0194d494-4402-7e0e-b8d6-171f8fea18b0", CATEGORY_TEMPLATES[0].0),
    ("0194d494-4402-7444-9058-9030815eb029", CATEGORY_TEMPLATES[1].0),
    ("0194d494-4402-7351-b4f7-24938dc2c12e", CATEGORY_TEMPLATES[2].0),
    ("0194d494-4402-79ad-93ba-4d7a0b65d563", CATEGORY_TEMPLATES[3].0),
    ("0194d494-4402-7cee-a5a6-5739839b3b8a", CATEGORY_TEMPLATES[4].0),
    ("0194d494-4402-7aee-8b24-b5300c976846", CATEGORY_TEMPLATES[5].0),
    ("0194d494-4402-7d75-be7f-1c4f3471a53c", CATEGORY_TEMPLATES[6].0),
    ("0194d494-4402-7a2c-8971-1b4c255c826d", CATEGORY_TEMPLATES[7].0),
    ("0194d494-4402-7074-86ac-3efd097ba9b0", CATEGORY_TEMPLATES[8].0),
    ("0194d494-4402-7202-8ebb-8c4c47c286d8", CATEGORY_TEMPLATES[9].0),
    ("0194d494-4402-7fb5-b680-c23fe4beb088", CATEGORY_TEMPLATES[10].0),
    ("0194d494-4402-7aa5-9dbc-5fe886e60ebc", CATEGORY_TEMPLATES[11].0),
];

/// List of raw templates, containing information to build signed document.
pub(crate) static TEMPLATE_DATA: LazyLock<Vec<SignedDocTemplate>> = LazyLock::new(|| {
    let mut templates = Vec::new();
    for tem in CATEGORY_TEMPLATES {
        templates.push(SignedDocTemplate {
            id: tem.0.to_owned(),
            ver: tem.0.to_owned(),
            doc_type: catalyst_signed_doc::doc_types::CATEGORY_TEMPLATE_UUID_TYPE,
            content: tem.1.to_vec(),
            category_id: tem.0.to_owned(),
        });
    }

    let proposal_template = include_bytes!("./docs/f14_proposal_template.schema.json");
    for tem in PROPOSAL_TEMPLATES {
        templates.push(SignedDocTemplate {
            id: tem.0.to_owned(),
            ver: tem.0.to_owned(),
            doc_type: catalyst_signed_doc::doc_types::PROPOSAL_TEMPLATE_UUID_TYPE,
            content: proposal_template.to_vec(),
            category_id: tem.1.to_owned(),
        });
    }

    let comment_template = include_bytes!("./docs/f14_comment_template.schema.json");
    for tem in COMMENT_TEMPLATES {
        templates.push(SignedDocTemplate {
            id: tem.0.to_owned(),
            ver: tem.0.to_owned(),
            doc_type: catalyst_signed_doc::doc_types::COMMENT_TEMPLATE_UUID_TYPE,
            content: comment_template.to_vec(),
            category_id: tem.1.to_owned(),
        });
    }
    templates
});
