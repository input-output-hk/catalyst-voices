import pytest
from utils.rbac_chain import rbac_chain_factory
from utils.admin import admin_key
import json
from utils.signed_doc import (
    proposal_doc_factory,
)

from api.v1 import document as document_v1
from api.v2 import document as document_v2


@pytest.mark.preprod_indexing
def test_document_put_and_get_endpoints(proposal_doc_factory, rbac_chain_factory):
    rbac_chain = rbac_chain_factory()
    proposal_doc = proposal_doc_factory()
    proposal_doc_id = proposal_doc.id()

    # Get the proposal document
    resp = document_v1.get(document_id=proposal_doc_id)
    assert resp.status_code == 200, (
        f"Failed to get document: {resp.status_code} - {resp.text}"
    )

    resp = document_v2.post(filter={"id": {"eq": proposal_doc_id}})
    assert resp.status_code == 200, (
        f"Failed to post document (id = eq): {resp.status_code} - {resp.text}"
    )

    resp = document_v2.post(filter={"id": {"in": [proposal_doc_id]}})
    assert resp.status_code == 200, (
        f"Failed to post document (id = in): {resp.status_code} - {resp.text}"
    )

    # Put document with different ver
    new_doc = proposal_doc_factory(id=proposal_doc.id(), publish=False)
    resp = document_v1.put(
        data=new_doc.hex_cbor(),
        token=rbac_chain.auth_token(),
    )
    assert resp.status_code == 201, (
        f"Failed to publish document: {resp.status_code} - {resp.text}"
    )

    # Put a document again
    resp = document_v1.put(
        data=new_doc.hex_cbor(),
        token=rbac_chain.auth_token(),
    )
    assert resp.status_code == 204, (
        f"Failed to publish document: {resp.status_code} - {resp.text}"
    )

    # # Put a non valid document
    invalid_doc = proposal_doc_factory(
        proposal_template_content={
            "type": "object",
            "properties": {"name": {"type": "string"}},
            "required": ["name"],
        },
        proposal_content={"age": 12},
        publish=False,
    )
    resp = document_v1.put(
        data=invalid_doc.hex_cbor(),
        token=rbac_chain.auth_token(),
    )
    assert resp.status_code == 422, (
        f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"
    )


@pytest.mark.preprod_indexing
def test_document_index_endpoint(
    proposal_doc_factory,
    rbac_chain_factory,
): 
    doc = proposal_doc_factory()
    rbac_chain = rbac_chain_factory()
    # submiting 10 documents
    total_amount = 10

    for _ in range(total_amount - 1):
        doc = proposal_doc_factory(id=doc.id(), publish=False)
        # keep the same id, but different version
        resp = document_v1.put(
            data=doc.hex_cbor(),
            token=rbac_chain.auth_token(),
        )
        assert resp.status_code == 201, (
            f"Failed to publish document: {resp.status_code} - {resp.text}"
        )

    limit = 1
    page = 0
    filter = {"id": {"eq": doc.id()}}
    resp = document_v2.post(
        limit=limit,
        page=page,
        filter=filter,
    )
    assert resp.status_code == 200, (
        f"Failed to post document: {resp.status_code} - {resp.text}"
    )

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
    assert resp.status_code == 200, (
        f"Failed to post document: {resp.status_code} - {resp.text}"
    )
    data = resp.json()
    assert data["page"]["limit"] == limit
    assert data["page"]["page"] == page
    assert data["page"]["remaining"] == total_amount - 1 - page

    resp = document_v2.post(
        limit=total_amount,
        filter=filter,
    )
    assert resp.status_code == 200, (
        f"Failed to post document: {resp.status_code} - {resp.text}"
    )
    data = resp.json()
    assert data["page"]["limit"] == total_amount
    assert data["page"]["page"] == 0  # default value
    assert data["page"]["remaining"] == 0

    # Pagination out of range
    resp = document_v2.post(
        page=92233720368547759,
        filter={},
    )
    assert resp.status_code == 412, (
        f"Post document, expected 412 Precondition Failed: {resp.status_code} - {resp.text}"
    )
