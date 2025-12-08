import pytest
import os
from catalyst_python.ed25519 import Ed25519Keys
from catalyst_python.admin import AdminKey


@pytest.fixture(scope="session")
def admin_key(
    network: str = "cardano",
    subnet: str = "preprod",
) -> AdminKey:
    key = Ed25519Keys(os.environ["CAT_GATEWAY_ADMIN_PRIVATE_KEY"])
    return AdminKey(key=key, network=network, subnet=subnet)
