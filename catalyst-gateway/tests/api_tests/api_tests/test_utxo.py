import time
import json
from loguru import logger
import requests
from api_tests import (
    check_is_live,
    check_is_ready,
    get_sync_state,
    get_staked_ada,
    utils,
)


# Wait until service will sync to the provided slot number
def sync_to(network: str, slot_num: int, timeout: int):
    start_time = time.time()
    while True:
        if start_time + timeout < time.time():
            logger.info(
                f"cat-gateway doesn't synced to slot_num: {slot_num}. Exited on timeout."
            )
            assert False

        sync_state = get_sync_state(network=network)
        if sync_state != None and sync_state["slot_number"] >= slot_num:
            logger.info(f"cat-gateway synced to: {sync_state}")
            break
        time.sleep(5)


def test_staked_ada_endpoint():
    check_is_live()
    check_is_ready()

    network = "preprod"
    slot_num = 56364174

    # block hash `871b1e4af4c2d433618992fb1c1b5c1182ab829a236d58a4fcc82faf785b58cd`
    # 6 hours timeout
    sync_to(network=network, slot_num=slot_num, timeout=60 * 60 * 6)

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
