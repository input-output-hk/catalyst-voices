import pytest
from pycardano.crypto.bip32 import BIP32ED25519PrivateKey, BIP32ED25519PublicKey
from rbac_chain import (
    generate_rbac_auth_token,
    ONLY_ROLE_0_REG_JSON,
    RoleID,
    generate_cat_id,
)


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

    def cat_id(self) -> str:
        return generate_cat_id(
            network="cardano",
            subnet="preprod",
            pk_hex=self.pk_hex(),
            scheme="admin.catalyst",
        )

    def auth_token(self) -> str:
        return generate_rbac_auth_token(
            network="cardano",
            subnet="preprod",
            pk_hex=self.pk_hex(),
            sk_hex=self.sk_hex,
        )


@pytest.fixture(scope='session')
def admin_key() -> AdminKey:
    return AdminKey(ONLY_ROLE_0_REG_JSON[f"{RoleID.ROLE_0}"][0]["sk"])
