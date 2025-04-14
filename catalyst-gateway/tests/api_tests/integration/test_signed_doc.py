import pytest
from loguru import logger
from utils import health, signed_doc, uuid_v7
from api.v1 import document
import os
import json
from typing import Dict, Any, List
import copy
from utils.auth_token import rbac_auth_token_factory


class SignedDocument:
    def __init__(self, metadata: Dict[str, Any], content: Dict[str, Any]):
        self.metadata = metadata
        self.content = content

    def copy(self):
        new_copy = SignedDocument(
            metadata=copy.deepcopy(self.metadata),
            content=copy.deepcopy(self.content),
        )
        return new_copy

    # return hex bytes
    def hex(self) -> str:
        return signed_doc.build_signed_doc(self.metadata, self.content)


@pytest.fixture
def proposal_templates() -> List[str]:
    # comes from the 'templates/data.rs' file
    return [
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


@pytest.fixture
def comment_templates() -> List[str]:
    # comes from the 'templates/data.rs' file
    return [
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


# return a Proposal document which is already published to the cat-gateway
@pytest.fixture
def proposal_doc_factory(proposal_templates, rbac_auth_token_factory):
    def __proposal_doc_factory() -> SignedDocument:
        rbac_auth_token = rbac_auth_token_factory()
        proposal_doc_id = uuid_v7.uuid_v7()
        category_id = "0194d490-30bf-7473-81c8-a0eaef369619"
        proposal_metadata_json = {
            "id": proposal_doc_id,
            "ver": proposal_doc_id,
            # Proposal document type
            "type": "7808d2ba-d511-40af-84e8-c0d1625fdfdc",
            "content-type": "application/json",
            "content-encoding": "br",
            # referenced to the defined proposal template id, comes from the 'templates/data.rs' file
            "template": {
                "id": proposal_templates[0],
                "ver": proposal_templates[0],
            },
            # referenced to the defined category id, comes from the 'templates/data.rs' file
            "category_id": {
                "id": category_id,
                "ver": category_id,
            },
        }
        with open("./test_data/signed_docs/proposal.json", "r") as proposal_json_file:
            proposal_json = json.load(proposal_json_file)

        doc = SignedDocument(proposal_metadata_json, proposal_json)
        resp = document.put(data=doc.hex(), token=rbac_auth_token)
        assert (
            resp.status_code == 201
        ), f"Failed to publish document: {resp.status_code} - {resp.text}"

        return doc

    return __proposal_doc_factory


# return a Comment document which is already published to the cat-gateway
@pytest.fixture
def comment_doc_factory(
    proposal_doc_factory, comment_templates, rbac_auth_token_factory
) -> SignedDocument:
    def __comment_doc_factory() -> SignedDocument:
        rbac_auth_token = rbac_auth_token_factory()
        proposal_doc = proposal_doc_factory()
        comment_doc_id = uuid_v7.uuid_v7()
        comment_metadata_json = {
            "id": comment_doc_id,
            "ver": comment_doc_id,
            # Comment document type
            "type": "b679ded3-0e7c-41ba-89f8-da62a17898ea",
            "content-type": "application/json",
            "content-encoding": "br",
            "ref": {
                "id": proposal_doc.metadata["id"],
                "ver": proposal_doc.metadata["ver"],
            },
            "template": {
                "id": comment_templates[0],
                "ver": comment_templates[0],
            },
        }
        with open("./test_data/signed_docs/comment.json", "r") as comment_json_file:
            comment_json = json.load(comment_json_file)

        doc = SignedDocument(comment_metadata_json, comment_json)
        resp = document.put(data=doc.hex(), token=rbac_auth_token)
        assert (
            resp.status_code == 201
        ), f"Failed to publish document: {resp.status_code} - {resp.text}"

        return doc

    return __comment_doc_factory


# return a submission action document.
@pytest.fixture
def submission_action_factory(
    proposal_doc_factory, comment_templates, rbac_auth_token_factory
) -> SignedDocument:
    def __submission_action_factory() -> SignedDocument:
        rbac_auth_token = rbac_auth_token_factory()
        proposal_doc = proposal_doc_factory()
        submission_action_id = uuid_v7.uuid_v7()
        sub_action_metadata_json = {
            "id": submission_action_id,
            "ver": submission_action_id,
            # submission action type
            "type": "5e60e623-ad02-4a1b-a1ac-406db978ee48",
            "content-type": "application/json",
            "content-encoding": "br",
            "ref": {
                "id": proposal_doc.metadata["id"],
                "ver": proposal_doc.metadata["ver"],
            },
        }
        with open(
            "./test_data/signed_docs/submission_action.json", "r"
        ) as comment_json_file:
            comment_json = json.load(comment_json_file)

        doc = SignedDocument(sub_action_metadata_json, comment_json)
        resp = document.put(data=doc.hex(), token=rbac_auth_token)
        assert (
            resp.status_code == 201
        ), f"Failed to publish sub_action: {resp.status_code} - {resp.text}"

        return doc

    return __submission_action_factory


def test_templates(proposal_templates, comment_templates, rbac_auth_token_factory):
    rbac_auth_token = rbac_auth_token_factory()
    templates = proposal_templates + comment_templates
    for template_id in templates:
        resp = document.get(document_id=template_id, token=rbac_auth_token)
        assert (
            resp.status_code == 200
        ), f"Failed to get document: {resp.status_code} - {resp.text} for id {template_id}"


def test_proposal_doc(proposal_doc_factory, rbac_auth_token_factory):
    rbac_auth_token = rbac_auth_token_factory()
    proposal_doc = proposal_doc_factory()
    proposal_doc_id = proposal_doc.metadata["id"]

    # Put a proposal document again
    resp = document.put(data=proposal_doc.hex(), token=rbac_auth_token)
    assert (
        resp.status_code == 204
    ), f"Failed to publish document: {resp.status_code} - {resp.text}"

    # Get the proposal document
    resp = document.get(document_id=proposal_doc_id, token=rbac_auth_token)
    assert (
        resp.status_code == 200
    ), f"Failed to get document: {resp.status_code} - {resp.text}"

    # Post a signed document with filter ID
    resp = document.post(
        "/index", filter={"id": {"eq": proposal_doc_id}}, token=rbac_auth_token
    )
    assert (
        resp.status_code == 200
    ), f"Failed to post document: {resp.status_code} - {resp.text}"

    # Put a proposal document with same ID different content
    invalid_doc = proposal_doc.copy()
    invalid_doc.content["setup"]["title"]["title"] = "another title"
    resp = document.put(data=invalid_doc.hex(), token=rbac_auth_token)
    assert (
        resp.status_code == 422
    ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"

    # Put a signed document with same ID, but different version and different content
    new_doc = proposal_doc.copy()
    new_doc.metadata["ver"] = uuid_v7.uuid_v7()
    new_doc.content["setup"]["title"]["title"] = "another title"
    resp = document.put(data=new_doc.hex(), token=rbac_auth_token)
    assert (
        resp.status_code == 201
    ), f"Failed to publish document: {resp.status_code} - {resp.text}"

    # Put a proposal document with the not known template field
    invalid_doc = proposal_doc.copy()
    invalid_doc.metadata["template"] = {"id": uuid_v7.uuid_v7()}
    resp = document.put(data=invalid_doc.hex(), token=rbac_auth_token)
    assert (
        resp.status_code == 422
    ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"

    # Put a proposal document with empty content
    invalid_doc = proposal_doc.copy()
    invalid_doc.metadata["ver"] = uuid_v7.uuid_v7()
    invalid_doc.content = {}
    resp = document.put(data=invalid_doc.hex(), token=rbac_auth_token)
    assert (
        resp.status_code == 422
    ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"

    logger.info("Proposal document test successful.")


def test_comment_doc(comment_doc_factory, rbac_auth_token_factory):
    rbac_auth_token = rbac_auth_token_factory()
    comment_doc = comment_doc_factory()
    comment_doc_id = comment_doc.metadata["id"]

    # Put a comment document again
    resp = document.put(data=comment_doc.hex(), token=rbac_auth_token)
    assert (
        resp.status_code == 204
    ), f"Failed to publish document: {resp.status_code} - {resp.text}"

    # Get the comment document
    resp = document.get(document_id=comment_doc_id, token=rbac_auth_token)
    assert (
        resp.status_code == 200
    ), f"Failed to get document: {resp.status_code} - {resp.text}"

    # Post a signed document with filter ID
    resp = document.post(
        "/index", filter={"id": {"eq": comment_doc_id}}, token=rbac_auth_token
    )
    assert (
        resp.status_code == 200
    ), f"Failed to post document: {resp.status_code} - {resp.text}"

    # Put a comment document with empty content
    invalid_doc = comment_doc.copy()
    invalid_doc.metadata["ver"] = uuid_v7.uuid_v7()
    invalid_doc.content = {}
    resp = document.put(data=invalid_doc.hex(), token=rbac_auth_token)
    assert (
        resp.status_code == 422
    ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"

    # Put a comment document referencing to the not known proposal
    invalid_doc = comment_doc.copy()
    invalid_doc.metadata["ref"] = {"id": uuid_v7.uuid_v7()}
    resp = document.put(data=invalid_doc.hex(), token=rbac_auth_token)
    assert (
        resp.status_code == 422
    ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"

    logger.info("Comment document test successful.")


def test_submission_action(submission_action_factory, rbac_auth_token_factory):
    rbac_auth_token = rbac_auth_token_factory()
    submission_action = submission_action_factory()
    submission_action_id = submission_action.metadata["id"]

    # Put a submission action document
    resp = document.put(data=submission_action.hex(), token=rbac_auth_token)
    assert (
        resp.status_code == 204
    ), f"Failed to publish document: {resp.status_code} - {resp.text}"

    # Get the submission action doc
    resp = document.get(document_id=submission_action_id, token=rbac_auth_token)
    assert (
        resp.status_code == 200
    ), f"Failed to get document: {resp.status_code} - {resp.text}"

    # Post a signed document with filter ID
    resp = document.post(
        "/index", filter={"id": {"eq": submission_action_id}}, token=rbac_auth_token
    )
    assert (
        resp.status_code == 200
    ), f"Failed to post document: {resp.status_code} - {resp.text}"

    # Submission action document MUST have a ref
    invalid_doc = submission_action.copy()
    invalid_doc.metadata["ref"] = {}
    resp = document.put(data=invalid_doc.hex(), token=rbac_auth_token)
    assert (
        resp.status_code == 422
    ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"

    # Put a submission action document referencing an unknown proposal
    invalid_doc = submission_action.copy()
    invalid_doc.metadata["ref"] = {"id": uuid_v7.uuid_v7()}
    resp = document.put(data=invalid_doc.hex(), token=rbac_auth_token)
    assert (
        resp.status_code == 422
    ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"

    logger.info("Submission action document test successful.")


def test_document_index_endpoint(proposal_doc_factory, rbac_auth_token_factory):
    rbac_auth_token = rbac_auth_token_factory()
    # submiting 10 proposal documents
    total_amount = 10
    first_proposal = proposal_doc_factory()
    for _ in range(total_amount - 1):
        doc = first_proposal.copy()
        # keep the same id, but different version
        doc.metadata["ver"] = uuid_v7.uuid_v7()
        resp = document.put(data=doc.hex(), token=rbac_auth_token)
        assert (
            resp.status_code == 201
        ), f"Failed to publish document: {resp.status_code} - {resp.text}"

    limit = 1
    page = 0
    filter = {"id": {"eq": first_proposal.metadata["id"]}}
    resp = document.post(
        f"/index?limit={limit}&page={page}", filter=filter, token=rbac_auth_token
    )
    assert (
        resp.status_code == 200
    ), f"Failed to post document: {resp.status_code} - {resp.text}"

    data = resp.json()
    assert data["page"]["limit"] == limit
    assert data["page"]["page"] == page
    assert data["page"]["remaining"] == total_amount - 1 - page

    page += 1
    resp = document.post(
        f"/index?limit={limit}&page={page}", filter=filter, token=rbac_auth_token
    )
    assert (
        resp.status_code == 200
    ), f"Failed to post document: {resp.status_code} - {resp.text}"
    data = resp.json()
    print(data)
    assert data["page"]["limit"] == limit
    assert data["page"]["page"] == page
    assert data["page"]["remaining"] == total_amount - 1 - page

    resp = document.post(
        f"/index?limit={total_amount}", filter=filter, token=rbac_auth_token
    )
    assert (
        resp.status_code == 200
    ), f"Failed to post document: {resp.status_code} - {resp.text}"
    data = resp.json()
    assert data["page"]["limit"] == total_amount
    assert data["page"]["page"] == 0  # default value
    assert data["page"]["remaining"] == 0

    # Pagination out of range
    resp = document.post(
        "/index?page=92233720368547759", filter={}, token=rbac_auth_token
    )
    assert (
        resp.status_code == 412
    ), f"Post document, expected 412 Precondition Failed: {resp.status_code} - {resp.text}"

    logger.info("Document POST /index endpoint test successful.")
