import pytest
import json
from utils.rbac_chain import rbac_chain_factory
from utils.admin import admin_key
from tempfile import NamedTemporaryFile

from catalyst_python.api.v1 import document
from catalyst_python.catalyst_id import RoleID
from catalyst_python.signed_doc import (
    SignedDocument,
    brand_parameters_form_template_doc,
    brand_parameters_doc,
    campaign_parameters_form_template_doc,
    campaign_parameters_doc,
    category_parameters_form_template_doc,
    category_parameters_doc,
    proposal_form_template_doc,
    proposal_doc,
)


# ------------------- #
# Signed Docs Factory #
# ------------------- #


@pytest.fixture(scope="session")
def proposal_doc_factory(admin_key, rbac_chain_factory):
    brand_template = brand_parameters_form_template_doc({"type": "object"}, admin_key)
    brand = brand_parameters_doc({}, brand_template, admin_key)
    campaign_template = campaign_parameters_form_template_doc(
        {"type": "object"}, brand, admin_key
    )
    campaign = campaign_parameters_doc({}, campaign_template, brand, admin_key)
    category_template = category_parameters_form_template_doc(
        {"type": "object"}, campaign, admin_key
    )
    category = category_parameters_doc({}, category_template, campaign, admin_key)

    with open("./test_data/signed_docs/proposal_form_template.json", "r") as json_file:
        proposal_template_content = json.load(json_file)
    proposal_template = proposal_form_template_doc(
        proposal_template_content, category, admin_key
    )

    rbac_chain = rbac_chain_factory()

    def proposal_doc_factory() -> SignedDocument:
        with open("./test_data/signed_docs/proposal.json", "r") as json_file:
            proposal_content = json.load(json_file)
        return proposal_doc(proposal_content, proposal_template, category, rbac_chain)

    return proposal_doc_factory
