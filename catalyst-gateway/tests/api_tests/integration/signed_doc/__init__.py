from utils import signed_doc
from typing import Dict, Any
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
