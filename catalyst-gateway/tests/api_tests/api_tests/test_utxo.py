import time
from loguru import logger
from api_tests import check_is_live, check_is_ready, get_sync_state


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

    # block hash `8f9fe36879d00042779f85cffa5ba3fa9a1c6c04556d592c934ecc85cd693ef3`
    sync_to(network=network, slot_num=133642, timeout=30)
