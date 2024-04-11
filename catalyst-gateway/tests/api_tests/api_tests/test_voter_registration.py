import json
from loguru import logger
from api_tests import (
    check_is_live,
    check_is_ready,
    get_voter_registration,
    sync_to,
    utils,
)


def check_delegations(provided, expected):
    if type(expected) is list:
        for i in range(0, len(expected)):
            expected_voting_key = expected[i][0]
            expected_power = expected[i][1]
            provided_voting_key = provided[i]["voting_key"]
            provided_power = provided[i]["power"]
            assert (
                expected_voting_key == provided_voting_key
                and expected_power == provided_power
            )
    else:
        assert provided == expected


def test_voter_registration_endpoint():
    check_is_live()
    check_is_ready()

    network = "preprod"
    slot_num = 56364174

    # block hash `871b1e4af4c2d433618992fb1c1b5c1182ab829a236d58a4fcc82faf785b58cd`
    # 60 second timeout (3 block times iof syncing from tip)
    sync_to(network=network, slot_num=slot_num, timeout=60)

    snapshot_tool_data = json.load(open("./snapshot_tool-56364174.json"))
    for entry in snapshot_tool_data:
        expected_rewards_address = entry["rewards_address"]
        expected_nonce = entry["nonce"]
        stake_address = utils.stake_public_key_to_address(
            key=entry["stake_public_key"][2:], is_stake=True, network_type=network
        )
        res = get_voter_registration(
            stake_address, network=network, slot_number=slot_num
        )
        logger.info(f"checking stake address: {stake_address}")
        # it is possible that snapshot tool collected data for the stake key which does not have any unspent utxo
        # at this case cat-gateway return 404, that is why we are checking this case additionally
        logger.info(f"curent: {res}, expected: {entry}")
        assert (
            res["rewards_address"] == expected_rewards_address
            and res["nonce"] == expected_nonce
        )
        check_delegations(res["voting_info"], entry["delegations"])
