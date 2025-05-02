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
    def __init__(self, keys_map: dict, network: str, subnet: str):
        # corresponded to different roles bip32 extended ed25519 keys map
        self.keys_map = keys_map
        self.network = network
        self.subnet = subnet

    def auth_token(self, cid: str = None, sig: str = None, username: str = None, is_uri: bool = False, nonce: str = None) -> str:
        role_0_keys = self.keys_map[f"{RoleID.ROLE_0}"]
        return generate_rbac_auth_token(
            self.network, self.subnet, role_0_keys["pk"], role_0_keys["sk"], cid, sig, username, is_uri, nonce
        )

    # returns a role's catalyst id, with the provided role secret key
    def cat_id_for_role(self, role_id: RoleID) -> (str, str):
        role_data = self.keys_map[f"{role_id}"]
        role_0_pk = self.keys_map[f"{RoleID.ROLE_0}"]["pk"]
        return (
            generate_cat_id(
                network=self.network,
                subnet=self.subnet,
                role_id=role_id,
                pk_hex=role_0_pk,
                rotation=role_data["rotation"],
                is_uri=True,
            ),
            role_data["sk"],
        )    
    
    def short_cat_id(self) -> str:
        return generate_cat_id(
            network=self.network,
            subnet=self.subnet,
            role_id=RoleID.ROLE_0,
            pk_hex=self.keys_map[f"{RoleID.ROLE_0}"]["pk"],
            rotation=0,
            is_uri=False,
            is_short=True
        )

@pytest.fixture
def rbac_chain_factory():
    def __rbac_chain_factory(role_id: RoleID, network: str = "cardano", subnet: str = "preprod") -> RBACChain:
        match role_id:
            # RBAC registration chain that contains only Role 0 (voter)
            case RoleID.ROLE_0:
                return RBACChain(ONLY_ROLE_0_REG_JSON, network, subnet)
            # RBAC registration chain that contains both Role 0 -> Role 3 (proposer)
            case RoleID.PROPOSER:
                return RBACChain(ROLE_3_REG_JSON, network, subnet)

    return __rbac_chain_factory


def generate_cat_id(
    network: str, subnet: str, role_id: RoleID, pk_hex: str, rotation: int, is_uri: bool, is_short: bool = False, nonce: str = None
):
    pk = bytes.fromhex(pk_hex)[:32]
    if nonce is None:
        nonce = f"{int(datetime.now(timezone.utc).timestamp())}"
    subnet = f"{subnet}." if subnet else ""
    role0_pk_b64 = base64_url(pk)

    if is_short:
        res = f"{subnet}{network}/{role0_pk_b64}"
    else:
        res = f":{nonce}@{subnet}{network}/{role0_pk_b64}"
        if not (role_id == RoleID.ROLE_0 and rotation == 0):
            res += f"/{role_id}/{rotation}"
        if is_uri:
            res = f"id.catalyst://{res}"
            
    return res


def generate_rbac_auth_token(
    network: str,
    subnet: str,
    pk_hex: str,
    sk_hex: str,
    cid: str = None,
    sig: str = None,
    username: str = None,
    is_uri: bool = False,
    nonce: str = None,
) -> str:
    pk = bytes.fromhex(pk_hex)[:32]
    sk = bytes.fromhex(sk_hex)[:64]
    chain_code = bytes.fromhex(sk_hex)[64:]

    bip32_ed25519_sk = BIP32ED25519PrivateKey(sk, chain_code)
    bip32_ed25519_pk = BIP32ED25519PublicKey(pk, chain_code)

    token_prefix = f"catid.{username}" if username else "catid."
    if cid is None:
        cat_id = f"{token_prefix}{generate_cat_id(
            network=network, 
            subnet=subnet, 
            role_id=RoleID.ROLE_0,
            pk_hex=pk_hex, 
            rotation=0, 
            is_uri=is_uri,
            nonce=nonce)}."
    else:
        cat_id = f"{token_prefix}:{cid}."

    if sig is None:
        signature = bip32_ed25519_sk.sign(cat_id.encode())
        bip32_ed25519_pk.verify(signature, cat_id.encode())
    else:
        signature = sig.encode()
    
    signature_b64 = base64_url(signature)

    return f"{cat_id}{signature_b64}"


def base64_url(data: bytes) -> str:
    # URL safety and no padding base 64
    return base64.urlsafe_b64encode(data).decode().rstrip("=")
