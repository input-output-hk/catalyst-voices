# A collection of tests with the deprecated signed documents

from api.v1 import document


# Getting documents using GET `/v1/document` endpoint.
# Data `old_format_signed_doc.sql` should successfully passing through the migration process.
def test_get_migrated_documents():
    values = [
        (
            "019846aa-ecb7-7ce1-b7ce-c931abf47c7f",
            "d862845888a503706170706c69636174696f6e2f6a736f6e626964d82550019846aaecb77ce1b7cec931abf47c7f63766572d82550019846aaecb77ce1b7cec94660a040b56474797065d8255014ff79bed06849cc8c48a72f8ad276f16874656d706c61746582d82550019846aaecb77ce1b7cec95cf8f078c2d82550019846aaecb870b28636b65cb8539a87a0427b7d80",
        ),
        (
            "019846ad-4676-73f3-899f-a3786eb96651",
            "d862845883a503706170706c69636174696f6e2f6a736f6e626964d82550019846ad467673f3899fa3786eb9665163766572d82550019846ad467673f3899fa381cef1bb996474797065d8255050aa7cf6b35d4a2e92d603fe3b5ce9ef6372656682d82550019846ad467673f3899fa39cfd0df291d82550019846ad467673f3899fa3a925dc1c59a0427b7d80",
        ),
        (
            "019846ae-fad7-7cc3-9e0a-dfe6ad9ae61c",
            "d862845885a503706170706c69636174696f6e2f6a736f6e626964d82550019846aefad77cc39e0adfe6ad9ae61c63766572d82550019846aefad873c284e0f47e0b7845826474797065d8255082c486288228422a90ce690e18e757d4657265706c7982d82550019846aefad873c284e0f482cc5d5332d82550019846aefad873c284e0f494ac555584a0427b7d80",
        ),
        (
            "019846b0-09d9-7d92-befe-131b7022f17d",
            "d86284588aa503706170706c69636174696f6e2f6a736f6e626964d82550019846b009d97d92befe131b7022f17d63766572d82550019846b009d97d92befe13215cddcef86474797065d8255051551a191c924a25a9b0c58ec92c62216a706172616d657465727382d82550019846b009d97d92befe133d24cf102ed82550019846b009d97d92befe134ae513b067a0427b7d80",
        ),
        (
            "019846b0-fa10-7f13-a1aa-579c986d6251",
            "d86284588ba503706170706c69636174696f6e2f6a736f6e626964d82550019846b0fa107f13a1aa579c986d625163766572d82550019846b0fa107f13a1aa57ab6817b0a66474797065d8255022762c3472e84a5c9a3f080e94b46aa46b63617465676f72795f696482d82550019846b0fa107f13a1aa57b4529ffcd4d82550019846b0fa107f13a1aa57c5e41679a5a0427b7d80",
        ),
        (
            "019846b1-def7-77f2-b5f4-bb757a07d683",
            "d862845888a503706170706c69636174696f6e2f6a736f6e626964d82550019846b1def777f2b5f4bb757a07d68363766572d82550019846b1def777f2b5f4bb81760667766474797065d82550a8890f3faf934d8bbf387c6e47422054686272616e645f696482d82550019846b1def777f2b5f4bb92f3e9383fd82550019846b1def777f2b5f4bba83bae3e51a0427b7d80",
        ),
        (
            "019846b4-f0a9-7583-aa8b-5c0a991d50c0",
            "d86284588ba503706170706c69636174696f6e2f6a736f6e626964d82550019846b4f0a97583aa8b5c0a991d50c063766572d82550019846b4f0a97583aa8b5c1ba4e9bbad6474797065d825500eee1a2dcaaf4e7bbe4f4aaa2e80b6e26b63616d706169676e5f696482d82550019846b4f0a97583aa8b5c25d8cf2f06d82550019846b4f0a97583aa8b5c36e1f4b274a0427b7d80",
        ),
    ]

    for doc_id, doc_cbor in values:
        resp = document.get(document_id=doc_id)
        assert (
            resp.status_code == 200
        ), f"Failed to get document: {resp.status_code} - {resp.text}"
        assert (
            resp.text == doc_cbor
        ), f"Unexpected document cbor bytes, got: {resp.text}, expected: {doc_cbor}"


# Querying documents using POST `/v1/document/index` endpoint.
# Data `old_format_signed_doc.sql` should successfully passing through the migration process.
def test_v1_index_migrated_documents():
    values = [
        ({"template": {"id": {"eq": "019846aa-ecb7-7ce1-b7ce-c95cf8f078c2"}}}, {}),
        ({"ref": {"id": {"eq": "019846ad-4676-73f3-899f-a39cfd0df291"}}}, {}),
        ({"reply": {"id": {"eq": "019846ae-fad8-73c2-84e0-f482cc5d5332"}}}, {}),
        ({"parameters": {"id": {"eq": "019846b0-09d9-7d92-befe-133d24cf102e"}}}, {}),
        ({"parameters": {"id": {"eq": "019846b0-fa10-7f13-a1aa-57b4529ffcd4"}}}, {}),
        ({"parameters": {"id": {"eq": "019846b1-def7-77f2-b5f4-bb92f3e9383f"}}}, {}),
        ({"parameters": {"id": {"eq": "019846b4-f0a9-7583-aa8b-5c25d8cf2f06"}}}, {}),
    ]

    for filter_json, exp_json in values:
        resp = document.v1_post(filter=filter_json)
        assert (
            resp.status_code == 200
        ), f"Failed to post document: {resp.status_code} - {resp.text}"
        assert (
            resp.json == exp_json
        ), f"Unnexpected index of documents which match the query filter, got: {resp.json}, expected: {exp_json}"
