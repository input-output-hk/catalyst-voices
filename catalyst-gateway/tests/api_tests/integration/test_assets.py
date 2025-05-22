import json
import os
import codecs

import pytest
from loguru import logger
from api.v1 import cardano


@pytest.mark.preprod_indexing
def test_persistent_ada_amount_endpoint():
    # could the file from https://github.com/input-output-hk/catalyst-storage/blob/main/cardano-asset-preprod.json
    ASSETS_DATA_PATH = os.environ["ASSETS_DATA_PATH"]
    # 10% failure rate
    ALLOWED_FAILURE_RATE = 0.1

    test_data: dict[str, any] = {}
    with open(ASSETS_DATA_PATH) as f:
        test_data = json.load(f)

    checks = 0
    failures = 0

    total_len = len(test_data)
    for i, (stake_addr, entry) in enumerate(test_data.items()):
        logger.info(f"Checking: '{stake_addr}'... ({i + 1}/{total_len})")

        resp = cardano.assets(stake_addr, entry["slot_number"])
        if (
            entry["ada_amount"] == 0
            and len(entry["native_tokens"]) == 0
            and resp.status_code == 404
        ):
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
        received_ada = assets["persistent"]["ada_amount"]
        expected_ada = entry["ada_amount"]

        checks += 1
        if received_ada != expected_ada:
            logger.error(
                f"Assertion failed: Ada amount for '{stake_addr}', expected: {expected_ada}, received: {received_ada}"
            )
            failures += 1

        # check assets
        received_assets = {
            (
                item["policy_hash"]
                + codecs.decode(item["asset_name"], "unicode_escape")
                .encode("latin1")
                .hex()
            ): item["amount"]
            for item in assets["persistent"]["assets"]
        }
        expected_assets = entry["native_tokens"]

        checks += 1
        if received_assets != expected_assets:
            logger.error(
                f"Assertion failed: Native Assets for '{stake_addr}', expected: {expected_assets}, received: {received_assets}"
            )
            failures += 1

    assert failures / checks <= ALLOWED_FAILURE_RATE
    logger.info(
        f"Final failure rate is {failures / checks}, Allowed: {ALLOWED_FAILURE_RATE} "
    )
