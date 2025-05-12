import pytest
from loguru import logger
from utils.address import stake_public_key_to_address
from utils.snapshot import snapshot
from utils.rbac_chain import rbac_chain_factory
from api.v1 import cardano


@pytest.mark.skip
def test_persistent_ada_amount_endpoint(snapshot, rbac_chain_factory):
    logger.info(f"{snapshot.network}, {snapshot.slot_no}")
    rbac_chain = rbac_chain_factory()

    total_len = len(snapshot.data)
    for i, entry in enumerate(snapshot.data):
        logger.info(f"Checking .... {round(i / total_len * 100, 1)}%")
        expected_amount = entry["voting_power"]
        stake_address = stake_public_key_to_address(
            key=entry["stake_public_key"][2:],
            is_stake=True,
            network_type=snapshot.network,
        )
        resp = cardano.assets(
            stake_address,
            snapshot.slot_no,
            rbac_chain.auth_token(),
        )
        if expected_amount == 0 and resp.status_code == 404:
            # it is possible that snapshot tool collected data for the stake key which does not have any unspent utxo
            # at this case cat-gateway return 404, that is why we are checking this case additionally
            continue

        assert (
            resp.status_code == 200
        ), f"Cannot find assets for stake_address: {stake_address}"
        assets = resp.json()
        if assets["persistent"]["ada_amount"] != expected_amount:
            logger.error(
                f"Not expected ada amount for stake_address: {stake_address}, {entry["stake_public_key"]}"
            )
        # assert (
        #     assets["persistent"]["ada_amount"] == expected_amount
        # ), f"Not expected ada amount for stake_address: {stake_address}, {entry["stake_public_key"]}"
