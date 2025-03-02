import typer

from requests.exceptions import HTTPError
import requests
import json
from hashlib import blake2b
from bitcoin.segwit_addr import bech32_encode, convertbits
import threading
import multiprocessing
from pprint import pprint


# Typer is a library for building CLI applications
app = typer.Typer()


@app.command()
def snapshot(
    bearer_token: str = (typer.Option(...)),
    api_key: str = (typer.Option(...)),
    host: str = (typer.Option(...)),
    slot_no: str = (typer.Option(...)),
):
    """
    Generate snapshot given slot no.
    Writes valids to snapshot.json and
    any unsuccessful attempts to snapshot_errors.json
    """

    snapshot_data = []
    snapshot_data_errors = []

    url = f"{host}/api/v1/cardano/registration/cip36?lookup=ALL&asat=SLOT:{slot_no}"
    headers = {"Authorization": bearer_token, "X-API-Key": api_key}

    try:
        response = requests.get(url, headers=headers)
        registrations = json.loads(response.text)["voting_key"]
        pprint(f"Registratons to process {len(registrations)}")

        # The number of usable CPUs can be obtained with os.process_cpu_count()
        pprint(f"You have this many usable cpus {multiprocessing.cpu_count()}")

        thread_list = []

        # chunk and process registrations in parallel
        chunks = split_list(registrations, multiprocessing.cpu_count())

        for chunk in chunks:
            thread_list.append(
                threading.Thread(
                    target=process_chunk,
                    args=(
                        chunk,
                        bearer_token,
                        api_key,
                        host,
                        snapshot_data,
                        snapshot_data_errors,
                    ),
                )
            )

        for thread in thread_list:
            thread.start()

        for thread in thread_list:
            thread.join()

    except HTTPError as e:
        pprint(e.response.text)

    # Convert and write JSON object to file
    with open("snapshot.json", "w") as outfile:
        json.dump(snapshot_data, outfile, indent=2)

    # Convert and write JSON object to file
    with open("snapshot_errors.json", "w") as outfile:
        json.dump(snapshot_data_errors, outfile, indent=2)

    pprint(f"Number of registrations in snapshot file: {len(snapshot_data)}")
    pprint(f"Number of errors in snapshot file: {len(snapshot_data_errors)}")


def process_chunk(
    chunk_of_registrations: list,
    bearer_token: str,
    api_key: str,
    host: str,
    snapshot_data: list,
    snapshot_data_errors: list,
):
    """
    Process chunk of registrations.
    """
    for registration in chunk_of_registrations:
        # latest registration

        # TODO: CROSSREFERENCE
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
            registration["stake_addr"] = stake_address
            snapshot_data_errors.append(registration)
            continue

        json_data = json.loads(response.text)

        registration["registrations"][0]["voting_power"] = json_data["persistent"][
            "ada_amount"
        ]
        snapshot_data.append(registration["registrations"][0])

        if len(snapshot_data) % 500 == 0:
            pprint(f"Registrations processed:{len(snapshot_data)}")


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
    """
    n = min(parts, max(len(l), 1))
    k, m = divmod(len(l), n)
    return [l[i * k + min(i, m) : (i + 1) * k + min(i + 1, m)] for i in range(n)]


@app.command()
def compare(
    legacy_snapshot: str = (typer.Option(...)),
    gateway_snapshot: str = (typer.Option(...)),
):
    """
    Compares legacy and gateway snapshots for parity and writes
    match and no match files to file for further processing.
    """

    matches = []
    no_match = []

    # Open and read the legacy snapshot JSON file
    with open(legacy_snapshot, "r") as file:
        legacy = json.load(file)

    # ...... gateway snapshot ..
    with open(gateway_snapshot, "r") as file:
        gateway = json.load(file)

    pprint(f"Number of legacy registrations {len(legacy)}")
    pprint(f"Number of gateway registrations {len(gateway)}")

    # Iterate through every legacy registration and then look for a corresponding match in
    # the new gateway registrations snapshot to ensure parity.
    for legacy_registration in legacy:
        for gateway_registration in gateway:
            if (
                legacy_registration["stake_public_key"]
                == gateway_registration["stake_pub_key"]
            ):

                if (
                    legacy_registration["voting_power"]
                    == gateway_registration["voting_power"]
                ):
                    legacy_registration["legacy"] = True
                    gateway_registration["gateway"] = True
                    matches.append((legacy_registration, gateway_registration))
                else:
                    legacy_registration["legacy"] = True
                    gateway_registration["gateway"] = True
                    no_match.append((legacy_registration, gateway_registration))

    pprint(f"Matches:{len(matches)}")
    pprint(f"No Matches:{len(no_match)}")

    # Convert and write JSON object to file
    with open("no_matches.json", "w") as outfile:
        json.dump(no_match, outfile, indent=2)

    with open("matches.json", "w") as outfile:
        json.dump(matches, outfile, indent=2)


if __name__ == "__main__":
    app()
