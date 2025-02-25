import pytest
from loguru import logger
from utils import health
from api.v1 import document
from tempfile import NamedTemporaryFile
import subprocess
import json
from typing import Dict, Any
from uuid_extensions import uuid7str

proposal_doc_id = uuid7str()
proposal_metadata_json = {
    "alg": "EdDSA",
    "id": proposal_doc_id,
    "ver": proposal_doc_id,
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

comment_doc_id = uuid7str()
comment_metadata_json = {
    "alg": "EdDSA",
    "id": comment_doc_id,
    "ver": comment_doc_id,
    # Comment document type
    "type": "b679ded3-0e7c-41ba-89f8-da62a17898ea",
    "content-type": "application/json",
    "content-encoding": "br",
    "ref": {"id": proposal_doc_id},
    # referenced to the defined comment template id, comes from the 'templates/data.rs' file
    "template": {"id": "0194d494-4402-7e0e-b8d6-171f8fea18b0"},
}
with open("./test_data/signed_docs/comment.json", "r") as comment_json_file:
    comment_json = json.load(comment_json_file)


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


def test_proposal_doc():
    health.is_live()
    health.is_ready()

    # Put a proposal document
    proposal_doc = build_signed_doc(proposal_metadata_json, proposal_json)
    resp = document.put(data=proposal_doc)
    assert (
        resp.status_code == 201
    ), f"Failed to publish document: {resp.status_code} - {resp.text}"
    # Put a proposal document again
    resp = document.put(data=proposal_doc)
    assert (
        resp.status_code == 204
    ), f"Failed to publish document: {resp.status_code} - {resp.text}"

    # Get the proposal document
    resp = document.get(document_id=proposal_doc_id)
    assert (
        resp.status_code == 200
    ), f"Failed to get document: {resp.status_code} - {resp.text}"

    # Post a signed document with filter ID
    resp = document.post("/index", filter={"id": {"eq": proposal_doc_id}})
    assert (
        resp.status_code == 200
    ), f"Failed to post document: {resp.status_code} - {resp.text}"

    # Put a proposal document with same ID different content
    proposal_json["setup"]["title"]["title"] = "another title"
    proposal_doc = build_signed_doc(proposal_metadata_json, proposal_json)
    resp = document.put(data=proposal_doc)
    assert (
        resp.status_code == 422
    ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"

    # Put a signed document with same ID, but different version and different content
    proposal_metadata_json["ver"] = uuid7str()
    proposal_doc = build_signed_doc(proposal_metadata_json, proposal_json)
    resp = document.put(data=proposal_doc)
    assert (
        resp.status_code == 201
    ), f"Failed to publish document: {resp.status_code} - {resp.text}"

    # Put a proposal document corrupted content
    proposal_metadata_json["ver"] = uuid7str()
    proposal_doc = build_signed_doc(proposal_metadata_json, {"random": "random"})
    resp = document.put(data=proposal_doc)
    assert (
        resp.status_code == 422
    ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"

    # Put a proposal document with the not known template field
    proposal_metadata_json["template"] = {"id": uuid7str()}
    proposal_doc = build_signed_doc(proposal_metadata_json, proposal_json)
    resp = document.put(data=proposal_doc)
    assert (
        resp.status_code == 422
    ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"

    logger.info("Proposal document test successful.")


def test_comment_doc():
    health.is_live()
    health.is_ready()

    # Put a comment document
    comment_doc = build_signed_doc(comment_metadata_json, comment_json)
    resp = document.put(data=comment_doc)
    assert (
        resp.status_code == 201
    ), f"Failed to publish document: {resp.status_code} - {resp.text}"
    # Put a comment document again
    resp = document.put(data=comment_doc)
    assert (
        resp.status_code == 204
    ), f"Failed to publish document: {resp.status_code} - {resp.text}"

    # Get the comment document
    resp = document.get(document_id=comment_doc_id)
    assert (
        resp.status_code == 200
    ), f"Failed to get document: {resp.status_code} - {resp.text}"

    # Post a signed document with filter ID
    resp = document.post("/index", filter={"id": {"eq": proposal_doc_id}})
    assert (
        resp.status_code == 200
    ), f"Failed to post document: {resp.status_code} - {resp.text}"

    # Put a comment document corrupted content
    comment_metadata_json["ver"] = uuid7str()
    comment_doc = build_signed_doc(comment_metadata_json, {"random": "random"})
    resp = document.put(data=comment_doc)
    assert (
        resp.status_code == 422
    ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"

    # Put a comment document referencing to the not known proposal
    comment_metadata_json["ref"] = {"id": uuid7str()}
    comment_doc = build_signed_doc(comment_metadata_json, comment_json)
    resp = document.put(data=comment_doc)
    assert (
        resp.status_code == 422
    ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"

    logger.info("Signed document test successful.")


def test_pagination_out_of_range():
    health.is_live()
    health.is_ready()

    # Pagination out of range
    resp = document.post(
        "/index?page=92233720368547759",
        filter={},
    )
    assert (
        resp.status_code == 412
    ), f"Post document, expected 412 Precondition Failed: {resp.status_code} - {resp.text}"
