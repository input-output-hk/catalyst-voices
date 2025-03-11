import pytest
import json
import glob
import re
import os
from typing import Dict, Any, List


class Snapshot:
    def __init__(self, data: List[Dict[str, Any]], slot_no: int, network: str):
        self.data = data
        self.slot_no = slot_no
        self.network = network


@pytest.fixture
def snapshot() -> Snapshot:
    # snapshot file should follow the following pattern:
    # snapshot-<slot_no>-<network>.json
    files = glob.glob("./test_data/snapshot-*.json")
    with open(files[0]) as snapshot_file:
        snapshot_data = json.load(snapshot_file)
        file_name = os.path.basename(snapshot_file.name)
        res = re.split(r"[-.]+", file_name)
        return Snapshot(snapshot_data, int(res[1]), res[2])
