"""
This script is a simple web scraper tool to prepare testing data for the `cardano/asset` endpoint.

Prerequisites before running this script:
- Make sure that you have `BeautifulSoup`, `cloudscraper`, and `certifi` installed.
- Make sure that you have a snapshot file available for this script, can get one from the `catalyst-storage` repo.
- Fill your own client params to `CF_CLEARANCE` and `USER_AGENT`. Other variables can be configured to fit the need.
"""

import json
import os
import time
import cloudscraper
import certifi
from decimal import Decimal

from utils import address
from bs4 import BeautifulSoup

# ----- variables -----
MAX_ATTEMPT = 3

# provide yours here, can acquire `CF_CLEARANCE` by going to `https://preprod.cexplorer.io`,
# and extract this field from the cookies header using the `network` tab
CF_CLEARANCE = ""

# can be something like "Mozilla/5.0"
USER_AGENT = ""

# relative path to this script file for the output
OUT_FILE = "./cardano-asset-80000000-preprod.json"

# the snapshot file to read as a reference of scraping
IN_FILE = "./snapshot-80000000-preprod.json"


# ----- functions -----
def request(url) -> str:
    scraper = cloudscraper.create_scraper()

    response = scraper.get(
        url,
        headers={"User-Agent": USER_AGENT},
        cookies={"cf_clearance": CF_CLEARANCE},
        verify=certifi.where(),
    )

    if response.status_code != 200:
        raise Exception(response.text)

    return response.text


def get_stake_asset_page(stake_addr: str) -> str:
    return request(f"https://preprod.cexplorer.io/stake/{stake_addr}/asset")


def get_stake_data_page(stake_addr: str) -> str:
    return request(f"https://preprod.cexplorer.io/stake/{stake_addr}")


def get_index_page() -> str:
    return request("https://preprod.cexplorer.io/")


def get_asset_page(asset: str) -> str:
    return request(f"https://preprod.cexplorer.io/asset/{asset}")


def epoch_2_slot(epoch: int) -> int:
    shelley_start_epoch = 208
    shelley_start_slot = 88_416_000
    slots_per_epoch = 432_000

    if epoch < shelley_start_epoch:
        raise Exception("Epochs before 208 (Byron era) have a different slot timing")

    return shelley_start_slot + (epoch - shelley_start_epoch) * slots_per_epoch

# ----- process -----

# read the snapshot file
snapshot_path = os.path.join(os.path.dirname(__file__), IN_FILE)
with open(snapshot_path, "r", encoding="utf-8") as f:
    snapshot_data = json.load(f)

# process each record
formatted_records = {}
processing_records = snapshot_data[:]
for i, record in enumerate(processing_records):
    stake_addr = address.stake_public_key_to_address(
        key=record["stake_public_key"][2:],
        is_stake=True,
        network_type="preprod"
    )

    attempt_count = 0

    while attempt_count < MAX_ATTEMPT:
        try:
            print(f"Scraping {stake_addr}... ({i + 1}/{len(processing_records)})")

            # extracting - stake/:stake_id
            stake_html = get_stake_data_page(stake_addr)
            stake_dom = BeautifulSoup(stake_html, "html.parser")

            found_result = stake_dom.select_one("div.container-fluid").get_text(strip=True)
            if "404 - address not found" in found_result:
                print("    Skipped NOT FOUND")
                break

            stake_status = stake_dom.select_one("table.table span.badge").get_text(strip=True)
            if stake_status.lower() == "inactive":
                print("    Skipped INACTIVE")
                break

            ada_amount_txt = stake_dom.select_one("table.table tr:nth-child(5) span[title]:nth-child(2)")
            ada_amount = int(Decimal(ada_amount_txt.attrs["title"].replace(",", "")))

            # extracting - index
            index_html = get_index_page()
            index_dom = BeautifulSoup(index_html, "html.parser")

            epoch_number_txt = index_dom.select_one("#_epoch_no")
            epoch_number = int(epoch_number_txt.attrs["data-value"])
            slot_number = epoch_2_slot(epoch_number)

            # extracting - stake/:stake_id/asset
            stake_asset_dom = BeautifulSoup(get_stake_asset_page(stake_addr), "html.parser")

            item_rows = stake_asset_dom.select("div.table-responsive table > thead > tr > td > a")
            amount_rows = stake_asset_dom.select("div.table-responsive table > thead > tr > td:nth-child(6) > span")

            native_tokens = []
            for j, (item_row, amount_row) in enumerate(zip(item_rows, amount_rows)):
                asset_name = "\n".join(item_row.get_text().split("\n")[2:-2]).strip()
                asset_url = item_row.attrs["href"]
                amount = int(Decimal(amount_row.attrs["title"].replace(",", "")))

                print(f"    Extracting asset {asset_url}... ({j + 1}/{len(item_rows)})")

                # extracting - asset/:asset_id
                asset_html = request(f"https://preprod.cexplorer.io{asset_url}")
                asset_dom = BeautifulSoup(asset_html, "html.parser")

                policy_hash = asset_dom.select_one("div.container-fluid > div > div:nth-child(2) > a")
                policy_hash = policy_hash.get_text(strip=True)

                native_tokens.append({
                    "policy_hash": f"0x{policy_hash}",
                    "asset_name": asset_name,
                    "amount": amount
                })

            if stake_addr in formatted_records:
                print("    Warning OVERRIDDEN STAKE ADDRESS")

            formatted_records[stake_addr] = {
                "ada_amount": ada_amount,
                "native_tokens": native_tokens,
                "slot_number": slot_number,
            }

            break
        except Exception as e:
            print(f"ERROR: {e}")

            if attempt_count >= MAX_ATTEMPT:
                print("    Skipped MAX ATTEMPT REACHED")
                break

            time.sleep(3)
            print("Retrying...")
            attempt_count += 1

# write into a file
write_file_path = os.path.join(os.path.dirname(__file__), OUT_FILE)
with open(write_file_path, "w") as f:
    json.dump(formatted_records, f, indent=2)

print("Completed preparing data")
