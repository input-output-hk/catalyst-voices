import json
from loguru import logger
import pytest
import requests
from utils import health, address, sync
from api import cat_gateway_endpoint_url

@pytest.mark.skip('To be refactored when the api is ready')
def test_staked_ada_endpoint():
    health.is_live()
    health.is_ready()

    network = "preprod"
    slot_num = 56364174

    # block hash `871b1e4af4c2d433618992fb1c1b5c1182ab829a236d58a4fcc82faf785b58cd`
    # 60 second timeout (3 block times iof syncing from tip)
    sync.sync_to(network=network, slot_num=slot_num, timeout=60)

    snapshot_tool_data = json.load(open("./snapshot_tool-56364174.json"))
    for entry in snapshot_tool_data:
        expected_amount = entry["voting_power"]
        stake_address = address.stake_public_key_to_address(
            key=entry["stake_public_key"][2:], is_stake=True, network_type=network
        )
        res = get_staked_ada(stake_address, network=network, slot_number=slot_num)
        logger.info(f"checking stake address: {stake_address}")
        # it is possible that snapshot tool collected data for the stake key which does not have any unspent utxo
        # at this case cat-gateway return 404, that is why we are checking this case additionally
        assert (res != None and res["amount"] == expected_amount) or (
            expected_amount == 0
        )

def get_staked_ada(address: str, network: str, slot_number: int):
    resp = requests.get(
        cat_gateway_endpoint_url(
            f"api/cardano/staked_ada/{address}?network={network}&slot_number={slot_number}"
        )
    )
    assert resp.status_code == 200 or resp.status_code == 404
    if resp.status_code == 200:
        return resp.json()
