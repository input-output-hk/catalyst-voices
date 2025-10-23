import pytest
from typing import Dict, Any
import copy
import os
import time
import subprocess
import json
from api.v1 import document
from utils import signed_doc, uuid_v7
from utils.rbac_chain import rbac_chain_factory, RoleID
from tempfile import NamedTemporaryFile


class SignedDocumentBase:
    def __init__(self, metadata: Dict[str, Any], content: Dict[str, Any]):
        self.metadata = metadata
        self.content = content

    def new_version(self):
        time.sleep(1)
        self.metadata["ver"] = uuid_v7.uuid_v7()

    def copy(self):
        new_copy = SignedDocument(
            metadata=copy.deepcopy(self.metadata),
            content=copy.deepcopy(self.content),
        )
        return new_copy


class SignedDocumentV1(SignedDocumentBase):
    # Build and sign document, returns hex str of document bytes
    def build_and_sign(
        self,
        cat_id: str,
        bip32_sk_hex: str,
    ) -> str:
        return signed_doc.build_signed_doc(
            self.metadata,
            self.content,
            bip32_sk_hex,
            cat_id,
            os.environ["DEP_MK_SIGNED_DOC_PATH"],
        )


class SignedDocument(SignedDocumentBase):
    # Build and sign document, returns hex str of document bytes
    def build_and_sign(
        self,
        cat_id: str,
        bip32_sk_hex: str,
    ) -> str:
        return signed_doc.build_signed_doc(
            self.metadata,
            self.content,
            bip32_sk_hex,
            cat_id,
            os.environ["MK_SIGNED_DOC_PATH"],
        )


BRAND_ID = "0199e71b-401e-7160-9139-a398c4d7b8fa"
PROPOSAL_FORM_TEMPLATE_ID = "0199e71b-4025-7323-bc4a-d39e35762521"


# return a Proposal document which is already published to the cat-gateway and the corresponding RoleID
@pytest.fixture
def proposal_doc_factory(rbac_chain_factory):
    def __proposal_doc_factory() -> tuple[SignedDocument, RoleID]:
        role_id = RoleID.PROPOSER
        rbac_chain = rbac_chain_factory()
        proposal_doc_id = uuid_v7.uuid_v7()
        proposal_metadata_json = {
            "id": proposal_doc_id,
            "ver": proposal_doc_id,
            # Proposal document type
            "type": "7808d2ba-d511-40af-84e8-c0d1625fdfdc",
            "content-type": "application/json",
            "content-encoding": "br",
            # referenced to the defined proposal template id, comes from the 'templates/data.rs' file
            "template": [
                {
                    "id": PROPOSAL_FORM_TEMPLATE_ID,
                    "ver": PROPOSAL_FORM_TEMPLATE_ID,
                    "cid": "0x",
                }
            ],
            # referenced to the defined category id, comes from the 'templates/data.rs' file
            "parameters": [{"id": BRAND_ID, "ver": BRAND_ID, "cid": "0x"}],
        }
        with open("./test_data/signed_docs/proposal.json", "r") as proposal_json_file:
            proposal_json = json.load(proposal_json_file)

        doc = SignedDocument(proposal_metadata_json, proposal_json)
        (cat_id, sk_hex) = rbac_chain.cat_id_for_role(role_id)
        resp = document.put(
            data=doc.build_and_sign(cat_id, sk_hex),
            token=rbac_chain.auth_token(),
        )
        assert (
            resp.status_code == 201
        ), f"Failed to publish document: {resp.status_code} - {resp.text}"

        return doc, role_id

    return __proposal_doc_factory


def build_signed_doc(
    metadata_json: Dict[str, Any],
    doc_content_json: Dict[str, Any],
    bip32_sk_hex: str,
    # corresponded to the `bip32_sk_hex` `cat_id` string
    cat_id: str,
    mk_signed_doc_path,
) -> str:
    with NamedTemporaryFile() as metadata_file, NamedTemporaryFile() as doc_content_file, NamedTemporaryFile() as signed_doc_file:

        json_str = json.dumps(metadata_json)
        metadata_file.write(json_str.encode(encoding="utf-8"))
        metadata_file.flush()

        json_str = json.dumps(doc_content_json)
        doc_content_file.write(json_str.encode(encoding="utf-8"))
        doc_content_file.flush()

        subprocess.run(
            [
                mk_signed_doc_path,
                "build",
                doc_content_file.name,
                signed_doc_file.name,
                metadata_file.name,
            ],
            capture_output=True,
        )

        subprocess.run(
            [
                mk_signed_doc_path,
                "sign",
                signed_doc_file.name,
                bip32_sk_hex,
                cat_id,
            ],
            capture_output=True,
        )

        signed_doc_hex = signed_doc_file.read().hex()
        return signed_doc_hex
