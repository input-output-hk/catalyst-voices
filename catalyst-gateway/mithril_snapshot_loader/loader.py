#!/usr/bin/env python3

# cspell: words tqdm

import argparse
import rich
from rich import print
import os
import enum
import requests
from tqdm import tqdm

# This script loads latest mithril snapshot archive


class NetworkType(enum.Enum):
    Mainnet = "mainnet"
    Testnet = "testnet"
    Preprod = "preprod"
    Preview = "preview"

    def get_aggregator_url(self):
        match self:
            case NetworkType.Mainnet:
                return "https://aggregator.release-mainnet.api.mithril.network/aggregator/artifact/snapshots"
            case NetworkType.Testnet:
                return "https://aggregator.testing-preview.api.mithril.network/aggregator/artifact/snapshots"
            case NetworkType.Preprod:
                return "https://aggregator.release-preprod.api.mithril.network/aggregator/artifact/snapshots"
            case NetworkType.Preview:
                return "https://aggregator.pre-release-preview.api.mithril.network/aggregator/artifact/snapshots"


def load_snapshot(network_type: NetworkType, out: str):
    resp = requests.get(network_type.get_aggregator_url())
    # getting the latest snapshot from the list, it's always on the first position
    snapshot_info = resp.json()[0]

    location = snapshot_info["locations"][0]
    # load archive
    resp = requests.get(location, stream=True)
    content_size = int(resp.headers.get("Content-length"))
    with open(out, "wb") as file:
        with tqdm(total=content_size) as t:
            chunk_size = 1024
            for chunk in resp.iter_content(chunk_size=chunk_size):
                file.write(chunk)
                t.update(chunk_size)


def main():
    # Force color output in CI
    rich.reconfigure(color_system="256")

    parser = argparse.ArgumentParser(description="Mithril snapshot loading.")
    parser.add_argument(
        "--network",
        type=NetworkType,
        help="Cardano network type, available options: ['mainnet', 'testnet', 'preprod', 'preview']",
    )
    parser.add_argument("--out", help="Out file name of the snapshot archive")
    args = parser.parse_args()

    load_snapshot(args.network, args.out)


if __name__ == "__main__":
    main()
