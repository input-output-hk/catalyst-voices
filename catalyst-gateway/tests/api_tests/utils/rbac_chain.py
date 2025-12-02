import pytest
from enum import IntEnum, Enum
import json
from catalyst_python.ed25519 import Ed25519Keys
from catalyst_python.catalyst_id import generate_cat_id, RoleID
from catalyst_python.rbac_token import generate_rbac_auth_token

with open("./test_data/rbac_regs/only_role_0.jsonc", "r") as f:
    ONLY_ROLE_0_REG_JSON = json.load(f)
with open("./test_data/rbac_regs/role_3.jsonc", "r") as f:
    ROLE_3_REG_JSON = json.load(f)


class Chain(Enum):
    All = 0
    Role0 = 1
    Role0_With_Proposer = 2


class RBACChain:
    def __init__(self, keys_map: dict, network: str, subnet: str):
        # corresponded to different roles bip32 extended ed25519 keys map
        self.keys_map = keys_map
        self.network = network
        self.subnet = subnet

    def auth_token(
        self,
        scheme: str | None = None,
        sig: str | None = None,
        username: str | None = None,
        nonce: str | None = None,
        cat_id: str | None = None,
    ) -> str:
        role_0_arr = self.keys_map[f"{RoleID.ROLE_0}"]
        role_0_key = Ed25519Keys(role_0_arr[0]["sk"])
        return generate_rbac_auth_token(
            scheme=scheme,
            network=self.network,
            subnet=self.subnet,
            role_0_key=role_0_key,
            signing_key=role_0_key,
            sig=sig,
            username=username,
            nonce=nonce,
            cat_id=cat_id,
        )

    # returns a role's catalyst id, with the provided latest role key
    def cat_id_for_role(self, role_id: RoleID) -> tuple[str, Ed25519Keys]:
        role_data_arr = self.keys_map[f"{role_id}"]
        role_0_arr = self.keys_map[f"{RoleID.ROLE_0}"]

        role_0_key = Ed25519Keys(role_0_arr[0]["sk"])
        role_latest_key = Ed25519Keys(role_data_arr[-1]["sk"])

        return (
            generate_cat_id(
                network=self.network,
                subnet=self.subnet,
                role_id=role_id,
                role_0_key=role_0_key,
                rotation=role_data_arr[-1]["rotation"],
                scheme="id.catalyst",
            ),
            role_latest_key,
        )

    def short_cat_id(self) -> str:
        role_0_arr = self.keys_map[f"{RoleID.ROLE_0}"]
        role_0_key = Ed25519Keys(role_0_arr[0]["sk"])
        return generate_cat_id(
            network=self.network,
            subnet=self.subnet,
            role_0_key=role_0_key,
        )


@pytest.fixture(scope='session')
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
