import os
import subprocess
import json
from tempfile import NamedTemporaryFile

from catalyst_python.catalyst_id import RoleID
from catalyst_python.uuid import uuid_v7
from catalyst_python.signed_doc import SignedDocumentBuilder
from catalyst_python.ed25519 import Ed25519Keys


class SignedDocumentV1Builder(SignedDocumentBuilder):
    # Build and sign document, returns hex str of document bytes
    def build_and_sign(
        self,
    ) -> str:
        with (
            NamedTemporaryFile() as metadata_file,
            NamedTemporaryFile() as doc_content_file,
            NamedTemporaryFile() as signed_doc_file,
        ):
            mk_signed_doc_path = os.environ["DEP_MK_SIGNED_DOC_PATH"]
            json_str = json.dumps(self.metadata)
            metadata_file.write(json_str.encode(encoding="utf-8"))
            metadata_file.flush()

            json_str = json.dumps(self.content)
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
                    self.key.sk_hex,
                    self.cat_id,
                ],
                capture_output=True,
            )

            signed_doc_hex = signed_doc_file.read().hex()
            return signed_doc_hex


# ------------------- #
# Signed Docs Factory #
# ------------------- #


def proposal(rbac_chain):
    role_id = RoleID.PROPOSER
    proposal_doc_id = uuid_v7()
    proposal_metadata_json = {
        "id": proposal_doc_id,
        "ver": proposal_doc_id,
        # Proposal document type
        "type": "7808d2ba-d511-40af-84e8-c0d1625fdfdc",
        "content-type": "application/json",
        "content-encoding": "br",
        # Fund 14 proposal template, defined in `V3__signed_documents.sql`
        "template": {
            "id": "0194d492-1daa-75b5-b4a4-5cf331cd8d1a",
            "ver": "0194d492-1daa-75b5-b4a4-5cf331cd8d1a",
        },
        # Fund 14 category, defined in `V3__signed_documents.sql`
        "parameters": {
            "id": "0194d490-30bf-7473-81c8-a0eaef369619",
            "ver": "0194d490-30bf-7473-81c8-a0eaef369619",
        },
    }
    with open("./test_data/signed_docs/proposal.deprecated.json", "r") as json_file:
        content = json.load(json_file)

    (cat_id, sk_hex) = rbac_chain.cat_id_for_role(role_id)
    doc = SignedDocumentV1Builder(proposal_metadata_json, content, cat_id, sk_hex)
    return (doc.build_and_sign(), proposal_doc_id)


def comment(rbac_chain, proposal_id):
    role_id = RoleID.ROLE_0
    comment_doc_id = uuid_v7()
    comment_metadata_json = {
        "id": comment_doc_id,
        "ver": comment_doc_id,
        # Comment document type
        "type": "b679ded3-0e7c-41ba-89f8-da62a17898ea",
        "content-type": "application/json",
        "content-encoding": "br",
        "ref": {
            "id": proposal_id,
            "ver": proposal_id,
        },
        # Fund 14 comment template, defined in `V3__signed_documents.sql`
        "template": {
            "id": "0194d494-4402-7e0e-b8d6-171f8fea18b0",
            "ver": "0194d494-4402-7e0e-b8d6-171f8fea18b0",
        },
    }
    with open("./test_data/signed_docs/comment.deprecated.json", "r") as json_file:
        content = json.load(json_file)

    (cat_id, sk_hex) = rbac_chain.cat_id_for_role(role_id)
    doc = SignedDocumentV1Builder(comment_metadata_json, content, cat_id, sk_hex)
    return (doc.build_and_sign(), comment_doc_id)


def proposal_submission(rbac_chain, proposal_id):
    role_id = RoleID.PROPOSER
    submission_action_id = uuid_v7()
    sub_action_metadata_json = {
        "id": submission_action_id,
        "ver": submission_action_id,
        # submission action type
        "type": "5e60e623-ad02-4a1b-a1ac-406db978ee48",
        "content-type": "application/json",
        "content-encoding": "br",
        "ref": {
            "id": proposal_id,
            "ver": proposal_id,
        },
    }
    with open(
        "./test_data/signed_docs/submission_action.deprecated.json", "r"
    ) as json_file:
        content = json.load(json_file)

    (cat_id, sk_hex) = rbac_chain.cat_id_for_role(role_id)
    doc = SignedDocumentV1Builder(sub_action_metadata_json, content, cat_id, sk_hex)
    return (
        doc.build_and_sign(),
        submission_action_id,
    )
