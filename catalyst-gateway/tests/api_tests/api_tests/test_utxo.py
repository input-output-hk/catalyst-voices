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
import math


def printable_time(time: float):
    return f"{math.floor(time / 3600):02}:{math.floor((time % 3600) / 60):02}:{math.floor(time % 60):02}"


# Wait until service will sync to the provided slot number
def sync_to(network: str, slot_num: int, timeout: int):
    start_time = time.time()
    true_start = time.time()
    last_slot_num = -1

    logger.info(
        f"{'synced to slot' : ^16} : "
        + f"{'in total time' : ^16} : "
        + f"{'slots/sec (interval)' : ^20} : "
        + f"{'slots remaining' : ^16} : "
        + f"{'est. time to go' : ^16} :"
    )

    while True:
        # Get current sync state
        sync_state = get_sync_state(network=network)
        if last_slot_num == -1:
            first_slot_num = sync_state["slot_number"]

        # If we reached our target sync state, then continue the test
        if sync_state != None and sync_state["slot_number"] >= slot_num:
            logger.info(f"cat-gateway synced to target slot {slot_num}: {sync_state}")
            break

        # If the sync state changed since last time, reset the timeout and log the new sync state
        if last_slot_num != sync_state["slot_number"]:
            slots_last_interval = (sync_state["slot_number"] - last_slot_num) + 1
            last_interval = time.time() - start_time
            sps_last_interval = slots_last_interval / max(last_interval, 1.0)

            last_slot_num = sync_state["slot_number"]
            start_time = time.time()

            total_time = start_time - true_start
            total_slots = (last_slot_num - first_slot_num) + 1
            slots_per_second = total_slots / max(total_time, 0.001)

            residual_sync_slots = max(slot_num - last_slot_num, 0)
            estimated_time_remaining = residual_sync_slots / slots_per_second

            # Total slots/second and in the last interval
            sps = f"{slots_per_second:.2f}({sps_last_interval:.2f})"

            logger.info(
                f"{last_slot_num : >16} : "
                + f"{printable_time(total_time) : >16} : "
                + f"{sps : >20} : "
                + f"{residual_sync_slots : >16} : "
                + f"{printable_time(estimated_time_remaining) : >16} :"
            )

        # If sync state does not update for timeout seconds, then fail the test
        if start_time + timeout <= time.time():
            logger.info(
                f"cat-gateway failed to sync to target slot {slot_num}. Exited on timeout."
            )
            assert False

        # Sleep for 1/3 of our timeout before updating sync state again.
        time.sleep(timeout / 3)


def test_staked_ada_endpoint():
    check_is_live()
    check_is_ready()

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
