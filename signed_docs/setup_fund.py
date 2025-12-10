import argparse
import os
import requests
import time
import json
from pathlib import Path

from catalyst_python.admin import AdminKey
from catalyst_python.ed25519 import Ed25519Keys
from catalyst_python.signed_doc import (
    SignedDocument,
    DocumentRef,
    brand_parameters_form_template_doc,
    brand_parameters_doc,
    campaign_parameters_form_template_doc,
    campaign_parameters_doc,
    category_parameters_form_template_doc,
    category_parameters_doc,
    proposal_form_template_doc,
    proposal_comment_form_template_doc,
)


def load_json_file(filepath: str) -> dict[str, str]:
    """Read a JSON file from the specified path and return the parsed content."""
    with Path(filepath).open("r") as f:
        return json.load(f)


def read_json_file(env_dir: Path, file_name: str) -> dict[str, str]:
    filepath = Path(env_dir) / file_name
    assert Path.is_file(filepath), f"Missing {file_name} at {filepath}"

    with Path(filepath).open("r") as f:
        json_f = json.load(f)

    print(f"Loaded {filepath}")
    return json_f


def read_admin_key(admin_key_env: str, network: str) -> AdminKey:
    key = Ed25519Keys(os.environ[admin_key_env])
    if network == "mainnet":
        network = None
    return AdminKey(key=key, network="cardano", subnet=network)


def publish_document(
    url: str, timeout: int, retry: bool, doc: SignedDocument, token: str
):
    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/cbor"}
    data = bytes.fromhex(doc.build_and_sign())

    while True:
        try:
            resp = requests.put(url, timeout=timeout, headers=headers, data=data)
            resp.raise_for_status()
            break
        except requests.exceptions.RequestException as e:
            errmsg = f"failed to send HTTP request: {e}, resp: {resp.text}"
            print(errmsg)

            if retry:
                print("Retrying in 1 minute...")
                time.sleep(60)
            else:
                break


def setup_fund(env: str, retry: bool):
    """Read config files from the specified `env`, then apply the configs."""
    file_dir = Path(__file__).resolve().parent
    env_dir = Path(file_dir) / env

    print(f"Setting config for environment: {env}")
    print(f"Looking for configs in: {env_dir}")

    settings = read_json_file(env_dir, "settings.json")
    admin = read_admin_key(settings["admin_private_key_env"], settings["network"])

    url = settings["url"]
    timeout = settings["timeout"]

    docs_to_publish = []

    brand_parameters_form_template_settings = settings["brand"][
        "parameters_form_template"
    ]
    brand_parameters_form_template = brand_parameters_form_template_doc(
        content=read_json_file(
            env_dir, brand_parameters_form_template_settings["path"]
        ),
        admin_key=admin,
    )
    docs_to_publish.append(brand_parameters_form_template)

    brand_parameters_settings = settings["brand"]["parameters"]
    brand_parameters = brand_parameters_doc(
        content=read_json_file(env_dir, brand_parameters_settings["path"]),
        brand_parameters_form_template_ref=brand_parameters_form_template.doc_ref(),
        admin_key=admin,
    )
    docs_to_publish.append(brand_parameters)

    for campaign in settings["brand"]["campaigns"]:
        campaign_parameters_form_template_settings = campaign[
            "parameters_form_template"
        ]
        campaign_parameters_form_template = campaign_parameters_form_template_doc(
            content=read_json_file(
                env_dir, campaign_parameters_form_template_settings["path"]
            ),
            param_ref=brand_parameters.doc_ref(),
            admin_key=admin,
        )
        docs_to_publish.append(campaign_parameters_form_template)

        campaign_parameters_settings = campaign["parameters"]
        campaign_parameters = campaign_parameters_doc(
            content=read_json_file(env_dir, campaign_parameters_settings["path"]),
            campaign_parameters_form_template_doc=campaign_parameters_form_template.doc_ref(),
            param_ref=brand_parameters.doc_ref(),
            admin_key=admin,
        )
        docs_to_publish.append(campaign_parameters)

        for category in campaign["categories"]:
            category_parameters_form_template_settings = category[
                "parameters_form_template"
            ]
            category_parameters_form_template = category_parameters_form_template_doc(
                content=read_json_file(
                    env_dir, category_parameters_form_template_settings["path"]
                ),
                param_ref=campaign_parameters.doc_ref(),
                admin_key=admin,
            )
            docs_to_publish.append(category_parameters_form_template)

            category_parameters_settings = category["parameters"]
            category_parameters = category_parameters_doc(
                content=read_json_file(env_dir, category_parameters_settings["path"]),
                category_parameters_form_template_doc=category_parameters_form_template.doc_ref(),
                param_ref=campaign_parameters.doc_ref(),
                admin_key=admin,
            )
            docs_to_publish.append(category_parameters)

            proposal_form_template_settings = category["proposal_form_template"]
            proposal_form_template = proposal_form_template_doc(
                content=read_json_file(
                    env_dir, proposal_form_template_settings["path"]
                ),
                param_ref=category_parameters.doc_ref(),
                admin_key=admin,
            )
            docs_to_publish.append(proposal_form_template)

            proposal_comment_form_template_settings = category[
                "proposal_comment_form_template"
            ]
            proposal_comment_form_template = proposal_comment_form_template_doc(
                content=read_json_file(
                    env_dir, proposal_comment_form_template_settings["path"]
                ),
                param_ref=category_parameters.doc_ref(),
                admin_key=admin,
            )
            docs_to_publish.append(proposal_comment_form_template)

    for doc in docs_to_publish:
        publish_document(
            url=url,
            timeout=timeout,
            retry=retry,
            doc=doc,
            token=admin.auth_token(),
        )


parser = argparse.ArgumentParser(description="Catalyst Signed Document importer.")
parser.add_argument(
    "--retry",
    action="store_true",
    help="If submiting fails, wait 1 minute and retry indefinitely until successful.",
)
parser.add_argument(
    "env",
    type=str,
    help="The environment to configure (e.g., dev, qa, preprod, prod).",
)

args = parser.parse_args()

setup_fund(args.env, args.retry)

print(f"Finished setup Fund.")
