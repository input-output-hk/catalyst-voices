import requests
from api import cat_gateway_endpoint_url


# cardano assets GET
def assets(stake_address: str, slot_no: int, token: str | None = None):
    url = cat_gateway_endpoint_url(f"api/v1/cardano/assets/{stake_address}?asat=SLOT:{slot_no}")
    headers = {
        "Content-Type": "application/json",
    }

    if token is not None:
        headers["Authorization"] = f"Bearer {token}"
        
    return requests.get(url, headers=headers)
