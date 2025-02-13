import json
from loguru import logger
import pytest
from utils import health,address
from api_tests import cat_gateway_endpoint_url
from utils import sync
import requests

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

@pytest.mark.skip('To be refactored when the api is ready')
def test_voter_registration_endpoint():
    health.is_live()
    health.is_ready()

    network = "preprod"
    slot_num = 56364174

    # block hash `871b1e4af4c2d433618992fb1c1b5c1182ab829a236d58a4fcc82faf785b58cd`
    # 60 second timeout (3 block times iof syncing from tip)
    sync.sync_to(network=network, slot_num=slot_num, timeout=60)

    snapshot_tool_data = json.load(open("./snapshot_tool-56364174.json"))
    for entry in snapshot_tool_data:
        expected_rewards_address = entry["rewards_address"]
        expected_nonce = entry["nonce"]
        stake_address = address.stake_public_key_to_address(
            key=entry["stake_public_key"][2:], is_stake=True, network_type=network
        )
        res = get_voter_registration(
            stake_address, network=network, slot_number=slot_num
        )
        logger.info(f"checking stake address: {stake_address}")
        # it is possible that snapshot tool collected data for the stake key which does not have any unspent utxo
        # at this case cat-gateway return 404, that is why we are checking this case additionally
        logger.info(f"curent: {res}, expected: {entry}")
        assert (
            res["rewards_address"] == expected_rewards_address
            and res["nonce"] == expected_nonce
        )
        check_delegations(res["voting_info"], entry["delegations"])

def get_voter_registration(address: str, network: str, slot_number: int):
    resp = requests.get(
        cat_gateway_endpoint_url(
            f"api/cardano/registration/{address}?network={network}&slot_number={slot_number}"
        )
    )
    assert resp.status_code == 200 or resp.status_code == 404
    if resp.status_code == 200:
        return resp.json()
