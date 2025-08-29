import pytest
from utils import uuid_v7
from api.v1 import document as document_v1
from api.v2 import document as document_v2
from utils.rbac_chain import rbac_chain_factory, RoleID
from utils.signed_doc import (
    proposal_templates,
    comment_templates,
    proposal_doc_factory,
    comment_doc_factory,
    submission_action_factory,
)
import cbor2
import uuid


def test_templates(proposal_templates, comment_templates):
    templates = proposal_templates + comment_templates
    for template_id in templates:
        resp = document_v1.get(document_id=template_id)
        assert (
            resp.status_code == 200
        ), f"Failed to get document: {resp.status_code} - {resp.text} for id {template_id}"


@pytest.mark.preprod_indexing
def test_proposal_doc(proposal_doc_factory, rbac_chain_factory):
    (proposal_doc, role_id) = proposal_doc_factory()
    rbac_chain = rbac_chain_factory()
    (cat_id, sk_hex) = rbac_chain.cat_id_for_role(role_id)
    proposal_doc_id = proposal_doc.metadata["id"]

    # Get the proposal document
    resp = document_v1.get(document_id=proposal_doc_id)
    assert (
        resp.status_code == 200
    ), f"Failed to get document: {resp.status_code} - {resp.text}"

    # Post a signed document with filter ID
    resp = document_v2.post(filter={"id": [{"eq": proposal_doc_id}]})
    assert (
        resp.status_code == 200
    ), f"Failed to post document: {resp.status_code} - {resp.text}"

    # Put document with different ver
    new_doc = proposal_doc.copy()
    new_doc.metadata["ver"] = uuid_v7.uuid_v7()
    new_doc_cbor = new_doc.build_and_sign(cat_id, sk_hex)
    resp = document_v1.put(
        data=new_doc_cbor,
        token=rbac_chain.auth_token(),
    )
    assert (
        resp.status_code == 201
    ), f"Failed to publish document: {resp.status_code} - {resp.text}"

    # Put a comment document again
    resp = document_v1.put(
        data=new_doc_cbor,
        token=rbac_chain.auth_token(),
    )
    assert (
        resp.status_code == 204
    ), f"Failed to publish document: {resp.status_code} - {resp.text}"

    # Put a proposal document with same ID different content
    invalid_doc = proposal_doc.copy()
    invalid_doc.content["setup"]["title"]["title"] = "another title"
    resp = document_v1.put(
        data=invalid_doc.build_and_sign(cat_id, sk_hex),
        token=rbac_chain.auth_token(),
    )
    assert (
        resp.status_code == 422
    ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"

    # Put a signed document with same ID, but different version and different content
    new_doc = proposal_doc.copy()
    new_doc.metadata["ver"] = uuid_v7.uuid_v7()
    new_doc.content["setup"]["title"]["title"] = "another title"
    resp = document_v1.put(
        data=new_doc.build_and_sign(cat_id, sk_hex),
        token=rbac_chain.auth_token(),
    )
    assert (
        resp.status_code == 201
    ), f"Failed to publish document: {resp.status_code} - {resp.text}"

    # Put a proposal document with the not known template field
    invalid_doc = proposal_doc.copy()
    invalid_doc.metadata["template"] = {"id": uuid_v7.uuid_v7()}
    resp = document_v1.put(
        data=invalid_doc.build_and_sign(cat_id, sk_hex),
        token=rbac_chain.auth_token(),
    )
    assert (
        resp.status_code == 422
    ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"

    # Put a proposal document with empty content
    invalid_doc = proposal_doc.copy()
    invalid_doc.metadata["ver"] = uuid_v7.uuid_v7()
    invalid_doc.content = {}
    resp = document_v1.put(
        data=invalid_doc.build_and_sign(cat_id, sk_hex),
        token=rbac_chain.auth_token(),
    )
    assert (
        resp.status_code == 422
    ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"

    # Put a submission action document with the non allowed RoleID
    for invalid_role in RoleID:
        if invalid_role != role_id:
            invalid_doc = proposal_doc.copy()
            invalid_doc.metadata["ver"] = uuid_v7.uuid_v7()
            (inv_cat_id, inv_sk_hex) = rbac_chain.cat_id_for_role(invalid_role)
            resp = document_v1.put(
                data=invalid_doc.build_and_sign(inv_cat_id, inv_sk_hex),
                token=rbac_chain.auth_token(),
            )
            assert (
                resp.status_code == 422
            ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"


@pytest.mark.preprod_indexing
def test_comment_doc(comment_doc_factory, rbac_chain_factory):
    (comment_doc, role_id) = comment_doc_factory()
    rbac_chain = rbac_chain_factory()
    (cat_id, sk_hex) = rbac_chain.cat_id_for_role(role_id)
    comment_doc_id = comment_doc.metadata["id"]

    # Get the comment document
    resp = document_v1.get(document_id=comment_doc_id)
    assert (
        resp.status_code == 200
    ), f"Failed to get document: {resp.status_code} - {resp.text}"

    # Post a signed document with filter ID
    resp = document_v2.post(filter={"id": [{"eq": comment_doc_id}]})
    assert (
        resp.status_code == 200
    ), f"Failed to post document: {resp.status_code} - {resp.text}"

    # Put document with different ver
    new_doc = comment_doc.copy()
    new_doc.metadata["ver"] = uuid_v7.uuid_v7()
    new_doc_cbor = new_doc.build_and_sign(cat_id, sk_hex)
    resp = document_v1.put(
        data=new_doc_cbor,
        token=rbac_chain.auth_token(),
    )
    assert (
        resp.status_code == 201
    ), f"Failed to publish document: {resp.status_code} - {resp.text}"

    # Put a comment document again
    resp = document_v1.put(
        data=new_doc_cbor,
        token=rbac_chain.auth_token(),
    )
    assert (
        resp.status_code == 204
    ), f"Failed to publish document: {resp.status_code} - {resp.text}"

    # Put a comment document with empty content
    invalid_doc = comment_doc.copy()
    invalid_doc.metadata["ver"] = uuid_v7.uuid_v7()
    invalid_doc.content = {}
    resp = document_v1.put(
        data=invalid_doc.build_and_sign(cat_id, sk_hex),
        token=rbac_chain.auth_token(),
    )
    assert (
        resp.status_code == 422
    ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"

    # Put a comment document referencing to the not known proposal
    invalid_doc = comment_doc.copy()
    invalid_doc.metadata["ref"] = {"id": uuid_v7.uuid_v7()}
    resp = document_v1.put(
        data=invalid_doc.build_and_sign(cat_id, sk_hex),
        token=rbac_chain.auth_token(),
    )
    assert (
        resp.status_code == 422
    ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"

    # Put a submission action document with the non allowed RoleID
    for invalid_role in RoleID:
        if invalid_role != role_id:
            invalid_doc = comment_doc.copy()
            invalid_doc.metadata["ver"] = uuid_v7.uuid_v7()
            (inv_cat_id, inv_sk_hex) = rbac_chain.cat_id_for_role(invalid_role)
            resp = document_v1.put(
                data=invalid_doc.build_and_sign(inv_cat_id, inv_sk_hex),
                token=rbac_chain.auth_token(),
            )
            assert (
                resp.status_code == 422
            ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"


@pytest.mark.preprod_indexing
def test_submission_action(submission_action_factory, rbac_chain_factory):
    (submission_action, role_id) = submission_action_factory()
    rbac_chain = rbac_chain_factory()
    (cat_id, sk_hex) = rbac_chain.cat_id_for_role(role_id)
    submission_action_id = submission_action.metadata["id"]

    # Get the submission action doc
    resp = document_v1.get(
        document_id=submission_action_id,
    )
    assert (
        resp.status_code == 200
    ), f"Failed to get document: {resp.status_code} - {resp.text}"

    # Post a signed document with filter ID
    resp = document_v2.post(
        filter={"id": [{"eq": submission_action_id}]},
    )
    assert (
        resp.status_code == 200
    ), f"Failed to post document: {resp.status_code} - {resp.text}"

    # Put document with different ver
    new_doc = submission_action.copy()
    new_doc.metadata["ver"] = uuid_v7.uuid_v7()
    new_doc_cbor = new_doc.build_and_sign(cat_id, sk_hex)
    resp = document_v1.put(
        data=new_doc_cbor,
        token=rbac_chain.auth_token(),
    )
    assert (
        resp.status_code == 201
    ), f"Failed to publish document: {resp.status_code} - {resp.text}"

    # Put a comment document again
    resp = document_v1.put(
        data=new_doc_cbor,
        token=rbac_chain.auth_token(),
    )
    assert (
        resp.status_code == 204
    ), f"Failed to publish document: {resp.status_code} - {resp.text}"

    # Submission action document MUST have a ref
    invalid_doc = submission_action.copy()
    invalid_doc.metadata["ref"] = {}
    resp = document_v1.put(
        data=invalid_doc.build_and_sign(cat_id, sk_hex),
        token=rbac_chain.auth_token(),
    )
    assert (
        resp.status_code == 422
    ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"

    # Put a submission action document referencing an unknown proposal
    invalid_doc = submission_action.copy()
    invalid_doc.metadata["ref"] = {"id": uuid_v7.uuid_v7()}
    resp = document_v1.put(
        data=invalid_doc.build_and_sign(cat_id, sk_hex),
        token=rbac_chain.auth_token(),
    )
    assert (
        resp.status_code == 422
    ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"

    # Put a submission action document with the non allowed RoleID
    for invalid_role in RoleID:
        if invalid_role != role_id:
            invalid_doc = submission_action.copy()
            invalid_doc.metadata["ver"] = uuid_v7.uuid_v7()
            (inv_cat_id, inv_sk_hex) = rbac_chain.cat_id_for_role(invalid_role)
            resp = document_v1.put(
                data=invalid_doc.build_and_sign(inv_cat_id, inv_sk_hex),
                token=rbac_chain.auth_token(),
            )
            assert (
                resp.status_code == 422
            ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"


@pytest.mark.preprod_indexing
def test_invalid_signature(
    submission_action_factory,
    comment_doc_factory,
    proposal_doc_factory,
    rbac_chain_factory,
):
    for doc, role_id in [
        submission_action_factory(),
        comment_doc_factory(),
        proposal_doc_factory(),
    ]:
        rbac_chain = rbac_chain_factory()
        (cat_id, sk_hex) = rbac_chain.cat_id_for_role(role_id)
        doc.metadata["ver"] = uuid_v7.uuid_v7()
        valid_doc_hex = doc.build_and_sign(cat_id, sk_hex)

        # corrupt signature
        doc_cbor = cbor2.loads(bytes.fromhex(valid_doc_hex)).value
        doc_cbor[3][0][2] = doc_cbor[3][0][2] + b"extra bytes"

        resp = document_v1.put(
            data=cbor2.dumps(doc_cbor).hex(),
            token=rbac_chain.auth_token(),
        )
        assert (
            resp.status_code == 422
        ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"

        # modify document without changing signature
        doc_cbor = cbor2.loads(bytes.fromhex(valid_doc_hex)).value
        protected_headers = cbor2.loads(doc_cbor[0])
        protected_headers["ver"] = uuid.UUID(uuid_v7.uuid_v7())
        doc_cbor[0] = cbor2.dumps(protected_headers)

        resp = document_v1.put(
            data=cbor2.dumps(doc_cbor).hex(),
            token=rbac_chain.auth_token(),
        )
        assert (
            resp.status_code == 422
        ), f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"


@pytest.mark.preprod_indexing
def test_document_index_endpoint(
    submission_action_factory,
    comment_doc_factory,
    proposal_doc_factory,
    rbac_chain_factory,
):
    for doc_factory in [
        submission_action_factory,
        comment_doc_factory,
        proposal_doc_factory,
    ]:
        (doc, role_id) = doc_factory()

        rbac_chain = rbac_chain_factory()
        (cat_id, sk_hex) = rbac_chain.cat_id_for_role(role_id)
        # submiting 10 documents
        total_amount = 10

        for _ in range(total_amount - 1):
            doc = doc.copy()
            # keep the same id, but different version
            doc.metadata["ver"] = uuid_v7.uuid_v7()
            resp = document_v1.put(
                data=doc.build_and_sign(cat_id, sk_hex),
                token=rbac_chain.auth_token(),
            )
            assert (
                resp.status_code == 201
            ), f"Failed to publish document: {resp.status_code} - {resp.text}"

        limit = 1
        page = 0
        filter = {"id": [{"eq": doc.metadata["id"]}]}
        resp = document_v2.post(
            limit=limit,
            page=page,
            filter=filter,
        )
        assert (
            resp.status_code == 200
        ), f"Failed to post document: {resp.status_code} - {resp.text}"

        data = resp.json()
        assert data["page"]["limit"] == limit
        assert data["page"]["page"] == page
        assert data["page"]["remaining"] == total_amount - 1 - page

        page += 1
        resp = document_v2.post(
            limit=limit,
            page=page,
            filter=filter,
        )
        assert (
            resp.status_code == 200
        ), f"Failed to post document: {resp.status_code} - {resp.text}"
        data = resp.json()
        assert data["page"]["limit"] == limit
        assert data["page"]["page"] == page
        assert data["page"]["remaining"] == total_amount - 1 - page

        resp = document_v2.post(
            limit=total_amount,
            filter=filter,
        )
        assert (
            resp.status_code == 200
        ), f"Failed to post document: {resp.status_code} - {resp.text}"
        data = resp.json()
        assert data["page"]["limit"] == total_amount
        assert data["page"]["page"] == 0  # default value
        assert data["page"]["remaining"] == 0

        # Pagination out of range
        resp = document_v2.post(
            page=92233720368547759,
            filter={},
        )
        assert (
            resp.status_code == 412
        ), f"Post document, expected 412 Precondition Failed: {resp.status_code} - {resp.text}"
