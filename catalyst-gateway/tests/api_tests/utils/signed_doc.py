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
from utils.admin import AdminKey, admin_key
from tempfile import NamedTemporaryFile
from jsf import JSF
from enum import IntEnum


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


class DocBuilderReturns:
    def __init__(
        self,
        doc_builder: SignedDocument,
        signed_doc: str,
        auth_token: str,
        cat_id: str,
        role_id: RoleID,
    ):
        self.doc_builder = doc_builder
        self.signed_doc = signed_doc
        self.auth_token = auth_token
        self.cat_id = cat_id
        self.role_id = role_id


def create_metadata(
    doc_type: str,
    content_type: str,
    templates: list[Any] | None = None,
    parameters: list[Any] | None = None,
) -> dict[str, Any]:
    doc_id = uuid_v7.uuid_v7()

    metadata: dict[str, Any] = {
        "content-encoding": "br",
        "content-type": content_type,
        "id": doc_id,
        "ver": doc_id,
        "type": doc_type,
    }

    if templates is not None:
        metadata["templates"] = templates
    if parameters is not None:
        metadata["parameters"] = parameters

    return metadata


def build_signed_doc(
    metadata_json: Dict[str, Any],
    doc_content_json: Dict[str, Any],
    bip32_sk_hex: str,
    # corresponded to the `bip32_sk_hex` `cat_id` string
    cat_id: str,
    mk_signed_doc_path,
) -> str:
    with (
        NamedTemporaryFile() as metadata_file,
        NamedTemporaryFile() as doc_content_file,
        NamedTemporaryFile() as signed_doc_file,
    ):
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


# ------------------- #
# Signed Docs Factory #
# ------------------- #


class ParameterType(IntEnum):
    CATEGORY = 0
    CAMPAIGN = 1
    BRAND = 2


# return a Proposal document which is already published to the cat-gateway and the corresponding RoleID
@pytest.fixture
def proposal_doc_factory(
    rbac_chain_factory,
    proposal_form_template_doc_factory,
    category_parameters_doc,
    campaign_parameters_doc,
    brand_parameters_doc,
):
    def __factory__(
        parameter_type: ParameterType,
        role_id: RoleID
    ) -> SignedDocument:
        param: SignedDocumentBase
        if parameter_type == ParameterType.CATEGORY:
            param = category_parameters_doc
        elif parameter_type == ParameterType.CAMPAIGN:
            param = campaign_parameters_doc
        elif parameter_type == ParameterType.BRAND:
            param = brand_parameters_doc
        else:
            raise Exception("Invalid parameter type for proposal document")

        template: SignedDocumentBase = proposal_form_template_doc_factory(
            parameter_type
        )

        metadata = create_metadata(
            doc_type=DOC_TYPE["proposal"],
            templates=[
                {
                    "id": template.metadata["id"],
                    "ver": template.metadata["ver"],
                    "cid": "0x",
                }
            ],
        )
        content = JSF(template.content).generate()

        rbac_chain = rbac_chain_factory()
        doc = SignedDocument(metadata, content)
        (cat_id, sk_hex) = rbac_chain.cat_id_for_role(role_id)

        resp = document.put(
            data=doc.build_and_sign(cat_id, sk_hex),
            token=rbac_chain.auth_token(),
        )
        assert resp.status_code == 201, (
            f"Failed to publish document: {resp.status_code} - {resp.text}"
        )

        return doc

    return __factory__


@pytest.fixture
def proposal_form_template_doc_factory(
    admin_key,
    category_parameters_doc,
    campaign_parameters_doc,
    brand_parameters_doc,
):
    def __factory__(parameter_type: ParameterType):
        param: SignedDocumentBase
        if parameter_type == ParameterType.CATEGORY:
            param = category_parameters_doc
        elif parameter_type == ParameterType.CAMPAIGN:
            param = campaign_parameters_doc
        elif parameter_type == ParameterType.BRAND:
            param = brand_parameters_doc
        else:
            raise Exception(
                "Invalid parameter type for proposal form template document"
            )

        tmp_metadata = create_metadata(
            doc_type=DOC_TYPE["proposal_form_template"],
            content_type="application/schema+json",
            parameters=[
                {"id": param.metadata["id"], "ver": param.metadata["ver"], "cid": "0x"},
            ],
        )

        with open(
            "./test_data/signed_docs/proposal_form_template.json", "r"
        ) as json_file:
            metadata, content = json.load(json_file)

        metadata["id"] = tmp_metadata["id"]
        metadata["ver"] = tmp_metadata["ver"]
        metadata["parameters"] = tmp_metadata["parameters"]

        doc = SignedDocument(metadata, content)

        resp = document.put(
            data=doc.build_and_sign(admin_key.cat_id(), admin_key.sk_hex),
            token=admin_key.auth_token(),
        )
        assert resp.status_code == 201, (
            f"Failed to publish document: {resp.status_code} - {resp.text}"
        )

        return doc

    return __factory__


