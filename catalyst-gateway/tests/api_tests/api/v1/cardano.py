import requests
from api import cat_gateway_endpoint_url, BEARER_TOKEN

URL = cat_gateway_endpoint_url("api/v1/cardano")


# cardano assets GET
def assets(stake_address: str, slot_no: int, network: str):
    url = f"{URL}/assets/{stake_address}?asat=SLOT:{slot_no}&network={network}"
    headers = {
        "Authorization": f"Bearer {BEARER_TOKEN}",
        "Content-Type": "application/json",
    }
    return requests.get(url, headers=headers)


# cardano cip36 registrations GET
def cip36_registration(lookup: str, slot_no: int, limit: int, valid: bool):
    url = f"{URL}/registration/cip36?asat=SLOT:{slot_no}&lookup={lookup}&limit={limit}&invalid={not valid}"
    headers = {
        "Authorization": f"Bearer {BEARER_TOKEN}",
        "Content-Type": "application/json",
    }
    return requests.get(url, headers=headers)
