import pytest
from utils import uuid_v7
from api.v1 import document as document_v1
from api.v2 import document as document_v2
from utils.rbac_chain import rbac_chain_factory
from utils.signed_doc import (
    proposal_doc_factory,
)


@pytest.mark.preprod_indexing
def test_document_put_and_get_endpoints(proposal_doc_factory, rbac_chain_factory):
    (proposal_doc, role_id) = proposal_doc_factory()
    rbac_chain = rbac_chain_factory()
    (cat_id, sk_hex) = rbac_chain.cat_id_for_role(role_id)
    proposal_doc_id = proposal_doc.metadata["id"]

    # Get the proposal document
    resp = document_v1.get(document_id=proposal_doc_id)
    assert (
        resp.status_code == 200
    ), f"Failed to get document: {resp.status_code} - {resp.text}"

    resp = document_v2.post(filter={"id": [{"eq": proposal_doc_id}]})
    assert (
        resp.status_code == 200
    ), f"Failed to post document: {resp.status_code} - {resp.text}"

    # Put document with different ver
    new_doc = proposal_doc.copy()
    new_doc.new_version()
    new_doc_cbor = new_doc.build_and_sign(cat_id, sk_hex)
    resp = document_v1.put(
        data=new_doc_cbor,
        token=rbac_chain.auth_token(),
    )
    assert (
        resp.status_code == 201
    ), f"Failed to publish document: {resp.status_code} - {resp.text}"

    # Put a document again
    resp = document_v1.put(
        data=new_doc_cbor,
        token=rbac_chain.auth_token(),
    )
    # TODO: fix it after fully integrating the latest changes of the 'catalyst-signed-doc' crate
    assert (
        resp.status_code == 422
    ), f"Failed to publish document: {resp.status_code} - {resp.text}"

    # Put a non valid document with same ID different content
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
    new_doc.new_version()
    new_doc.content["setup"]["title"]["title"] = "another title"
    resp = document_v1.put(
        data=new_doc.build_and_sign(cat_id, sk_hex),
        token=rbac_chain.auth_token(),
    )
    assert (
        resp.status_code == 201
    ), f"Failed to publish document: {resp.status_code} - {resp.text}"


@pytest.mark.preprod_indexing
def test_document_index_endpoint(
    proposal_doc_factory,
    rbac_chain_factory,
):
    (doc, role_id) = proposal_doc_factory()

    rbac_chain = rbac_chain_factory()
    (cat_id, sk_hex) = rbac_chain.cat_id_for_role(role_id)
    # submiting 10 documents
    total_amount = 10

    for _ in range(total_amount - 1):
        doc = doc.copy()
        # keep the same id, but different version
        doc.new_version()
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
