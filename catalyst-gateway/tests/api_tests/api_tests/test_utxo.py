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

    network = "mainnet"

    # block hash `68dcf12857a6a0bbdbb0ce1db982814a88fc585c1d50b216568196cb49b8ecee`
    sync_to(network=network, slot_num=67173, timeout=300)
