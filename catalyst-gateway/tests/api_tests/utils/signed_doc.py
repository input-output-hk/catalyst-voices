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


DOC_TYPE = {
    "brand_parameters": "3e4808cc-c86e-467b-9702-d60baa9d1fca",
    "brand_parameters_form_template": "fd3c1735-80b1-4eea-8d63-5f436d97ea31",
    "campaign_parameters": "0110ea96-a555-47ce-8408-36efe6ed6f7c",
    "campaign_parameters_form_template": "7e8f5fa2-44ce-49c8-bfd5-02af42c179a3",
    "category_parameters": "48c20109-362a-4d32-9bba-e0a9cf8b45be",
    "category_parameters_form_template": "65b1e8b0-51f1-46a5-9970-72cdf26884be",
    "comment_moderation_action": "84a4b502-3b7e-47fd-84e4-6fee08794bd7",
    "contest_delegation": "764f17fb-cc50-4979-b14a-b213dbac5994",
    "contest_parameters": "788ff4c6-d65a-451f-bb33-575fe056b411",
    "contest_parameters_form_template": "08a1e16d-354d-4f64-8812-4692924b113b",
    "presentation_template": "cb99b9bd-681a-49d8-9836-89107c02e8ef",
    "proposal": "7808d2ba-d511-40af-84e8-c0d1625fdfdc",
    "proposal_comment": "b679ded3-0e7c-41ba-89f8-da62a17898ea",
    "proposal_comment_form_template": "0b8424d4-ebfd-46e3-9577-1775a69d290c",
    "proposal_form_template": "0ce8ab38-9258-4fbc-a62e-7faa6e58318f",
    "proposal_moderation_action": "a552451a-8e5b-409d-83a0-21eac26bbf8c",
    "proposal_submission_action": "5e60e623-ad02-4a1b-a1ac-406db978ee48",
    "rep_nomination": "bf9abd97-5d1f-4429-8e80-740fea371a9c",
    "rep_nomination_form_template": "431561a5-9c2b-4de1-8e0d-78eb4887e35d",
    "rep_profile": "0f2c86a2-ffda-40b0-ad38-23709e1c10b3",
    "rep_profile_form_template": "564cbea3-44d3-4303-b75a-d9fdda7e5a80",
}


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


# return a Proposal document which is already published to the cat-gateway and the corresponding RoleID
@pytest.fixture
def proposal_doc_factory(rbac_chain_factory):
    def __factory__(template_id: str) -> tuple[SignedDocument, RoleID]:
        role_id = RoleID.PROPOSER
        rbac_chain = rbac_chain_factory()
        doc_id = uuid_v7.uuid_v7()
        metadata = {
            "id": doc_id,
            "ver": doc_id,
            # Proposal document type
            "type": DOC_TYPE["proposal"],
            "content-type": "application/json",
            "content-encoding": "br",
            "parameters": [
                {"id": template_id, "ver": template_id, "cid": "0x"},
            ],
        }
        # TODO: auto generate body from the given schema
        body = {}

        doc_builder = SignedDocument(metadata, body)
        (cat_id, sk_hex) = rbac_chain.cat_id_for_role(role_id)
        
        resp = document.put(
            data=doc_builder.build_and_sign(cat_id, sk_hex),
            token=rbac_chain.auth_token(),
        )
        assert (
            resp.status_code == 201
        ), f"Failed to publish document: {resp.status_code} - {resp.text}"

        return doc_builder, role_id

    return __factory__


@pytest.fixture
def proposal_form_template_doc_factory(rbac_chain_factory):
    def __factory__() -> tuple[SignedDocument, RoleID]:
        role_id = RoleID.PROPOSER
        with open("./test_data/signed_docs/proposal_form_template.json", "r") as json_file:
            metadata, content = json.load(json_file)

        doc_builder = SignedDocument(metadata, content)
        rbac_chain = rbac_chain_factory()
        (cat_id, sk_hex) = rbac_chain.cat_id_for_role(role_id)
        
        resp = document.put(
            data=doc_builder.build_and_sign(cat_id, sk_hex),
            token=rbac_chain.auth_token(),
        )
        assert (
            resp.status_code == 201
        ), f"Failed to publish document: {resp.status_code} - {resp.text}"

        return doc_builder, role_id

    return __factory__


@pytest.fixture
def category_parameters_doc_factory(rbac_chain_factory):
    def __factory__() -> tuple[SignedDocument, RoleID]:
        with open("./test_data/signed_docs/category_parameters.json", "r") as json_file:
            metadata, content = json.load(json_file)

        doc_builder = SignedDocument(metadata, content)
        rbac_chain = rbac_chain_factory()
        (cat_id, sk_hex) = rbac_chain.cat_id_for_role(RoleID.PROPOSER)
        
        resp = document.put(
            data=doc_builder.build_and_sign(cat_id, sk_hex),
            token=rbac_chain.auth_token(),
        )
        assert (
            resp.status_code == 201
        ), f"Failed to publish document: {resp.status_code} - {resp.text}"

        return doc_builder, RoleID.PROPOSER

    return __factory__


@pytest.fixture
def category_parameters_form_template_doc_factory(rbac_chain_factory):
    def __factory__() -> tuple[SignedDocument, RoleID]:
        role_id = RoleID.PROPOSER
        rbac_chain = rbac_chain_factory()
        doc_id = uuid_v7.uuid_v7()
        metadata = {
            "id": doc_id,
            "ver": doc_id,
            "type": DOC_TYPE["category_parameters_form_template"],
            "content-type": "application/json",
            "content-encoding": "br",
        }
        with open("./test_data/signed_docs/category_parameters_form_template.json", "r") as json_file:
            content = json.load(json_file)

        doc_builder = SignedDocument(metadata, content)
        (cat_id, sk_hex) = rbac_chain.cat_id_for_role(role_id)
        
        resp = document.put(
            data=doc_builder.build_and_sign(cat_id, sk_hex),
            token=rbac_chain.auth_token(),
        )
        assert (
            resp.status_code == 201
        ), f"Failed to publish document: {resp.status_code} - {resp.text}"

        return doc_builder, role_id

    return __factory__


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
