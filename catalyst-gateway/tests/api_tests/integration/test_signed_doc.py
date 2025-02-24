import pytest
from loguru import logger
from utils import health
from api.v1 import document
from tempfile import NamedTemporaryFile
import subprocess
import json
from typing import Dict, Any


def build_signed_doc(
    metadata_json: Dict[str, Any], doc_content_json: Dict[str, Any]
) -> str:
    with NamedTemporaryFile() as metadata_file, NamedTemporaryFile() as doc_content_file, NamedTemporaryFile() as signed_doc_file:

        json_str = json.dumps(metadata_json)
        metadata_file.write(json_str.encode(encoding="utf-8"))
        metadata_file.flush()

        json_str = json.dumps(doc_content_json)
        doc_content_file.write(json_str.encode(encoding="utf-8"))
        doc_content_file.flush()

        subprocess.call(
            [
                "./mk_signed_doc",
                "build",
                doc_content_file.name,
                signed_doc_file.name,
                metadata_file.name,
            ]
        )

        signed_doc_hex = signed_doc_file.read().hex()
        return signed_doc_hex


def test_signed_doc():
    health.is_live()
    health.is_ready()

    doc_id = "01946ea1-818a-7e0e-b6b1-6169f02ffd4e"
    metadata_json = {
        "alg": "EdDSA",
        "id": doc_id,
        "ver": doc_id,
        # Proposal document type
        "type": "7808d2ba-d511-40af-84e8-c0d1625fdfdc",
        "content-type": "application/json",
        "content-encoding": "br",
        # referenced to the defined proposal template id, comes from the 'templates/data.rs' file
        "template": {"id": "0194d492-1daa-75b5-b4a4-5cf331cd8d1a"},
        # referenced to the defined category id, comes from the 'templates/data.rs' file
        "category_id": {"id": "0194d490-30bf-7473-81c8-a0eaef369619"},
    }

    with open("./test_data/signed_docs/proposal.json", "r") as proposal_json_file:
        proposal_json = json.load(proposal_json_file)

    # valid proposal document
    signed_doc = build_signed_doc(metadata_json, proposal_json)

    # Put a signed document
    resp = document.put(data=signed_doc)
    assert (
        201 <= resp.status_code <= 204
    ), f"Failed to publish document: {resp.status_code} - {resp.text}"
    # Put a signed document again
    resp = document.put(data=signed_doc)
    assert (
        resp.status_code == 204
    ), f"Failed to publish document: {resp.status_code} - {resp.text}"


#     # Get the signed document
#     resp = document.get(document_id="01946ea1-818a-7e0e-b6b1-6169f02ffd4e")
#     assert (
#         resp.status_code == 200
#     ), f"Failed to get document: {resp.status_code} - {resp.text}"

#     # Post a signed document with filter ID
#     resp = document.post(
#         "/index", filter={"id": {"eq": "01946ea1-818a-7e0e-b6b1-6169f02ffd4e"}}
#     )
#     assert (
#         resp.status_code == 200
#     ), f"Failed to post document: {resp.status_code} - {resp.text}"

#     # Put a signed document with same ID different content
#     signed_doc = "84585fa6012703183270436f6e74656e742d456e636f64696e676262726474797065d82550913c9265f9f944fcb3cf9d9516ae9baf626964d8255001946ea1818a7e0eb6b16169f02ffd4e63766572d8255001946ea1818a7e0eb6b16169f02ffd4ea0581c8b0b807b22616765223a33302c226e616d65223a22416c6578227d0380"
#     resp = document.put(data=signed_doc)
#     assert (
#         resp.status_code == 422
#     ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"

#     # Put a signed document with same ID, but different version
#     signed_doc = "84585fa6012703183270436f6e74656e742d456e636f64696e676262726474797065d82550913c9265f9f944fcb3cf9d9516ae9baf626964d8255001946ea1818a7e0eb6b16169f02ffd4e63766572d825500194d649960076639ebc1613291cf25fa0581c8b0b807b22616765223a32392c226e616d65223a22416c6578227d0380"
#     resp = document.put(data=signed_doc)
#     assert (
#         201 <= resp.status_code <= 204
#     ), f"Failed to publish document: {resp.status_code} - {resp.text}"

#     # Pagination out of range
#     resp = document.post(
#         "/index?page=92233720368547759",
#         filter={"id": {"eq": "01946ea1-818a-7e0e-b6b1-6169f02ffd4e"}},
#     )
#     assert (
#         resp.status_code == 412
#     ), f"Post document, expected 412 Precondition Failed: {resp.status_code} - {resp.text}"

#     logger.info("Signed document test successful.")
