from datetime import datetime, timezone
import base64
import pytest
from enum import Enum
from pycardano.crypto.bip32 import BIP32ED25519PrivateKey, BIP32ED25519PublicKey


class RoleID(Enum):
    ROLE_0 = 0
    PROPOSER = 3


class RBACToken:
    def __init__(self, cat_id: str, signature_b64: str, sk_hex: bytes):
        self.cat_id = cat_id
        self.signature_b64 = signature_b64
        # corresponding to the role_0 public key bip32 extended ed25519 secret key
        self.sk_hex = sk_hex

    def __str__(self) -> str:
        return f"{self.cat_id}.{self.signature_b64}"


@pytest.fixture
def rbac_auth_token_factory():

    def __rbac_auth_token_factory(role_id: RoleID, network: str) -> RBACToken:
        match role_id:
            case RoleID.ROLE_0:
                # https://preprod.cexplorer.io/tx/5fd71fb559d3ebf16bb0b8b30028a1d0fbbb3a983dbbe2e92eb87f851c6d205c
                sk_hex = "a8f84dd9576f9b5224da38146df1dd4c80c6aa767cb71540bd86294f62cced568ecdf07352e0b48e1ae66370352e56aba4113461ec08e13b2fed10ecc056c65fd2a76829a3b53e66af79bb0cb1efade075f0ae65eaaabb75f5106bbeef59b866"
                pk_hex = "42149f1a6f1da43fcf066a473e12515b5b6216fedfc52b87bee091456981d9c6d2a76829a3b53e66af79bb0cb1efade075f0ae65eaaabb75f5106bbeef59b866"
            case RoleID.PROPOSER:
                # https://preprod.cexplorer.io/tx/5fd71fb559d3ebf16bb0b8b30028a1d0fbbb3a983dbbe2e92eb87f851c6d205c
                sk_hex = "a8f84dd9576f9b5224da38146df1dd4c80c6aa767cb71540bd86294f62cced568ecdf07352e0b48e1ae66370352e56aba4113461ec08e13b2fed10ecc056c65fd2a76829a3b53e66af79bb0cb1efade075f0ae65eaaabb75f5106bbeef59b866"
                pk_hex = "42149f1a6f1da43fcf066a473e12515b5b6216fedfc52b87bee091456981d9c6d2a76829a3b53e66af79bb0cb1efade075f0ae65eaaabb75f5106bbeef59b866"

        return generate_rbac_auth_token("cardano", network, pk_hex, sk_hex)

    return __rbac_auth_token_factory


def generate_rbac_auth_token(
    network: str,
    subnet: str,
    pk_hex: str,
    sk_hex: str,
) -> RBACToken:
    pk = bytes.fromhex(pk_hex)[:32]
    sk = bytes.fromhex(sk_hex)[:64]
    chain_code = bytes.fromhex(sk_hex)[64:]

    bip32_ed25519_sk = BIP32ED25519PrivateKey(sk, chain_code)
    bip32_ed25519_pk = BIP32ED25519PublicKey(pk, chain_code)

    prefix = "catid.:"
    nonce = int(datetime.now(timezone.utc).timestamp())
    subnet = f"{subnet}." if subnet else ""
    role0_pk_b64 = base64_url(pk)
    catid_without_sig = f"{prefix}{nonce}@{subnet}{network}/{role0_pk_b64}"

    signature = bip32_ed25519_sk.sign(catid_without_sig.encode())
    bip32_ed25519_pk.verify(signature, catid_without_sig.encode())
    signature_b64 = base64_url(signature)

    return RBACToken(catid_without_sig, signature_b64, sk_hex)


def base64_url(data: bytes) -> str:
    # URL safety and no padding base 64
    return base64.urlsafe_b64encode(data).decode().rstrip("=")
