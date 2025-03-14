import pytest
from utils.address import stake_public_key_to_address
from utils.snapshot import snapshot
from api.v1 import cardano


@pytest.mark.skip("To be refactored when the api is ready")
def test_cip36_registration_endpoint(snapshot):
    # health.is_live()
    # health.is_ready()

    for entry in snapshot.data:
        stake_public_key = entry["stake_public_key"]
        stake_address = stake_public_key_to_address(
            key=stake_public_key[2:],
            is_stake=True,
            network_type=snapshot.network,
        )

        voting_key = (
            entry["delegations"][0][0]
            if type(entry["delegations"]) is list
            else entry["delegations"]
        )
        # skipping invalid voting keys which are not 32 bytes long
        if len(voting_key) != 66:
            continue
        resp = cardano.cip36_registration(stake_address, snapshot.slot_no, 1)
        assert (
            resp.status_code == 200
        ), f"Cannot get cip36 registration for stake address {stake_address}"
