import json
from loguru import logger
import requests
from api_tests import (
    check_is_live,
    check_is_ready,
    get_sync_state,
    get_staked_ada,
    sync_to,
    utils,
)


def test_staked_ada_endpoint():
    check_is_live()
    check_is_ready()

    network = "preprod"
    slot_num = 56364174

    # block hash `871b1e4af4c2d433618992fb1c1b5c1182ab829a236d58a4fcc82faf785b58cd`
    # 60 second timeout (3 block times iof syncing from tip)
    sync_to(network=network, slot_num=slot_num, timeout=60)
