import argparse
import os

from catalyst_python.admin import AdminKey
from catalyst_python.ed25519 import Ed25519Keys
from catalyst_python.signed_doc import (
    brand_parameters_form_template_doc,
    brand_parameters_doc,
    campaign_parameters_form_template_doc,
    campaign_parameters_doc,
    category_parameters_form_template_doc,
    category_parameters_doc,
    proposal_form_template_doc,
    proposal_doc,
)


def load_admin_key() -> AdminKey:
    key = Ed25519Keys(os.environ["CAT_GATEWAY_ADMIN_PRIVATE_KEY"])
    return AdminKey(key=key, network="cardano", subnet="preprod")


def publish_fund_documents(admin: AdminKey):
    brand_template = brand_parameters_form_template_doc({"type": "object"}, admin)
    brand = brand_parameters_doc({}, brand_template, admin)
    campaign_template = campaign_parameters_form_template_doc(
        {"type": "object"}, brand, admin
    )


parser = argparse.ArgumentParser(description="Catalyst Signed Document importer.")


args = parser.parse_args()


print(f"Finished setup Fund.")
