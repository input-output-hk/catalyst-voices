import json
from loguru import logger
import requests
from api_tests import (
    check_is_live,
    check_is_ready,
    sync_to,
    get_date_time_to_slot_number,
)
from datetime import datetime, timezone


def test_date_time_to_slot_number_endpoint():
    check_is_live()
    check_is_ready()

    network = "preprod"
    slot_num = 16010056

    # block hash `65b13e1227c36a3327fb1333ae801d15c50c7f5af66919d467befce8d67a4284`
    # 60 second timeout (3 block times iof syncing from tip)
    sync_to(network=network, slot_num=slot_num, timeout=60)

    date_time = datetime(
        year=2022, month=12, day=22, hour=7, minute=13, second=26, tzinfo=timezone.utc
    )
    res = get_date_time_to_slot_number(network=network, date_time=date_time)
    logger.info(f"slot info: {res}")

    current = res["current"]
    assert (
        current != None
        and current["slot_number"] == 16010006
        and current["block_hash"]
        == "65b13e1227c36a3327fb1333ae801d15c50c7f5af66919d467befce8d67a4284"
    )

    previous = res["previous"]
    assert (
        previous != None
        and previous["slot_number"] == 16009980
        and previous["block_hash"]
        == "2e8475d3c4cf7fb97fa6d99ab29e05b39635b99253f1e27b9097acf5c4f4239d"
    )

    next = res["next"]
    assert (
        next != None
        and next["slot_number"] == 16010056
        and next["block_hash"]
        == "9768fb8df7c3e336da30c82dd93dc664135f866080c773402b528288c970c5b0"
    )
