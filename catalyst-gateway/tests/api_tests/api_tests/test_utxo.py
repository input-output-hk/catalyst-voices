import json
from loguru import logger
import pytest

from utils import health

from api_tests import (
    get_staked_ada,
    sync_to,
    utils,
)

@pytest.mark.skip
def test_staked_ada_endpoint():
    health.is_live()
    health.is_ready()

    network = "preprod"
    slot_num = 56364174

    # block hash `871b1e4af4c2d433618992fb1c1b5c1182ab829a236d58a4fcc82faf785b58cd`
    # 60 second timeout (3 block times iof syncing from tip)
    sync_to(network=network, slot_num=slot_num, timeout=60)

    snapshot_tool_data = json.load(open("./snapshot_tool-56364174.json"))
    for entry in snapshot_tool_data:
        expected_amount = entry["voting_power"]
        stake_address = utils.stake_public_key_to_address(
            key=entry["stake_public_key"][2:], is_stake=True, network_type=network
        )
        res = get_staked_ada(stake_address, network=network, slot_number=slot_num)
        logger.info(f"checking stake address: {stake_address}")
        # it is possible that snapshot tool collected data for the stake key which does not have any unspent utxo
        # at this case cat-gateway return 404, that is why we are checking this case additionally
        assert (res != None and res["amount"] == expected_amount) or (
            expected_amount == 0
        )
