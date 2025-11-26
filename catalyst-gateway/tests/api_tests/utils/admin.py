import pytest
import base64
from pycardano.crypto.bip32 import BIP32ED25519PrivateKey, BIP32ED25519PublicKey
from utils.rbac_chain import generate_rbac_auth_token, ONLY_ROLE_0_REG_JSON, RoleID


class AdminKey:
    def __init__(self, sk_hex: str):
        self.sk_hex = sk_hex

        sk = bytes.fromhex(sk_hex)[:64]
        chain_code = bytes.fromhex(sk_hex)[64:]

        self.sk = BIP32ED25519PrivateKey(sk, chain_code)

    def pk(self) -> BIP32ED25519PublicKey:
        return BIP32ED25519PublicKey.from_private_key(self.sk)

    def pk_hex(self) -> str:
        return self.pk().public_key.hex()

    def pk_base64url(self) -> str:
        return (
            base64.urlsafe_b64encode(self.pk().public_key).rstrip(b"=").decode("ascii")
        )

    def cat_id(self) -> str:
        return f"admin.catalyst://preprod.cardano/{self.pk_base64url()}/0/10"

    def auth_token(self) -> str:
        return generate_rbac_auth_token(
            network="cardano",
            subnet="preprod",
            pk_hex=self.pk_hex(),
            sk_hex=self.sk_hex,
        )


@pytest.fixture
def admin_key() -> AdminKey:
    return AdminKey(ONLY_ROLE_0_REG_JSON[f"{RoleID.ROLE_0}"][0]["sk"])
