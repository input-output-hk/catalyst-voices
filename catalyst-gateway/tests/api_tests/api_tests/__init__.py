"""Utilities for testing schema mismatch behavior."""

import sys
from loguru import logger
import requests
import math
from datetime import datetime
import os

try:
   os.environ["CAT_GATEWAY_TEST_URL"]
except KeyError:
   print ("Please set the environment variable CAT_GATEWAY_TEST_URL")
   sys.exit(1)

try:
   os.environ["EVENT_DB_TEST_URL"]
except KeyError:
   print("Please set the environment variable EVENT_DB_TEST_URL")
   sys.exit(1)

EVENT_DB_TEST_URL = os.environ["EVENT_DB_TEST_URL"]
CAT_GATEWAY_TEST_URL = os.environ["CAT_GATEWAY_TEST_URL"]


def cat_gateway_endpoint_url(endpoint: str):
    return f"{CAT_GATEWAY_TEST_URL}/{endpoint}"

def get_staked_ada(address: str, network: str, slot_number: int):
    resp = requests.get(
        cat_gateway_endpoint_url(
            f"api/cardano/staked_ada/{address}?network={network}&slot_number={slot_number}"
        )
    )
    assert resp.status_code == 200 or resp.status_code == 404
    if resp.status_code == 200:
        return resp.json()


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


def get_voter_registration(address: str, network: str, slot_number: int):
    resp = requests.get(
        cat_gateway_endpoint_url(
            f"api/cardano/registration/{address}?network={network}&slot_number={slot_number}"
        )
    )
    assert resp.status_code == 200 or resp.status_code == 404
    if resp.status_code == 200:
        return resp.json()
