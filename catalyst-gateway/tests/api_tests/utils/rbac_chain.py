import pytest
from enum import Enum
import json

from catalyst_python.rbac_chain import RBACChain

with open("./test_data/rbac_regs/only_role_0.jsonc", "r") as f:
    ONLY_ROLE_0_REG_JSON = json.load(f)
with open("./test_data/rbac_regs/role_3.jsonc", "r") as f:
    ROLE_3_REG_JSON = json.load(f)


class Chain(Enum):
    All = 0
    Role0 = 1
    Role0_With_Proposer = 2


@pytest.fixture(scope="session")
def rbac_chain_factory():
    def __rbac_chain_factory(
        chain: Chain = Chain.All,
        network: str = "cardano",
        subnet: str = "preprod",
    ) -> RBACChain:
        match chain:
            # RBAC registration chain that contains only Role 0 (voter)
            case Chain.Role0:
                return RBACChain(ONLY_ROLE_0_REG_JSON, network, subnet)
            # RBAC registration chain that contains both Role 0 -> Role 3 (proposer)
            case Chain.Role0_With_Proposer:
                return RBACChain(ROLE_3_REG_JSON, network, subnet)
            # RBAC registration chain that contains all known roles
            case Chain.All:
                return RBACChain(ROLE_3_REG_JSON, network, subnet)

    return __rbac_chain_factory
