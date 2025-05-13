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

    def auth_token(
        self,
        cid: str = None,
        sig: str = None,
        username: str = None,
        is_uri: bool = False,
        nonce: str = None,
    ) -> str:
        role_0_arr = self.keys_map[f"{RoleID.ROLE_0}"]
        return generate_rbac_auth_token(
            self.network,
            self.subnet,
            role_0_arr[0]["pk"],
            role_0_arr[-1]["sk"],
            cid,
            sig,
            username,
            is_uri,
            nonce,
        )

    # returns a role's catalyst id, with the provided role secret key
    def cat_id_for_role(self, role_id: RoleID) -> tuple[str, str]:
        role_data_arr = self.keys_map[f"{role_id}"]
        role_0_arr = self.keys_map[f"{RoleID.ROLE_0}"]
        return (
            generate_cat_id(
                network=self.network,
                subnet=self.subnet,
                role_id=role_id,
                pk_hex=role_0_arr[0]["pk"],
                rotation=role_data_arr[-1]["rotation"],
                is_uri=True,
            ),
            role_data_arr[-1]["sk"],
        )

    def short_cat_id(self) -> str:
        return generate_cat_id(
            network=self.network,
            subnet=self.subnet,
            pk_hex=self.keys_map[f"{RoleID.ROLE_0}"][0]["pk"],
            is_uri=False,
        )


@pytest.fixture
def rbac_chain_factory():
    # if `registered_roles` default value is all rbac chain with all available roles
    def __rbac_chain_factory(
        roles: list[RoleID] = [RoleID.ROLE_0, RoleID.PROPOSER],
        network: str = "cardano",
        subnet: str = "preprod",
    ) -> RBACChain:
        if isinstance(roles, RoleID):
            roles = [roles]
        else:
            roles = sorted(set(roles))
            
        match roles:
            # RBAC registration chain that contains only Role 0 (voter)
            case [RoleID.ROLE_0]:
                return RBACChain(ONLY_ROLE_0_REG_JSON, network, subnet)
            # RBAC registration chain that contains both Role 0 -> Role 3 (proposer)
            case [RoleID.ROLE_0, RoleID.PROPOSER]:
                return RBACChain(ROLE_3_REG_JSON, network, subnet)
            case _:
                assert (
                    False
                ), f"Does not have a registration with the following roles {roles}"

    return __rbac_chain_factory


# Default is set to URI format
# Optional field = subnet, role id, rotation, username, nonce
def generate_cat_id(
    network: str,
    pk_hex: str,
    is_uri: bool = True,
    subnet: str = None,
    role_id: str = None,
    rotation: str = None,
    username: str = None,
    nonce: str = None,
) -> str:
    pk = bytes.fromhex(pk_hex)[:32]
    role0_pk_b64 = base64_url(pk)

    # If nonce is set to none, use current timestamp
    # If set to empty string, use empty string (no nonce)
    if nonce is None:
        nonce = f"{int(datetime.now(timezone.utc).timestamp())}"

    # Authority part
    authority = ""
    if username:
        authority += f"{username}"
    if nonce:
        authority += f":{nonce}"
    authority += "@"

    if subnet:
        authority += f"{subnet}.{network}"
    else:
        authority += network

    # Path
    path = f"{role0_pk_b64}"
    if role_id:
        path += f"/{role_id}"
        if rotation:
            path += f"/{rotation}"

    if is_uri:
        return f"id.catalyst://{authority}/{path}"
    else:
        return f"{authority}/{path}"


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
            pk_hex=pk_hex, 
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
