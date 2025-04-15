from tempfile import NamedTemporaryFile
import subprocess
import json
from typing import Dict, Any


def build_signed_doc(
    metadata_json: Dict[str, Any],
    doc_content_json: Dict[str, Any],
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
                "./mk_signed_doc",
                "build",
                doc_content_file.name,
                signed_doc_file.name,
                metadata_file.name,
            ],
        )

        # subprocess.run(
        #     [
        #         "./mk_signed_doc",
        #         "sign",
        #         signed_doc_file.name,
        #         rbac_token.sk_hex,
        #         rbac_token.cat_id,
        #     ]
        # )

        signed_doc_hex = signed_doc_file.read().hex()
        return signed_doc_hex
