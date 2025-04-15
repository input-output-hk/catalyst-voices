from datetime import datetime, timezone
import base64
import pytest
from enum import IntEnum
import json
from pycardano.crypto.bip32 import BIP32ED25519PrivateKey, BIP32ED25519PublicKey

with open("./test_data/rbac_regs/only_role_0.jsonc", "r") as f:
    ONLY_ROLE_0_REG_JSON = json.load(f)
with open("./test_data/rbac_regs/role_3.jsonc", "r") as f:
    ROLE_3_REG_JSON = json.load(f)


class RoleID(IntEnum):
    ROLE_0 = 0
    PROPOSER = 3

    def __str__(self):
        return f"{int(self)}"


class RBACChain:
    def __init__(self, keys_map: dict, network: str):
        # corresponded to different roles bip32 extended ed25519 keys map
        self.keys_map = keys_map
        self.network = network

    def auth_token(self) -> str:
        role_0_keys = self.keys_map[f"{RoleID.ROLE_0}"]
        return generate_rbac_auth_token(
            "cardano", self.network, role_0_keys["pk"], role_0_keys["sk"]
        )


@pytest.fixture
def rbac_chain_factory():
    def __rbac_chain_factory(role_id: RoleID) -> RBACChain:
        network = "preprod"
        match role_id:
            case RoleID.ROLE_0:
                return RBACChain(ONLY_ROLE_0_REG_JSON, network)
            case RoleID.PROPOSER:
                return RBACChain(ROLE_3_REG_JSON, network)

    return __rbac_chain_factory


def generate_rbac_auth_token(
    network: str,
    subnet: str,
    pk_hex: str,
    sk_hex: str,
) -> str:
    pk = bytes.fromhex(pk_hex)[:32]
    sk = bytes.fromhex(sk_hex)[:64]
    chain_code = bytes.fromhex(sk_hex)[64:]

    bip32_ed25519_sk = BIP32ED25519PrivateKey(sk, chain_code)
    bip32_ed25519_pk = BIP32ED25519PublicKey(pk, chain_code)

    prefix = "catid.:"
    nonce = int(datetime.now(timezone.utc).timestamp())
    subnet = f"{subnet}." if subnet else ""
    role0_pk_b64 = base64_url(pk)
    cat_id = f"{prefix}{nonce}@{subnet}{network}/{role0_pk_b64}/0"

    signature = bip32_ed25519_sk.sign(cat_id.encode())
    bip32_ed25519_pk.verify(signature, cat_id.encode())
    signature_b64 = base64_url(signature)

    return f"{cat_id}.{signature_b64}"


def base64_url(data: bytes) -> str:
    # URL safety and no padding base 64
    return base64.urlsafe_b64encode(data).decode().rstrip("=")
