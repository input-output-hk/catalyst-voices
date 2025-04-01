import requests
from api import cat_gateway_endpoint_url, BEARER_TOKEN

URL = cat_gateway_endpoint_url("api/v1/cardano")


# cardano assets GET
def assets(stake_address: str, slot_no: int):
    url = f"{URL}/assets/{stake_address}?asat=SLOT:{slot_no}"
    headers = {
        "Authorization": f"Bearer {BEARER_TOKEN}",
        "Content-Type": "application/json",
    }
    return requests.get(url, headers=headers)
