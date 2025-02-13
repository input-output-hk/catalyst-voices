from loguru import logger
import pytest
from utils import sync
from utils import health
from datetime import datetime, timezone
import requests
from api_tests import cat_gateway_endpoint_url

@pytest.mark.skip('To be refactored when the api is ready')
def test_date_time_to_slot_number_endpoint():
    health.is_live()
    health.is_ready()

    network = "preprod"
    slot_num = 16010056

    # block hash `65b13e1227c36a3327fb1333ae801d15c50c7f5af66919d467befce8d67a4284`
    # 60 second timeout (3 block times iof syncing from tip)
    sync.sync_to(network=network, slot_num=slot_num, timeout=60)

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

def get_date_time_to_slot_number(network: str, date_time: datetime):
    # replace special characters
    date_time = date_time.isoformat().replace(":", "%3A").replace("+", "%2B")
    resp = requests.get(
        cat_gateway_endpoint_url(
            f"api/cardano/date_time_to_slot_number?network={network}&date_time={date_time}"
        )
    )
    assert resp.status_code == 200
    return resp.json()
