import pytest
from loguru import logger
from utils import health
from api.v1 import document
from tempfile import NamedTemporaryFile
import subprocess
import os
import json
from typing import Dict, Any, List
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

        mk_signed_doc_absolute_path = os.path.abspath("mk_signed_doc")
        print(mk_signed_doc_absolute_path)
        subprocess.run(
            f"{mk_signed_doc_absolute_path} build {doc_content_file.name} {signed_doc_file.name} {metadata_file.name}",
            shell=True,
        )

        signed_doc_hex = signed_doc_file.read().hex()
        print(f"signed_doc_hex: {signed_doc_hex}")
        return signed_doc_hex


def test_signed_doc():
    health.is_live()
    health.is_ready()

    # comes from the 'templates/data.rs' file
    proposal_templates = [
        "0194d492-1daa-75b5-b4a4-5cf331cd8d1a",
        "0194d492-1daa-7371-8bd3-c15811b2b063",
        "0194d492-1daa-79c7-a222-2c3b581443a8",
        "0194d492-1daa-716f-a04e-f422f08a99dc",
        "0194d492-1daa-78fc-818a-bf20fc3e9b87",
        "0194d492-1daa-7d98-a3aa-c57d99121f78",
        "0194d492-1daa-77be-a1a5-c238fe25fe4f",
        "0194d492-1daa-7254-a512-30a4cdecfb90",
        "0194d492-1daa-7de9-b535-1a0b0474ed4e",
        "0194d492-1daa-7fce-84ee-b872a4661075",
        "0194d492-1daa-7878-9bcc-2c79fef0fc13",
        "0194d492-1daa-722f-94f4-687f2c068a5d",
    ]
    comment_templates = [
        "0194d494-4402-7e0e-b8d6-171f8fea18b0",
        "0194d494-4402-7444-9058-9030815eb029",
        "0194d494-4402-7351-b4f7-24938dc2c12e",
        "0194d494-4402-79ad-93ba-4d7a0b65d563",
        "0194d494-4402-7cee-a5a6-5739839b3b8a",
        "0194d494-4402-7aee-8b24-b5300c976846",
        "0194d494-4402-7d75-be7f-1c4f3471a53c",
        "0194d494-4402-7a2c-8971-1b4c255c826d",
        "0194d494-4402-7074-86ac-3efd097ba9b0",
        "0194d494-4402-7202-8ebb-8c4c47c286d8",
        "0194d494-4402-7fb5-b680-c23fe4beb088",
        "0194d494-4402-7aa5-9dbc-5fe886e60ebc",
    ]

    # prepare the data
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
        "template": {"id": proposal_templates[0]},
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
        "template": {"id": comment_templates[0]},
    }
    with open("./test_data/signed_docs/comment.json", "r") as comment_json_file:
        comment_json = json.load(comment_json_file)

    templates_doc_check(proposal_templates + comment_templates)
    proposal_doc_check(proposal_metadata_json, proposal_json)
    comment_doc_check(comment_metadata_json, comment_json)
    pagination_out_of_range_check()


def templates_doc_check(template_ids: List[str]):
    for template_id in template_ids:
        resp = document.get(document_id=template_id)
        assert (
            resp.status_code == 200
        ), f"Failed to get document: {resp.status_code} - {resp.text} for id {template_id}"


def proposal_doc_check(
    proposal_metadata_json: Dict[str, Any], proposal_json: Dict[str, Any]
):
    proposal_doc_id = proposal_metadata_json["id"]

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

    # Put a proposal document with empty content
    proposal_metadata_json["ver"] = uuid7str()
    proposal_doc = build_signed_doc(proposal_metadata_json, {})
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


def comment_doc_check(
    comment_metadata_json: Dict[str, Any], comment_json: Dict[str, Any]
):
    comment_doc_id = comment_metadata_json["id"]

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
    resp = document.post("/index", filter={"id": {"eq": comment_doc_id}})
    assert (
        resp.status_code == 200
    ), f"Failed to post document: {resp.status_code} - {resp.text}"

    # Put a comment document with empty content
    comment_metadata_json["ver"] = uuid7str()
    comment_doc = build_signed_doc(comment_metadata_json, {})
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

    logger.info("Comment document test successful.")


def pagination_out_of_range_check():
    # Pagination out of range
    resp = document.post(
        "/index?page=92233720368547759",
        filter={},
    )
    assert (
        resp.status_code == 412
    ), f"Post document, expected 412 Precondition Failed: {resp.status_code} - {resp.text}"

    logger.info("Templates test successful.")
