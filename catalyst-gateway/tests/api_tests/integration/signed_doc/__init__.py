import pytest
from utils import signed_doc
from typing import Dict, Any, List
import copy
import os


class SignedDocument:
    def __init__(self, metadata: Dict[str, Any], content: Dict[str, Any]):
        self.metadata = metadata
        self.content = content

    def copy(self):
        new_copy = SignedDocument(
            metadata=copy.deepcopy(self.metadata),
            content=copy.deepcopy(self.content),
        )
        return new_copy

    # Build and sign document, returns hex str of document bytes
    def build_and_sign(
        self,
        cat_id: str,
        bip32_sk_hex: str,
        is_deprecated: bool = False,
    ) -> str:
        if not is_deprecated:
            mk_signed_doc_path = os.environ["MK_SIGNED_DOC_PATH"]
        else:
            mk_signed_doc_path = os.environ["DEP_MK_SIGNED_DOC_PATH"]

        return signed_doc.build_signed_doc(
            self.metadata, self.content, bip32_sk_hex, cat_id, mk_signed_doc_path
        )


@pytest.fixture
def proposal_templates() -> List[str]:
    # comes from the 'templates/data.rs' file
    return [
        "0194d492-1daa-75b5-b4a4-5cf331cd8d1a",
        "0194d492-1daa-7371-8bd3-c15811b2b063",
        "0194d492-1daa-79c7-a222-2c3b581443a8",
        "0194d492-1daa-716f-a04e-f422f08a99dc",
        "0194d492-1daa-78fc-818a-bf20fc3e9b87",
        "0194d492-1daa-7d98-a3aa-c57d99121f78",
        "0194d492-1daa-77be-a1a5-c238fe25fe4f",
        "0194d492-1daa-7254-a512-30a4cdecfb90",
        "0194d492-1daa-7de9-b535-1a0b0474ed4e",
        "0194d492-1daa-7fce-84ee-b872a4661075",
        "0194d492-1daa-7878-9bcc-2c79fef0fc13",
        "0194d492-1daa-722f-94f4-687f2c068a5d",
    ]


@pytest.fixture
def comment_templates() -> List[str]:
    # comes from the 'templates/data.rs' file
    return [
        "0194d494-4402-7e0e-b8d6-171f8fea18b0",
        "0194d494-4402-7444-9058-9030815eb029",
        "0194d494-4402-7351-b4f7-24938dc2c12e",
        "0194d494-4402-79ad-93ba-4d7a0b65d563",
        "0194d494-4402-7cee-a5a6-5739839b3b8a",
        "0194d494-4402-7aee-8b24-b5300c976846",
        "0194d494-4402-7d75-be7f-1c4f3471a53c",
        "0194d494-4402-7a2c-8971-1b4c255c826d",
        "0194d494-4402-7074-86ac-3efd097ba9b0",
        "0194d494-4402-7202-8ebb-8c4c47c286d8",
        "0194d494-4402-7fb5-b680-c23fe4beb088",
        "0194d494-4402-7aa5-9dbc-5fe886e60ebc",
    ]
