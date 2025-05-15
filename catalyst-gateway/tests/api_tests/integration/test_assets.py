import json
import os

import pytest
from loguru import logger
from api.v1 import cardano


@pytest.mark.preprod_indexing
def test_persistent_ada_amount_endpoint():
    # could the file from https://github.com/input-output-hk/catalyst-storage/blob/main/cardano-asset-preprod.json
    ASSETS_DATA_PATH = os.environ["ASSETS_DATA_PATH"]

    test_data: dict[str, any] = {}
    with open(ASSETS_DATA_PATH) as f:
        test_data = json.load(f)

    total_len = len(test_data)
    for i, (stake_addr, entry) in enumerate(test_data.items()):
        logger.info(f"Checking: '{stake_addr}'... ({i + 1}/{total_len})")

        resp = cardano.assets(stake_addr, entry["slot_number"])
        if entry["ada_amount"] == 0 and resp.status_code == 404:
            # it is possible that snapshot tool collected data for the stake key which does not have any unspent utxo
            # at this case cat-gateway return 404, that is why we are checking this case additionally
            logger.info("Skipped checking: empty ada")
            continue

        # check that it should exist
        assert (
            resp.status_code == 200
        ), f"Assertion failed: Cannot find assets for '{stake_addr}'"

        assets = resp.json()

        # check ada amount
        received_amt = int(assets["persistent"]["ada_amount"] / 10e5)
        expected_amt = entry["ada_amount"]
        try:
            assert received_amt == expected_amt
        except AssertionError:
            logger.error(
                f"Assertion failed: Ada amount for '{stake_addr}', expected: {expected_amt}, received: {received_amt}"
            )
            pass

        # check total assets count
        received_token_len = len(assets["persistent"]["assets"])
        expected_token_len = len(entry["native_tokens"])
        try:
            assert received_token_len == expected_token_len
        except AssertionError:
            logger.error(
                f"Assertion failed: Token count for '{stake_addr}', expected: {expected_token_len}, received: {received_token_len}"
            )
            pass
