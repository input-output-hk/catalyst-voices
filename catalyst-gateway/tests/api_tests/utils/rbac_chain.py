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

    # returns a role's catalyst id, with the provided role secret key
    def cat_id_for_role(self, role_id: RoleID) -> (str, str):
        role_data = self.keys_map[f"{role_id}"]
        role_0_pk = self.keys_map[f"{RoleID.ROLE_0}"]["pk"]
        return (
            generate_cat_id(
                "cardano",
                self.network,
                role_id,
                role_0_pk,
                role_data["rotation"],
                True,
            ),
            role_data["sk"],
        )


@pytest.fixture
def rbac_chain_factory():
    def __rbac_chain_factory(role_id: RoleID) -> RBACChain:
        network = "preprod"
        match role_id:
            # RBAC registration chain that contains only Role 0 (voter)
            case RoleID.ROLE_0:
                return RBACChain(ONLY_ROLE_0_REG_JSON, network)
            # RBAC registration chain that contains both Role 0 -> Role 3 (proposer)
            case RoleID.PROPOSER:
                return RBACChain(ROLE_3_REG_JSON, network)

    return __rbac_chain_factory


def generate_cat_id(
    network: str, subnet: str, role_id: RoleID, pk_hex: str, rotation: int, is_uri: bool
):
    pk = bytes.fromhex(pk_hex)[:32]
    nonce = int(datetime.now(timezone.utc).timestamp())
    subnet = f"{subnet}." if subnet else ""
    role0_pk_b64 = base64_url(pk)

    if role_id == RoleID.ROLE_0 and rotation == 0:
        res = f"{nonce}@{subnet}{network}/{role0_pk_b64}"
    else:
        res = f"{nonce}@{subnet}{network}/{role0_pk_b64}/{role_id}/{rotation}"

    if is_uri:
        res = f"id.catalyst://{res}"

    return res


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

    token_prefix = "catid.:"
    cat_id = generate_cat_id(network, subnet, RoleID.ROLE_0, pk_hex, 0, False)

    signature = bip32_ed25519_sk.sign(cat_id.encode())
    bip32_ed25519_pk.verify(signature, cat_id.encode())
    signature_b64 = base64_url(signature)

    return f"{token_prefix}{cat_id}.{signature_b64}"


def base64_url(data: bytes) -> str:
    # URL safety and no padding base 64
    return base64.urlsafe_b64encode(data).decode().rstrip("=")
