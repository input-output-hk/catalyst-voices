import typer
import logging
from requests.exceptions import HTTPError
import requests
import json
from hashlib import blake2b
from bitcoin.segwit_addr import bech32_encode, convertbits
import threading
import multiprocessing

app = typer.Typer()

logger = logging.getLogger()
logger.setLevel("INFO")

new_snap = []
error_staked_ada = []


@app.command()
def snapshot(
    slot_no: str = (typer.Option(...)),
    bearer_token: str = (typer.Option(...)),
    api_key: str = (typer.Option(...)),
    host: str = (typer.Option(...)),
):
    """
    Generate snapshot given slot no.
    """
    url = f"{host}/api/v1/cardano/registration/cip36?lookup=ALL&asat=SLOT:{slot_no}"
    headers = {"Authorization": bearer_token, "X-API-Key": api_key}

    try:
        response = requests.get(url, headers=headers)
        registrations = json.loads(response.text)["voting_key"]
        print(f"Registratons to process {len(registrations)}")

        # The number of usable CPUs can be obtained with os.process_cpu_count()
        print(f"You have this many usable cpus {multiprocessing.cpu_count()}")

        thread_list = []

        chunks = split_list(registrations, multiprocessing.cpu_count())

        for chunk in chunks:
            thread_list.append(
                threading.Thread(
                    target=process_chunk, args=(chunk, bearer_token, api_key, host)
                )
            )

        for thread in thread_list:
            thread.start()

        for thread in thread_list:
            thread.join()

    except HTTPError as e:
        logger.error(print(e.response.text))

    # Convert and write JSON object to file
    with open("new_snap3.json", "w") as outfile:
        json.dump(new_snap, outfile)

    # Convert and write JSON object to file
    with open("new_error_snap3.json", "w") as outfile:
        json.dump(error_staked_ada, outfile)

    print(f"Number of registrations in snapshot file: {len(new_snap)}")
    print(f"Number of errors in snapshot file: {len(error_staked_ada)}")


def process_chunk(chunk: list, bearer_token: str, api_key: str, host: str):

    for registration in chunk:
        # latest registration
        latest_stake_pub_key = registration["registrations"][0]["stake_pub_key"]

        # latest regsistration slot no to query staked ada
        slot_num = registration["registrations"][0]["slot_no"]

        stake_address = stake_public_key_to_address(
            key=latest_stake_pub_key[2:],
            is_stake=True,
            network_type="mainnet",
        )

        if stake_address == None:
            continue

        url = f"{host}/api/v1/cardano/assets/{stake_address}?{slot_num}"
        headers = {"Authorization": bearer_token, "X-API-Key": api_key}

        response = requests.get(url, headers=headers)
        if response.status_code != 200:
            error_staked_ada.append(
                str(registration["registrations"][0]) + "stake_addr:" + stake_address
            )

            continue

        json_data = json.loads(response.text)

        registration["registrations"][0]["voting_power"] = json_data["persistent"][
            "ada_amount"
        ]
        new_snap.append(registration["registrations"][0])

        if len(new_snap) % 500 == 0:
            print(f"Registrations processed:{len(new_snap)}")


def stake_public_key_to_address(key: str, is_stake: bool, network_type: str):
    """
    According to [CIP-19](https://cips.cardano.org/cips/cip19/).
    """

    key_bytes = bytes.fromhex(key)
    key_hash = blake2b(key_bytes, digest_size=28)
    header = stake_header(is_stake=is_stake, network_type=network_type)
    key_hash_with_header = header.to_bytes(1, "big") + key_hash.digest()

    if network_type == "mainnet":
        hrp = "stake"
    elif (
        network_type == "testnet"
        or network_type == "preprod"
        or network_type == "preview"
    ):
        hrp = "stake_test"
    else:
        raise f"Unknown network type: {network_type}"

    return bech32_encode(hrp, convertbits(key_hash_with_header, 8, 5))


def stake_header(is_stake: bool, network_type: str):
    if is_stake:
        # stake key hash
        typeid = int("1110", 2)
    else:
        # script hash
        typeid = int("1111", 2)
    if network_type == "mainnet":
        network_id = 1
    elif (
        network_type == "testnet"
        or network_type == "preprod"
        or network_type == "preview"
    ):
        network_id = 0
    else:
        raise f"Unknown network type: {network_type}"

    typeid = typeid << 4
    return typeid | network_id


def split_list(l: list, parts: int) -> list:
    """Takes a list as input, and splits it into "parts" number of sub-lists,
    which are then inserted as elements in the returned meta-list.

    The function will try to make the sub-lists as equal in length as
    possible, so running
    split_list( [1, 2, 3, 4, 5, 6], 4 )
    will return
    [ [1, 2], [3, 4], [5], [6] ]

    I will also make sure that the list isn't split into more parts than
    there are elements in the list, so
    split_list( [a, b], 6 )
    will return
    [ [a], [b] ]
    """
    n = min(parts, max(len(l), 1))
    k, m = divmod(len(l), n)
    return [l[i * k + min(i, m) : (i + 1) * k + min(i + 1, m)] for i in range(n)]


if __name__ == "__main__":
    typer.run(snapshot)
