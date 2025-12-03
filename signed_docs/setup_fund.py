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
    brand_parameters_form_template_doc,
    brand_parameters_doc,
    campaign_parameters_form_template_doc,
    campaign_parameters_doc,
    category_parameters_form_template_doc,
    category_parameters_doc,
    proposal_form_template_doc,
    proposal_doc,
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

    print(f"Loaded {filepath}:\n{json_f}")
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
            errmsg = f"failed to send HTTP request: {e}"
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

    brand_template = brand_parameters_form_template_doc(
        read_json_file(env_dir, "brand_parameters_form_template.json"),
        admin,
    )
    publish_document(
        url=url,
        timeout=timeout,
        retry=retry,
        doc=brand_template,
        token=admin.auth_token(),
    )

    brand = brand_parameters_doc(
        read_json_file(env_dir, "brand_parameters_form_template.json"),
        brand_template,
        admin,
    )
    publish_document(
        url=url, timeout=timeout, retry=retry, doc=brand, token=admin.auth_token()
    )

    campaign_template = campaign_parameters_form_template_doc(
        read_json_file(env_dir, "campaign_parameters_form_template.json"),
        brand,
        admin,
    )
    publish_document(
        url=url,
        timeout=timeout,
        retry=retry,
        doc=campaign_template,
        token=admin.auth_token(),
    )

    campaign = campaign_parameters_doc(
        read_json_file(env_dir, "campaign_parameters.json"),
        campaign_template,
        brand,
        admin,
    )
    publish_document(
        url=url,
        timeout=timeout,
        retry=retry,
        doc=campaign,
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
