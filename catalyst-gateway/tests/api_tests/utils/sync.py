import requests
import time
from loguru import logger
import math
from api import cat_gateway_endpoint_url

def get_sync_state(network: str):
    resp = requests.get(
        cat_gateway_endpoint_url(f"api/cardano/sync_state?network={network}")
    )
    assert resp.status_code == 200 or resp.status_code == 404
    if resp.status_code == 200:
        return resp.json()

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

        if sync_state != None:
            if last_slot_num == -1:
                first_slot_num = sync_state["slot_number"]

            # If we reached our target sync state, then continue the test
            if sync_state["slot_number"] >= slot_num:
                logger.info(
                    f"cat-gateway synced to target slot {slot_num}: {sync_state}"
                )
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
