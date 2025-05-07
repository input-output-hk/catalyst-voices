import json
import os

import pytest
from loguru import logger
from utils.address import stake_public_key_to_address
from api.v1 import cardano


@pytest.mark.preprod_indexing
def test_persistent_ada_amount_endpoint():
    ASSETS_DATA_PATH = os.environ["ASSETS_DATA_PATH"]

    test_data: dict[str, any] = {}
    with open(ASSETS_DATA_PATH) as f:
        test_data = json.load(f)

    total_len = len(test_data)
    for i, (stake_addr, entry) in enumerate(test_data.items()):
        logger.info(f"Checking '{stake_addr}'... ({i + 1}/{total_len})")
        
        resp = cardano.assets(
            stake_addr,
            entry["slot_number"]
        )
        if entry["ada_amount"] == 0 and resp.status_code == 404:
            # it is possible that snapshot tool collected data for the stake key which does not have any unspent utxo
            # at this case cat-gateway return 404, that is why we are checking this case additionally
            continue

        # check that it should exist
        assert (
            resp.status_code == 200
        ), f"Cannot find assets for stake_address: {stake_addr}"

        assets = resp.json()

        # check ada amount
        received_amt = int(assets["persistent"]["ada_amount"] / 10e5)
        expected_amt = entry["ada_amount"]
        assert (
            received_amt == expected_amt
        ), f"Not expected ada amount for stake_address: {stake_addr}, expected: {expected_amt}, received: {received_amt}"

        # check total assets count
        # TODO:
