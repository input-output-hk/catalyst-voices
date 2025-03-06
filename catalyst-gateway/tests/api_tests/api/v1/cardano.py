import requests
from api import cat_gateway_endpoint_url, BEARER_TOKEN

URL = cat_gateway_endpoint_url("api/v1/cardano")


# Signed document GET
def assets(stake_address: str, slot_no: int, network: str):
    document_url = f"{URL}/assets/{stake_address}?asat=SLOT:{slot_no}&network={network}"
    headers = {
        "Authorization": f"Bearer {BEARER_TOKEN}",
        "Content-Type": "application/json",
    }
    return requests.get(document_url, headers=headers)
