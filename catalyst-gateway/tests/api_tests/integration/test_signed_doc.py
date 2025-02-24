import pytest
from loguru import logger
from utils import health
from api.v1 import document
from tempfile import NamedTemporaryFile
import subprocess
import json
from typing import Dict, Any
from uuid_extensions import uuid7str


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

    doc_id = uuid7str()
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
        resp.status_code == 201
    ), f"Failed to publish document: {resp.status_code} - {resp.text}"
    # Put a signed document again
    resp = document.put(data=signed_doc)
    assert (
        resp.status_code == 204
    ), f"Failed to publish document: {resp.status_code} - {resp.text}"

    # Get the signed document
    resp = document.get(document_id=doc_id)
    assert (
        resp.status_code == 200
    ), f"Failed to get document: {resp.status_code} - {resp.text}"

    # Post a signed document with filter ID
    resp = document.post("/index", filter={"id": {"eq": doc_id}})
    assert (
        resp.status_code == 200
    ), f"Failed to post document: {resp.status_code} - {resp.text}"

    # Put a signed document with same ID different content
    proposal_json["setup"]["title"]["title"] = "another title"
    signed_doc = build_signed_doc(metadata_json, proposal_json)
    resp = document.put(data=signed_doc)
    assert (
        resp.status_code == 422
    ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"

    # Put a signed document with same ID, but different version and different content
    metadata_json["ver"] = uuid7str()
    signed_doc = build_signed_doc(metadata_json, proposal_json)
    resp = document.put(data=signed_doc)
    assert (
        resp.status_code == 201
    ), f"Failed to publish document: {resp.status_code} - {resp.text}"

    # Pagination out of range
    resp = document.post(
        "/index?page=92233720368547759",
        filter={"id": {"eq": doc_id}},
    )
    assert (
        resp.status_code == 412
    ), f"Post document, expected 412 Precondition Failed: {resp.status_code} - {resp.text}"

    logger.info("Signed document test successful.")
