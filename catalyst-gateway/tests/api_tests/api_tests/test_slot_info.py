from loguru import logger
import pytest

from api_tests import (
    check_is_live,
    check_is_ready,
    sync_to,
    get_date_time_to_slot_number,
)
from datetime import datetime, timezone

@pytest.mark.skip
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

    assert (
        res["current"] != None
        and res["current"]["slot_number"] == 16010006
        and res["current"]["block_hash"]
        == "0x65b13e1227c36a3327fb1333ae801d15c50c7f5af66919d467befce8d67a4284"
    )

    assert (
        res["previous"] != None
        and res["previous"]["slot_number"] == 16009980
        and res["previous"]["block_hash"]
        == "0x2e8475d3c4cf7fb97fa6d99ab29e05b39635b99253f1e27b9097acf5c4f4239d"
    )

    assert (
        res["next"] != None
        and res["next"]["slot_number"] == 16010056
        and res["next"]["block_hash"]
        == "0x9768fb8df7c3e336da30c82dd93dc664135f866080c773402b528288c970c5b0"
    )
