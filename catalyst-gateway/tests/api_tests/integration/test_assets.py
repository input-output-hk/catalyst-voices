import pytest
from utils.address import stake_public_key_to_address
from utils.snapshot import snapshot
from api.v1 import cardano


@pytest.mark.skip("To be refactored when the api is ready")
def test_persistent_ada_amount_endpoint(snapshot):
    # health.is_live()
    # health.is_ready()

    for entry in snapshot.data:
        expected_amount = entry["voting_power"]
        stake_address = stake_public_key_to_address(
            key=entry["stake_public_key"][2:],
            is_stake=True,
            network_type=snapshot.network,
        )
        resp = cardano.assets(stake_address, snapshot.slot_no, snapshot.network)
        if expected_amount == 0 and resp.status_code == 404:
            # it is possible that snapshot tool collected data for the stake key which does not have any unspent utxo
            # at this case cat-gateway return 404, that is why we are checking this case additionally
            return

        assert (
            resp.status_code == 200
        ), f"Cannot find assets for stake_address: {stake_address}"
        assets = resp.json()
        assert (
            assets["persistent"]["ada_amount"] == expected_amount
        ), f"Not expected ada amount for stake_address: {stake_address}"
