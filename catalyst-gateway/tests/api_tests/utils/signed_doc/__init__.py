import pytest
import json
from utils.rbac_chain import rbac_chain_factory
from utils.admin import admin_key
from tempfile import NamedTemporaryFile

from api.v1 import document
from catalyst_python.catalyst_ffi import (
    CatalystSignedDocument,
    brand_parameters_form_template_doc,
    brand_parameters_doc,
    campaign_parameters_form_template_doc,
    campaign_parameters_doc,
    category_parameters_form_template_doc,
    category_parameters_doc,
    proposal_form_template_doc,
    proposal_doc,
)
from catalyst_python.catalyst_id import RoleID


# ------------------- #
# Signed Docs Factory #
# ------------------- #


def publish_document(doc: CatalystSignedDocument, token: str):
    resp = document.put(data=doc.hex_cbor(), token=token)
    assert resp.status_code == 201, (
        f"Failed to publish document: {resp.status_code} - {resp.text}"
    )


@pytest.fixture(scope="session")
def proposal_doc_factory(admin_key, rbac_chain_factory):
    brand_template = brand_parameters_form_template_doc(
        content=json.dumps({"type": "object"}),
        sk=admin_key.key.sk_hex,
        kid=admin_key.cat_id(),
        id=None,
    )
    publish_document(brand_template, admin_key.auth_token())

    brand = brand_parameters_doc(
        content=json.dumps({}),
        template=brand_template,
        sk=admin_key.key.sk_hex,
        kid=admin_key.cat_id(),
        id=None,
    )
    publish_document(brand, admin_key.auth_token())

    campaign_template = campaign_parameters_form_template_doc(
        content=json.dumps({"type": "object"}),
        parameters=brand,
        sk=admin_key.key.sk_hex,
        kid=admin_key.cat_id(),
        id=None,
    )
    publish_document(campaign_template, admin_key.auth_token())

    campaign = campaign_parameters_doc(
        content=json.dumps({}),
        template=campaign_template,
        parameters=brand,
        sk=admin_key.key.sk_hex,
        kid=admin_key.cat_id(),
        id=None,
    )
    publish_document(campaign, admin_key.auth_token())

    category_template = category_parameters_form_template_doc(
        content=json.dumps({"type": "object"}),
        parameters=campaign,
        sk=admin_key.key.sk_hex,
        kid=admin_key.cat_id(),
        id=None,
    )
    publish_document(category_template, admin_key.auth_token())

    category = category_parameters_doc(
        content=json.dumps({}),
        template=category_template,
        parameters=campaign,
        sk=admin_key.key.sk_hex,
        kid=admin_key.cat_id(),
        id=None,
    )
    publish_document(category, admin_key.auth_token())

    rbac_chain = rbac_chain_factory()

    def proposal_doc_factory(
        proposal_template_content: dict | None = None,
    ) -> CatalystSignedDocument:
        if proposal_template_content == None:
            with open(
                "./test_data/signed_docs/proposal_form_template.json", "r"
            ) as json_file:
                proposal_template_content = json.load(json_file)

        proposal_template = proposal_form_template_doc(
            content=json.dumps(proposal_template_content),
            parameters=category,
            sk=admin_key.key.sk_hex,
            kid=admin_key.cat_id(),
            id=None,
        )
        publish_document(proposal_template, admin_key.auth_token())

        with open("./test_data/signed_docs/proposal.json", "r") as json_file:
            proposal_content = json.load(json_file)
        (cat_id, key) = rbac_chain.cat_id_for_role(RoleID.PROPOSER)
        doc = proposal_doc(
            content=json.dumps(proposal_content),
            template=proposal_template,
            parameters=category,
            sk=key,
            kid=cat_id,
            id=None,
        )
        publish_document(doc, rbac_chain.auth_token())
        return doc

    return proposal_doc_factory