@pytest.fixture
def category_parameters_doc(
    admin_key,
    category_parameters_form_template_doc,
    campaign_parameters_doc,
) -> SignedDocumentBase:
    template: SignedDocumentBase = category_parameters_form_template_doc
    param: SignedDocumentBase = campaign_parameters_doc

    metadata = create_metadata(
        doc_type=DOC_TYPE["category_parameters"],
        content_type="application/json",
        templates=[
            {
                "id": template.metadata["id"],
                "ver": template.metadata["ver"],
                "cid": "0x",
            }
        ],
        parameters=[
            {"id": param.metadata["id"], "ver": param.metadata["ver"], "cid": "0x"},
        ],
    )
    content = JSF(template.content).generate()
    doc = SignedDocument(metadata, content)

    resp = document.put(
        data=doc.build_and_sign(admin_key.cat_id(), admin_key.sk_hex),
        token=admin_key.auth_token(),
    )
    assert resp.status_code == 201, (
        f"Failed to publish document: {resp.status_code} - {resp.text}"
    )

    return doc


@pytest.fixture
def category_parameters_form_template_doc(
    admin_key,
    campaign_parameters_doc
) -> SignedDocumentBase:
    param: SignedDocumentBase = campaign_parameters_doc

    metadata = create_metadata(
        doc_type=DOC_TYPE["category_parameters_form_template"],
        content_type="application/schema+json",
        parameters=[{"id": param.metadata["id"], "ver": param.metadata["ver"], "cid": "0x"}],
    )
    content = {"type": "object"}
    doc = SignedDocument(metadata, content)

    resp = document.put(
        data=doc.build_and_sign(admin_key.cat_id(), admin_key.sk_hex),
        token=admin_key.auth_token(),
    )
    assert resp.status_code == 201, (
        f"Failed to publish document: {resp.status_code} - {resp.text}"
    )

    return doc


@pytest.fixture
def campaign_parameters_doc(
    admin_key,
    campaign_parameters_form_template_doc,
    brand_parameters_doc,
) -> SignedDocumentBase:
    template: SignedDocumentBase = campaign_parameters_form_template_doc
    param: SignedDocumentBase = brand_parameters_doc

    metadata = create_metadata(
        doc_type=DOC_TYPE["campaign_parameters"],
        content_type="application/json",
        parameters=[
            {
                "id": template.metadata["id"],
                "ver": template.metadata["ver"],
                "cid": "0x",
            }
        ],
        templates=[
            {"id": param.metadata["id"], "ver": param.metadata["ver"], "cid": "0x"},
        ],
    )
    content = JSF(template.content).generate()
    doc = SignedDocument(metadata, content)

    resp = document.put(
        data=doc.build_and_sign(admin_key.cat_id(), admin_key.sk_hex),
        token=admin_key.auth_token(),
    )
    assert resp.status_code == 201, (
        f"Failed to publish document: {resp.status_code} - {resp.text}"
    )

    return doc


@pytest.fixture
def campaign_parameters_form_template_doc(
    admin_key,
    brand_parameters_doc
) -> SignedDocumentBase:
    param: SignedDocumentBase = brand_parameters_doc

    metadata = create_metadata(
        doc_type=DOC_TYPE["campaign_parameters_form_template"],
        content_type="application/schema+json",
        templates=[{"id": param.metadata["id"], "ver": param.metadata["ver"], "cid": "0x"}],
    )
    content = {"type": "object"}
    doc = SignedDocument(metadata, content)

    resp = document.put(
        data=doc.build_and_sign(admin_key.cat_id(), admin_key.sk_hex),
        token=admin_key.auth_token(),
    )
    assert resp.status_code == 201, (
        f"Failed to publish document: {resp.status_code} - {resp.text}"
    )

    return doc


@pytest.fixture
def brand_parameters_doc(
    admin_key,
    brand_parameters_form_template_doc
) -> SignedDocumentBase:
    template: SignedDocumentBase = brand_parameters_form_template_doc

    metadata = create_metadata(
        doc_type=DOC_TYPE["brand_parameters"],
        content_type="application/json",
        templates=[
            {
                "id": template.metadata["id"],
                "ver": template.metadata["ver"],
                "cid": "0x",
            }
        ],
    )
    content = JSF(template.content).generate()
    doc = SignedDocument(metadata, content)

    resp = document.put(
        data=doc.build_and_sign(admin_key.cat_id(), admin_key.sk_hex),
        token=admin_key.auth_token(),
    )
    assert resp.status_code == 201, (
        f"Failed to publish document: {resp.status_code} - {resp.text}"
    )

    return doc


@pytest.fixture
def brand_parameters_form_template_doc(
    admin_key
) -> SignedDocumentBase:
    metadata = create_metadata(
        doc_type=DOC_TYPE["brand_parameters_form_template"],
        content_type="application/schema+json"
    )
    content = {"type": "object"}
    doc = SignedDocument(metadata, content)

    resp = document.put(
        data=doc.build_and_sign(admin_key.cat_id(), admin_key.sk_hex),
        token=admin_key.auth_token(),
    )
    assert resp.status_code == 201, (
        f"Failed to publish document: {resp.status_code} - {resp.text}"
    )

    return doc
