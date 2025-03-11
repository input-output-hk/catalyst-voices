import pytest
from utils.address import stake_public_key_to_address
from utils.snapshot import snapshot
from api.v1 import cardano


def check_delegations(provided, expected):
    if type(expected) is list:
        provided_delegations = provided["delegations"]
        for i in range(0, len(expected)):
            expected_voting_key = expected[i][0]
            expected_power = expected[i][1]
            provided_voting_key = provided_delegations[i]["voting_key"]
            provided_power = provided_delegations[i]["power"]
            assert (
                expected_voting_key == provided_voting_key
                and expected_power == provided_power
            )
    else:
        assert provided["voting_key"] == expected


# @pytest.mark.skip('To be refactored when the api is ready')
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
