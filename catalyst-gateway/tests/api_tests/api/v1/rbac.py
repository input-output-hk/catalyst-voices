import requests
from api import cat_gateway_endpoint_url

URL = cat_gateway_endpoint_url("api/v1/rbac/registration")

def get(lookup: str | None, token: str, extra_headers: dict | None = None):
    headers = {
        "Authorization": f"Bearer {token}",
    }
    if extra_headers:
        headers.update(extra_headers)
    return requests.get(URL, headers=headers, params={"lookup": lookup})
