import pytest
import os
from utils.ed25519 import Ed25519Keys, Ed25519Type
from utils.rbac_chain import (
    generate_rbac_auth_token,
    generate_cat_id,
)


class AdminKey:
    def __init__(self, key: Ed25519Keys):
        self.key = key

    def cat_id(self) -> str:
        return generate_cat_id(
            network="cardano",
            subnet="preprod",
            role_0_key=self.key,
            scheme="admin.catalyst",
        )

    def auth_token(self) -> str:
        return generate_rbac_auth_token(
            network="cardano",
            subnet="preprod",
            role_0_key=self.key,
            signing_key=self.key,
        )


@pytest.fixture(scope='session')
def admin_key() -> AdminKey:
    key = Ed25519Keys(os.environ["CAT_GATEWAY_ADMIN_PRIVATE_KEY"], Ed25519Type.Regular)
    return AdminKey(key)
