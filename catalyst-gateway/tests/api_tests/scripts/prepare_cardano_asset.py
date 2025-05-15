# cspell: words cloudscraper

"""
This script is a simple tool to prepare testing data for the `cardano/asset` endpoint.
"""

import json
import os
import requests
from loguru import logger

from utils import address

# relative path to this script file for the output snapshot file
OUT_FILE = os.environ["CARDANO_ASSETS_OUTPUT_FILE"]

# the snapshot file to read as a reference of stake addresses list
IN_FILE = os.environ["CARDANO_ASSETS_INPUT_FILE"]

# blockfrost.io token value
BLOCKFROST_TOKEN = os.environ["BLOCKFROST_TOKEN"]

# cardano network type
CARDANO_NETWORK = os.environ["CARDANO_NETWORK"]

BLOCKFROST_URL = f"https://cardano-{CARDANO_NETWORK}.blockfrost.io/api/v0"

RECORDS_LIMIT = 100
START_POSITION = 0


def get_reguest(s: requests.Session, url: str):
    resp = s.get(url=url, headers={"project_id": BLOCKFROST_TOKEN})
    assert resp.status_code == 200, f"req: {url}, resp: {resp.text}"
    return resp.json()


# ----- process -----

# read the snapshot file
with open(IN_FILE, "r", encoding="utf-8") as f:
    snapshot_data = json.load(f)

try:
    # open output file if already exists to write into it
    with open(OUT_FILE, "r", encoding="utf-8") as f:
        formatted_records = json.load(f)
except:
    formatted_records = {}

# process each record
s = requests.Session()
formatted_records = {}
processing_records = snapshot_data[START_POSITION : START_POSITION + RECORDS_LIMIT]
logger.info(
    f"Start processing start: {START_POSITION}, end: {START_POSITION + min(len(processing_records), RECORDS_LIMIT)}"
)
for i, record in enumerate(processing_records):
    stake_addr = address.stake_public_key_to_address(
        key=record["stake_public_key"][2:], is_stake=True, network_type="preprod"
    )

    logger.info(
        f"Checking: '{stake_addr}'... ({i + 1}/{min(len(processing_records), RECORDS_LIMIT)})"
    )

    addresses = get_reguest(
        s,
        f"{BLOCKFROST_URL}/accounts/{stake_addr}/addresses",
    )

    ada_amount = 0
    native_tokens = {}
    for addr in addresses:
        addr = addr["address"]
        addr_info = get_reguest(
            s,
            f"{BLOCKFROST_URL}/addresses/{addr}",
        )
        for amount in addr_info["amount"]:
            if amount["unit"] == "lovelace":
                ada_amount += int(amount["quantity"])
                continue
            native_tokens[f"0x{amount["unit"]}"] = native_tokens.get(
                amount["unit"], 0
            ) + int(amount["quantity"])

    # get slot number
    latest_block = get_reguest(
        s,
        f"{BLOCKFROST_URL}/blocks/latest",
    )

    slot_number = latest_block["slot"]
    formatted_records[stake_addr] = {
        "ada_amount": ada_amount,
        "native_tokens": native_tokens,
        "slot_number": slot_number,
    }

# write into a file
with open(OUT_FILE, "w") as f:
    json.dump(formatted_records, f, indent=2)

logger.info(
    f"Completed preparing data, start: {START_POSITION}, end: {START_POSITION + min(len(processing_records), RECORDS_LIMIT)}"
)
