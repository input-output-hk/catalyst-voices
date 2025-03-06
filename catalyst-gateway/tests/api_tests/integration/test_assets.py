import pytest
from loguru import logger
from typing import Dict, Any, List
import json
import glob
import re
import os
from utils import address
from api.v1 import cardano


class Snapshot:
    def __init__(self, data: List[Dict[str, Any]], slot_no: int, network: str):
        self.data = data
        self.slot_no = slot_no
        self.network = network


@pytest.fixture
def snapshot() -> Snapshot:
    # snapthot file should follow the following pattern:
    # snapshot-<slot_no>-<network>.json
    files = glob.glob("./test_data/snapshot-*.json")
    with open(files[0]) as snapshot_file:
        snapshot_data = json.load(snapshot_file)
        file_name = os.path.basename(snapshot_file.name)
        res = re.split(r"[-.]+", file_name)
        return Snapshot(snapshot_data, int(res[1]), res[2])


def test_assets_endpoint(snapshot):
    # health.is_live()
    # health.is_ready()

    for entry in snapshot.data:
        expected_amount = entry["voting_power"]
        stake_address = address.stake_public_key_to_address(
            key=entry["stake_public_key"][2:],
            is_stake=True,
            network_type=snapshot.network,
        )
        resp = cardano.assets(stake_address, snapshot.slot_no, snapshot.network)
        assert resp.status_code == 200 or resp.status_code == 404
        if resp.status_code == 200:
            assets = resp.json()
            assert (
                assets["persistent"]["ada_amount"] == expected_amount
            ), f"Not expected ada amount for stake_address: {stake_address}"
        # it is possible that snapshot tool collected data for the stake key which does not have any unspent utxo
        # at this case cat-gateway return 404, that is why we are checking this case additionally
        if resp.status_code == 400:
            assert expected_amount == 0
